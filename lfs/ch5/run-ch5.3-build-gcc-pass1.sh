#!/bin/bash
set -xe

. "$(dirname "$0")"/../common.sh

{
ensure_lfs_path_set && ensure_not_root_user

VERSION="13.2.0"
PACKAGE_NAME=gcc-$VERSION

pushd "$LFS/sources"

rm -rf $PACKAGE_NAME
tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

tar -xf ../mpfr-4.2.0.tar.xz
mv -v mpfr-4.2.0 mpfr
tar -xf ../gmp-6.3.0.tar.xz
mv -v gmp-6.3.0 gmp
tar -xf ../mpc-1.3.1.tar.gz
mv -v mpc-1.3.1 mpc

time {
	case $(uname -m) in
	x86_64)
		sed -e '/m64=/s/lib64/lib/' \
			-i.orig gcc/config/i386/t-linux64
	;;
	esac

	mkdir -v build
	cd build

	../configure					\
		--target=$LFS_TGT			\
		--prefix=$LFS/tools			\
		--with-glibc-version=2.38 	\
		--with-sysroot=$LFS			\
		--with-newlib				\
		--without-headers			\
		--enable-default-pie		\
		--enable-default-ssp		\
		--disable-nls				\
		--disable-shared			\
		--disable-multilib			\
		--disable-threads			\
		--disable-libatomic			\
		--disable-libgomp			\
		--disable-libquadmath		\
		--disable-libssp			\
		--disable-libvtv			\
		--disable-libstdcxx			\
		--enable-languages=c,c++

	make
	make install

	cd ..
	cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
		"$(dirname "$($LFS_TGT-gcc -print-libgcc-file-name)")/include/limits.h"
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "/tmp/$LOG_FILE"
