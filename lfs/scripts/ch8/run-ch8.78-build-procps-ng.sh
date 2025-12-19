#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="4.0.5"
PACKAGE_NAME=procps-ng-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
    ./configure                                 \
        --prefix=/usr                           \
        --docdir=/usr/share/doc/$PACKAGE_NAME   \
        --disable-static                        \
        --disable-kill                          \
        --enable-watch8bit
    
    make

    chown -R tester .
    su tester -c "PATH=$PATH make check"

    make install
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"