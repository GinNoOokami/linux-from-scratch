#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="20250123"
PACKAGE_NAME=iana-etc-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.gz
pushd $PACKAGE_NAME

time {
    cp services protocols /etc
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"