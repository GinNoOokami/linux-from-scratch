#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="4.4.1"
PACKAGE_NAME=make-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.gz
pushd $PACKAGE_NAME

time {
    ./configure --prefix=/usr

    make
    
    chown -R tester .
    su tester -c "PATH=$PATH make check"
    
    make install
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"