#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_lfs_path_set && ensure_not_root_user

VERSION="9.6"
PACKAGE_NAME=coreutils-$VERSION

pushd "$LFS/sources"

rm -rf "$PACKAGE_NAME"
tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
    ./configure --prefix=/usr                           \
                --host="$LFS_TGT"                       \
                --build="$(build-aux/config.guess)"     \
                --enable-install-program=hostname       \
                --enable-no-install-program=kill,uptime

    make
    make DESTDIR="$LFS" install

    mv -v "$LFS/usr/bin/chroot"              "$LFS/usr/sbin"
    mkdir -pv "$LFS/usr/share/man/man8"
    mv -v "$LFS/usr/share/man/man1/chroot.1" "$LFS/usr/share/man/man8/chroot.8"
    sed -i 's/"1"/"8"/'                      "$LFS/usr/share/man/man8/chroot.8"
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"