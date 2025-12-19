#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="3.4.1"
PACKAGE_NAME=openssl-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.gz
pushd $PACKAGE_NAME

time {
    ./config                    \
        --prefix=/usr           \
        --openssldir=/etc/ssl   \
        --libdir=lib            \
        shared                  \
        zlib-dynamic
    
    make
    HARNESS_JOBS=$(nproc) make test

    sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
    make MANSUFFIX=ssl install

    # Rename the man pages to include the version for consistency, and install some additional docs
    mv -v /usr/share/doc/openssl /usr/share/doc/$PACKAGE_NAME
    cp -vfr doc/* /usr/share/doc/$PACKAGE_NAME
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"