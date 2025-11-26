#!/bin/bash
set -xe

. "$(dirname "$0")"/../common.sh

{
ensure_lfs_path_set && ensure_not_root_user

VERSION="1.12"
PACKAGE_NAME=gzip-$VERSION

pushd "$LFS/sources"

rm -rf "$PACKAGE_NAME"
tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
    ./configure --prefix=/usr --host="$LFS_TGT"
    
    make
    make DESTDIR="$LFS" install
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "/tmp/$LOG_FILE"