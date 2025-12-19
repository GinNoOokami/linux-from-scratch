#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="34"
PACKAGE_NAME=kmod-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
    mkdir -p build
    pushd    build

    meson setup             \
        --prefix=/usr ..    \
        --sbindir=/usr/sbin \
        --buildtype=release \
        -D manpages=false

    ninja
    ninja install
    
    popd
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"