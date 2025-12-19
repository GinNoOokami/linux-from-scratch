#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="5.2.37"
PACKAGE_NAME=bash-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.gz
pushd $PACKAGE_NAME

time {
    ./configure                     \
        --prefix=/usr               \
        --without-bash-malloc       \
        --with-installed-readline   \
        --docdir=/usr/share/doc/$PACKAGE_NAME

    make

    chown -R tester .

    # The test suite of this package is designed to be run as a non-root user who owns the terminal connected to standard input. 
    # To satisfy the requirement, spawn a new pseudo terminal using Expect and run the tests as the tester user
    su -s /usr/bin/expect tester << "EOF"
    set timeout -1
    spawn make tests
    expect eof
    lassign [wait] _ _ _ value
    exit $value
EOF

    make install

    # exec /usr/bin/bash --login
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"