#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="5.3.1"
PACKAGE_NAME=gawk-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
    # Ensure unneeded files aren't installed
    sed -i 's/extras//' Makefile.in

    ./configure --prefix=/usr

    make

    # Test with non-privileged user
    chown -R tester .
    su tester -c "PATH=$PATH make check"

    # Install and create a link for awk
    rm -f /usr/bin/gawk-5.3.1
    make install
    ln -sv gawk.1 /usr/share/man/man1/awk.1

    # Install the docs
    install -vDm644 doc/{awkforai.txt,*.{eps,pdf,jpg}} -t /usr/share/doc/gawk-5.3.1
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"