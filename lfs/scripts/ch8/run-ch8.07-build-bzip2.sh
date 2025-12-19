#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="1.0.8"
PACKAGE_NAME=bzip2-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.gz
pushd $PACKAGE_NAME

time {
    # Apply a patch that will install the documentation for this package
    patch -Np1 -i ../bzip2-1.0.8-install_docs-1.patch

    # The following command ensures installation of symbolic links are relative
    sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile

    # Ensure the man pages are installed into the correct location
    sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile

    # Prepare for compilation
    make -f Makefile-libbz2_so
    make clean

    make
    make PREFIX=/usr install

    # Install the shared library
    cp -av libbz2.so.* /usr/lib
    ln -sv libbz2.so.$VERSION /usr/lib/libbz2.so

    # Install the shared bzip2 binary into the /usr/bin directory, and replace two copies of bzip2 with symlinks
    cp -v bzip2-shared /usr/bin/bzip2
    for i in /usr/bin/{bzcat,bunzip2}; do
        ln -sfv bzip2 $i
    done

    # Remove a useless static library
    rm -fv /usr/lib/libbz2.a
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"