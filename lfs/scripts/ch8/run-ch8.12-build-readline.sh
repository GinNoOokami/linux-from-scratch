#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="8.2.13"
PACKAGE_NAME=readline-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.gz
pushd $PACKAGE_NAME

time {
    # Reinstalling Readline will cause the old libraries to be moved to <libraryname>.old. 
    # While this is normally not a problem, in some cases it can trigger a linking bug in ldconfig. This can be avoided by issuing the following two seds
    sed -i '/MV.*old/d' Makefile.in
    sed -i '/{OLDSUFF}/c:' support/shlib-install

    # Prevent hard coding library search paths (rpath) into the shared libraries
    sed -i 's/-Wl,-rpath,[^ ]*//' support/shobj-conf

    ./configure             \
        --prefix=/usr       \
        --disable-static    \
        --with-curses       \
        --docdir=/usr/share/doc/$PACKAGE_NAME
    
    make SHLIB_LIBS="-lncursesw"
    make install

    # Also install the documentation
    install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/$PACKAGE_NAME
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"