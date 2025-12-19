#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="2.40.4"
PACKAGE_NAME=util-linux-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
    mkdir -pv /var/lib/hwclock

    ./configure                                 \
        --libdir=/usr/lib                       \
        --runstatedir=/run                      \
        --disable-chfn-chsh                     \
        --disable-login                         \
        --disable-nologin                       \
        --disable-su                            \
        --disable-setpriv                       \
        --disable-runuser                       \
        --disable-pylibmount                    \
        --disable-liblastlog2                   \
        --disable-static                        \
        --without-python                        \
        ADJTIME_PATH=/var/lib/hwclock/adjtime   \
        --docdir=/usr/share/doc/$PACKAGE_NAME

    make
    make install
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"