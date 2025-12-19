#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_lfs_path_set && ensure_not_root_user

VERSION="2.44"
PACKAGE_NAME=binutils-$VERSION

pushd "$LFS/sources"

rm -rf $PACKAGE_NAME
tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
	mkdir -v build
	cd build
	
	../configure 						\
			--prefix=$LFS/tools \
			--with-sysroot=$LFS \
			--target=$LFS_TGT   \
			--disable-nls	 			\
			--enable-gprofng=no \
			--disable-werror		\
			--enable-new-dtags	\
			--enable-default-hash-style=gnu

	make
	make install
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"
