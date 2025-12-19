#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="1.35"
PACKAGE_NAME=tar-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
    # Skip a known test failure in LFS due to a missing dependency (selinux)
    sed -i "/233;capabs_raw01.at:25;capabilities:/d" tests/testsuite

    FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/usr

    make
    make check
    make install

    make -C doc install-html docdir=/usr/share/doc/$PACKAGE_NAME
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"