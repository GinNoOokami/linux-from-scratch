#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="8.6.16"
PACKAGE_NAME=tcl$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME-src.tar.gz
pushd $PACKAGE_NAME

time {
    SRCDIR=$(pwd)

    cd unix

    ./configure                 \
        --prefix=/usr           \
        --mandir=/usr/share/man \
        --disable-rpath
    
    make

    sed -e "s|$SRCDIR/unix|/usr/lib|" \
        -e "s|$SRCDIR|/usr/include|"  \
        -i tclConfig.sh

    sed -e "s|$SRCDIR/unix/pkgs/tdbc1.1.10|/usr/lib/tdbc1.1.10|"    \
        -e "s|$SRCDIR/pkgs/tdbc1.1.10/generic|/usr/include|"        \
        -e "s|$SRCDIR/pkgs/tdbc1.1.10/library|/usr/lib/tcl8.6|"     \
        -e "s|$SRCDIR/pkgs/tdbc1.1.10|/usr/include|"                \
        -i pkgs/tdbc1.1.10/tdbcConfig.sh

    sed -e "s|$SRCDIR/unix/pkgs/itcl4.3.2|/usr/lib/itcl4.3.2|" \
        -e "s|$SRCDIR/pkgs/itcl4.3.2/generic|/usr/include|"    \
        -e "s|$SRCDIR/pkgs/itcl4.3.2|/usr/include|"            \
        -i pkgs/itcl4.3.2/itclConfig.sh
    
    unset SRCDIR

    make test
    make install

    # Make the installed library writable so debugging symbols can be removed later
    chmod -v u+w /usr/lib/libtcl8.6.so

    # Install tcl headers
    make install-private-headers

    # Make a necessary symbolic link
    ln -sfv tclsh8.6 /usr/bin/tclsh

    # Rename a man page that conflicts with a Perl man page
    mv /usr/share/man/man3/{Thread,Tcl_Thread}.3

    # Install docs
    cd ..
    tar -xf ../tcl8.6.16-html.tar.gz --strip-components=1
    mkdir -v -p /usr/share/doc/tcl-8.6.16
    cp -v -r  ./html/* /usr/share/doc/tcl-8.6.16
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"