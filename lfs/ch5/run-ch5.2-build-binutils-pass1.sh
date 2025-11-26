#!/bin/bash
set -xe

. "$(dirname "$0")"/../common.sh

{
ensure_lfs_path_set && ensure_not_root_user

VERSION="2.41"
PACKAGE_NAME=binutils-$VERSION

pushd "$LFS/sources"

rm -rf $PACKAGE_NAME
tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
	mkdir -v build
	cd build
	
	../configure 				\
			--prefix=$LFS/tools \
			--with-sysroot=$LFS \
			--target=$LFS_TGT   \
			--disable-nls	 	\
			--enable-gprofng=no \
			--disable-werror

	make
	make install
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "/tmp/$LOG_FILE"
