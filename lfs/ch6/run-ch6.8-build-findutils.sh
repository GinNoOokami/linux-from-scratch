#!/bin/bash
set -xe

. "$(dirname "$0")"/../common.sh

{
ensure_lfs_path_set && ensure_not_root_user

VERSION="4.9.0"
PACKAGE_NAME=findutils-$VERSION

pushd "$LFS/sources"

rm -rf "$PACKAGE_NAME"
tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
    ./configure --prefix=/usr                   \
                --localstatedir=/var/lib/locate \
                --host="$LFS_TGT"               \
                --build="$(build-aux/config.guess)"

    make
    make DESTDIR="$LFS" install
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "/tmp/$LOG_FILE"