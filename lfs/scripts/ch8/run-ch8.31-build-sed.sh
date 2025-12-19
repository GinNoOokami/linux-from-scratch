#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="4.9"
PACKAGE_NAME=sed-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
    ./configure --prefix=/usr

    make
    make html

    chown -R tester .
    su tester -c "PATH=$PATH make check 2>&1 | tee check-log"
    passed=$(awk '/# PASS:/{total+=$3} ; END{print total}' check-log)
    needed=232
    if [ $passed -lt $needed ]; then
        echo "At least $needed tests should pass"
        exit 1
    fi

    make install
    install -d -m755           /usr/share/doc/$PACKAGE_NAME
    install -m644 doc/sed.html /usr/share/doc/$PACKAGE_NAME
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"