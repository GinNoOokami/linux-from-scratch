#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_lfs_path_set && ensure_not_root_user

VERSION="5.2.37"
PACKAGE_NAME=bash-$VERSION

pushd "$LFS/sources"

rm -rf "$PACKAGE_NAME"
tar -xf $PACKAGE_NAME.tar.gz
pushd $PACKAGE_NAME

time {
    ./configure --prefix=/usr                           \
                --build="$(sh support/config.guess)"    \
                --host="$LFS_TGT"                       \
                --without-bash-malloc

    make
    make DESTDIR="$LFS" install

    ln -sv bash "$LFS/bin/sh"
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"