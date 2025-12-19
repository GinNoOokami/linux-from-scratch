#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="2.73"
PACKAGE_NAME=libcap-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
    # Prevent static libraries from being installed
    sed -i '/install -m.*STA/d' libcap/Makefile

    make prefix=/usr lib=lib
    make test
    make prefix=/usr lib=lib install
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"