#!/bin/bash
set -xe

. "$(dirname "$0")"/../common.sh

{
ensure_lfs_path_set && ensure_not_root_user

VERSION="2.38"
PACKAGE_NAME=glibc-$VERSION

pushd "$LFS/sources"

rm -rf $PACKAGE_NAME
tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
	case $(uname -m) in
		i?86)   ln -sfv ld-linux.so.2 $LFS/lib/ld-lsb.so.3
		;;
		x86_64) ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64
				ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64/ld-lsb-x86-64.so.3
		;;
	esac

	patch -Np1 -i ../glibc-2.38-fhs-1.patch

	mkdir -v build
	cd build

	echo "rootsbindir=/usr/sbin" > configparms

	../configure								\
		--prefix=/usr							\
		--host=$LFS_TGT							\
		--build="$(../scripts/config.guess)"	\
		--enable-kernel=4.14					\
		--with-headers=$LFS/usr/include			\
		libc_cv_slibdir=/usr/lib

	make
	make DESTDIR="$LFS" install
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "/tmp/$LOG_FILE"
