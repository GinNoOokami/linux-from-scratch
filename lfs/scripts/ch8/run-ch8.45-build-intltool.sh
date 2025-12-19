#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="0.51.0"
PACKAGE_NAME=intltool-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.gz
pushd $PACKAGE_NAME

time {
    # First fix a warning that is caused by perl-5.22 and later  
    # by adding in a backslash, changing '\${' to '\$\{'
    sed -i 's:\\\${:\\\$\\{:' intltool-update.in

    ./configure --prefix=/usr

    make
    make check
    make install

    # Install man pages
    install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/$PACKAGE_NAME/I18N-HOWTO
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"