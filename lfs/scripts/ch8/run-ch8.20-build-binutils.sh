#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="2.44"
PACKAGE_NAME=binutils-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
    mkdir -pv build
    pushd build

    ../configure            \
        --prefix=/usr       \
        --sysconfdir=/etc   \
        --enable-ld=default \
        --enable-plugins    \
        --enable-shared     \
        --disable-werror    \
        --enable-64-bit-bfd \
        --enable-new-dtags  \
        --with-system-zlib  \
        --enable-default-hash-style=gnu

    make tooldir=/usr
    make -k check

    # shellcheck disable=SC2046
    grep '^FAIL:' $(find . -name '*.log') || true

    make tooldir=/usr install

    # Remove static libs and other useless files
    rm -rfv /usr/lib/lib{bfd,ctf,ctf-nobfd,gprofng,opcodes,sframe}.a \
        /usr/share/doc/gprofng/

    popd
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"