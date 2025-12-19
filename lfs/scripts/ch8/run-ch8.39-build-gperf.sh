#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="3.1"
PACKAGE_NAME=gperf-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.gz
pushd $PACKAGE_NAME

time {
    ./configure --prefix=/usr --docdir=/usr/share/doc/$PACKAGE_NAME

    make
    make -j1 check # Tests are known to fail in parallel, so force one at a time with -j1
    make install
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"