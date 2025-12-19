#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="0.192"
PACKAGE_NAME=elfutils-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.bz2
pushd $PACKAGE_NAME

time {
    ./configure                         \
        --prefix=/usr                   \
        --disable-debuginfod            \
        --enable-libdebuginfod=dummy

    make
    make check

    # Only install libelf (and remove useless static lib)
    make -C libelf install
    install -vm644 config/libelf.pc /usr/lib/pkgconfig
    rm /usr/lib/libelf.a
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"