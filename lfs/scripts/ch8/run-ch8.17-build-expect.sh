#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="5.45.4"
PACKAGE_NAME=expect$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.gz
pushd $PACKAGE_NAME

time {
    # Make some changes to allow the package with gcc-14.1 or later
    patch -Np1 -i ../expect-$VERSION-gcc14-1.patch

    ./configure                 \
        --prefix=/usr           \
        --with-tcl=/usr/lib     \
        --enable-shared         \
        --disable-rpath         \
        --mandir=/usr/share/man \
        --with-tclinclude=/usr/include

    make
    make test
    make install

    ln -svf expect$VERSION/libexpect$VERSION.so /usr/lib
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"