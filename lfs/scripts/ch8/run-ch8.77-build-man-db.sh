#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="2.13.0"
PACKAGE_NAME=man-db-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
    ./configure                                 \
        --prefix=/usr                           \
        --docdir=/usr/share/doc/$PACKAGE_NAME   \
        --sysconfdir=/etc                       \
        --disable-setuid                        \
        --enable-cache-owner=bin                \
        --with-browser=/usr/bin/lynx            \
        --with-vgrind=/usr/bin/vgrind           \
        --with-grap=/usr/bin/grap               \
        --with-systemdtmpfilesdir=              \
        --with-systemdsystemunitdir=
    
    make
    make check
    make install
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"