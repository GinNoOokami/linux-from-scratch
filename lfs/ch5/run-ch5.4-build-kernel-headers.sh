#!/bin/bash
set -xe

. "$(dirname "$0")"/../common.sh

{
ensure_lfs_path_set && ensure_not_root_user

VERSION="6.4.12"
PACKAGE_NAME=linux-$VERSION

pushd "$LFS/sources"

rm -rf $PACKAGE_NAME
tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
    make mrproper
    make headers

    find usr/include -type f ! -name '*.h' -delete
    cp -rv usr/include "$LFS/usr"
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "/tmp/$LOG_FILE"
