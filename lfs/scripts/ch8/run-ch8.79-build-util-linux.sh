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
    ./configure                                 \
        --bindir=/usr/bin                       \
        --libdir=/usr/lib                       \
        --runstatedir=/run                      \
        --sbindir=/usr/sbin                     \
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
        --without-systemd                       \
        --without-systemdsystemunitdir          \
        ADJTIME_PATH=/var/lib/hwclock/adjtime   \
        --docdir=/usr/share/doc/$PACKAGE_NAME

    make

    touch /etc/fstab
    chown -R tester .
    su tester -c "make -k check"

    make install
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"