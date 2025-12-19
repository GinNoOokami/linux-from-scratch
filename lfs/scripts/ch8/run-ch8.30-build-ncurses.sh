#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="6.5"
PACKAGE_NAME=ncurses-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.gz
pushd $PACKAGE_NAME

time {
    ./configure                 \
        --prefix=/usr           \
        --mandir=/usr/share/man \
        --with-shared           \
        --without-debug         \
        --without-normal        \
        --with-cxx-shared       \
        --enable-pc-files       \
        --with-pkg-config-libdir=/usr/lib/pkgconfig

    make

    # Test cases are interactive and cannot be automated

    # The installation of this package will overwrite libncursesw.so.6.5 in-place. 
    # It may crash the shell process which is using code and data from the library file. 
    # Install the package with DESTDIR, and replace the library file correctly using install
    # command (the header curses.h is also edited to ensure the wide-character ABI to be used as done earlier
    make DESTDIR=$PWD/dest install
    install -vm755 dest/usr/lib/libncursesw.so.6.5 /usr/lib
    rm -v  dest/usr/lib/libncursesw.so.6.5
    sed -e 's/^#if.*XOPEN.*$/#if 1/' \
        -i dest/usr/include/curses.h
    cp -av dest/* /

    # Point apps expecting non-wide characters to standard libs
    for lib in ncurses form panel menu ; do
        ln -sfv lib${lib}w.so /usr/lib/lib${lib}.so
        ln -sfv ${lib}w.pc    /usr/lib/pkgconfig/${lib}.pc
    done

    # Ensure old apps that look for -lcurses at build time are still buildable
    ln -sfv libncursesw.so /usr/lib/libcurses.so

    # Install docs
    cp -v -R doc -T /usr/share/doc/ncurses-6.5
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"