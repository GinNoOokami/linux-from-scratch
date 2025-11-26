#!/bin/bash
set -xe

. "$(dirname "$0")"/../common.sh

{
ensure_root_user

VERSION="2.39.1"
PACKAGE_NAME=util-linux-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
    mkdir -pv /var/lib/hwclock

    ./configure                                 \
        ADJTIME_PATH=/var/lib/hwclock/adjtime   \
        --libdir=/usr/lib                       \
        --runstatedir=/run                      \
        --docdir=/usr/share/doc/$PACKAGE_NAME   \
        --disable-chfn-chsh                     \
        --disable-login                         \
        --disable-nologin                       \
        --disable-su                            \
        --disable-setpriv                       \
        --disable-runuser                       \
        --disable-pylibmount                    \
        --disable-static                        \
        --without-python

    make
    make install
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "/tmp/$LOG_FILE"