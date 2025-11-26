#!/bin/bash
set -xe

. "$(dirname "$0")"/../common.sh

{
ensure_root_user

VERSION="3.8.2"
PACKAGE_NAME=bison-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
    ./configure --prefix=/usr --docdir=/usr/share/doc/$PACKAGE_NAME

    make
    make install
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "/tmp/$LOG_FILE"