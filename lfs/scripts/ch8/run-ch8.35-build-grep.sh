#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="3.11"
PACKAGE_NAME=grep-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
    # Remove a warning about using egrep and fgrep that makes tests on some packages fail
    sed -i "s/echo/#echo/" src/egrep.sh

    ./configure --prefix=/usr

    make

    make check 2>&1 | tee check-log
    passed=$(awk '/# PASS:/{total+=$3} ; END{print total}' check-log)
    needed=312
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