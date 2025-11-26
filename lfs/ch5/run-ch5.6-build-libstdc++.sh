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

time {
	mkdir -v build
	cd build

	../libstdc++-v3/configure			\
		--host=$LFS_TGT					\
		--build="$(../config.guess)"	\
		--prefix=/usr					\
		--disable-multilib				\
		--disable-nls					\
		--disable-libstdcxx-pch			\
		--with-gxx-include-dir=/tools/$LFS_TGT/include/c++/$VERSION

	make
	make DESTDIR="$LFS" install

	rm -v "$LFS"/usr/lib/lib{stdc++,stdc++fs,supc++}.la
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "/tmp/$LOG_FILE"
