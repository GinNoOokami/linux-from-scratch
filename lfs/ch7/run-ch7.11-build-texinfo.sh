#!/bin/bash
set -xe

. "$(dirname "$0")"/../common.sh

{
ensure_root_user

VERSION="7.0.3"
PACKAGE_NAME=texinfo-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
    ./configure --prefix=/usr

    make
    make install
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "/tmp/$LOG_FILE"