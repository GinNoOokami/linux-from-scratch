#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="2.6.4"
PACKAGE_NAME=flex-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.gz
pushd $PACKAGE_NAME

time {
    ./configure                                 \
        --prefix=/usr                           \
        --docdir=/usr/share/doc/$PACKAGE_NAME   \
        --disable-static
    
    make
    make check
    make install

    # Support legacy programs who don't know about flex yet
    ln -sv flex   /usr/bin/lex
    ln -sv flex.1 /usr/share/man/man1/lex.1
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"