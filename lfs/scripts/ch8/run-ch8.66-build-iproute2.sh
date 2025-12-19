#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="6.13.0"
PACKAGE_NAME=iproute2-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
    # Prevent anything from arpd from being installed
    sed -i /ARPD/d Makefile
    rm -fv man/man8/arpd.8

    make NETNS_RUN_DIR=/run/netns
    make SBINDIR=/usr/sbin install

    install -vDm644 COPYING README* -t /usr/share/doc/iproute2-6.13.0
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"