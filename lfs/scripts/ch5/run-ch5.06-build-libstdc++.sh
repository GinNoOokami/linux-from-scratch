#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_lfs_path_set && ensure_not_root_user

VERSION="14.2.0"
PACKAGE_NAME=gcc-$VERSION

pushd "$LFS/sources"

rm -rf $PACKAGE_NAME
tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
	mkdir -v build
	pushd build

	../libstdc++-v3/configure				\
		--host=$LFS_TGT								\
		--build="$(../config.guess)"	\
		--prefix=/usr									\
		--disable-multilib						\
		--disable-nls									\
		--disable-libstdcxx-pch				\
		--with-gxx-include-dir=/tools/$LFS_TGT/include/c++/$VERSION

	make
	make DESTDIR="$LFS" install

	rm -v "$LFS"/usr/lib/lib{stdc++,stdc++fs,supc++}.la

	popd
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"
