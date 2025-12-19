#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="2.6"
PACKAGE_NAME=inetutils-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
    # Ensure this package can be built with gcc 14.1+
    sed -i 's/def HAVE_TERMCAP_TGETENT/ 1/' telnet/telnet.c

    ./configure                 \
        --prefix=/usr           \
        --bindir=/usr/bin       \
        --localstatedir=/var    \
        --disable-logger        \
        --disable-whois         \
        --disable-rcp           \
        --disable-rexec         \
        --disable-rlogin        \
        --disable-rsh           \
        --disable-servers

    make
    make check
    make install

    # Move to final location
    mv -v /usr/{,s}bin/ifconfig
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"