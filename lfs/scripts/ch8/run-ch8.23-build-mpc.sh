#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="1.3.1"
PACKAGE_NAME=mpc-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.gz
pushd $PACKAGE_NAME

time {
    ./configure             \
        --prefix=/usr       \
        --disable-static    \
        --docdir=/usr/share/doc/$PACKAGE_NAME

    make
    make html

    make check 2>&1 | tee check-log
    passed=$(awk '/# PASS:/{total+=$3} ; END{print total}' check-log)
    needed=74
    if [ $passed -lt $needed ]; then
        echo "At least $needed tests should pass"
        exit 1
    fi

    make install
    make install-html
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"