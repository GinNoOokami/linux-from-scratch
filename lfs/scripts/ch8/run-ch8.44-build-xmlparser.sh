#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="2.47"
PACKAGE_NAME=XML-Parser-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.gz
pushd $PACKAGE_NAME

time {
    perl Makefile.PL

    make
    make test
    make install
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"