#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="2.3.2"
PACKAGE_NAME=acl-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
    ./configure             \
        --prefix=/usr       \
        --disable-static    \
        --docdir=/usr/share/doc/$PACKAGE_NAME
    
    make

    # One test named test/cp.test is known to fail because Coreutils is not built with the Acl support yet
    make check 2>&1 | tee check-log || true
    passed=$(awk '/# PASS:/{total+=$3} ; END{print total}' check-log)
    needed=8
    if [ $passed -lt $needed ]; then
        echo "At least $needed tests should pass"
        exit 1
    fi

    make install
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"