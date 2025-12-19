#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="2.7.1"
PACKAGE_NAME=kbd-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
    patch -Np1 -i ../$PACKAGE_NAME-backspace-1.patch

    # Remove the redundant resizecons program
    sed -i '/RESIZECONS_PROGS=/s/yes/no/' configure
    sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in

    ./configure --prefix=/usr --disable-vlock

    make
    make check
    make install

    # Install the docs
    cp -R -v docs/doc -T /usr/share/doc/kbd-2.7.1
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"