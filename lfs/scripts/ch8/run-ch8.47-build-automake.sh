#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="1.17"
PACKAGE_NAME=automake-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
    ./configure --prefix=/usr --docdir=/usr/share/doc/$PACKAGE_NAME

    make

    # Using four parallel jobs speeds up the tests, even on systems with less logical cores, due to internal delays in individual tests
    make -j$(($(nproc)>4?$(nproc):4)) check

    make install
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"