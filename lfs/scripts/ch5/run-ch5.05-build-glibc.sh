#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_lfs_path_set && ensure_not_root_user

VERSION="2.41"
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

	patch -Np1 -i ../$PACKAGE_NAME-fhs-1.patch

	mkdir -v build
	pushd build

	echo "rootsbindir=/usr/sbin" > configparms

	../configure														\
		--prefix=/usr													\
		--host=$LFS_TGT												\
		--build="$(../scripts/config.guess)"	\
		--enable-kernel=5.4										\
		--with-headers=$LFS/usr/include				\
		--disable-nscd												\
		libc_cv_slibdir=/usr/lib

	make
	make DESTDIR="$LFS" install

	# Fix a hard coded path to the executable loader in the ldd script
	sed '/RTLDLIST=/s@/usr@@g' -i $LFS/usr/bin/ldd

	popd
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"
