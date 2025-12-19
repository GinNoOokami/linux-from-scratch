#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="0.24"
PACKAGE_NAME=gettext-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
    ./configure             \
        --prefix=/usr       \
        --disable-static    \
        --docdir=/usr/share/doc/$PACKAGE_NAME

    make
    
    make check 2>&1 | tee check-log
    passed=$(awk '/# PASS:/{total+=$3} ; END{print total}' check-log)
    needed=1001
    if [ $passed -lt $needed ]; then
        echo "At least $needed tests should pass"
        exit 1
    fi

    make install
    chmod -v 0755 /usr/lib/preloadable_libintl.so
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"