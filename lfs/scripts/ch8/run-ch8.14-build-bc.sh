#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="7.0.3"
PACKAGE_NAME=bc-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
    CC=gcc ./configure --prefix=/usr -G -O3 -r

    # There's one test case that seems to be crashing WSL, so null it out as a workaround
    sed "1d" -i tests/bc/errors/33.txt

    make
    make check
    make install
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"