#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="1.3.1"
PACKAGE_NAME=zlib-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.gz
pushd $PACKAGE_NAME

time {
    ./configure --prefix=/usr

    make
    make check
    make install

    # Remove a useless static library
    rm -fv /usr/lib/libz.a
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"