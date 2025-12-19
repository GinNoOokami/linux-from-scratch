#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="2.6.4"
PACKAGE_NAME=expat-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
    ./configure             \
        --prefix=/usr       \
        --disable-static    \
        --docdir=/usr/share/doc/$PACKAGE_NAME
    
    make
    make check
    make install

    # Install docs
    install -v -m644 doc/*.{html,css} /usr/share/doc/$PACKAGE_NAME
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"