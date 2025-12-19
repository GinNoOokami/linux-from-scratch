#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_lfs_path_set && ensure_not_root_user

VERSION="2.44"
PACKAGE_NAME=binutils-$VERSION

pushd "$LFS/sources"

rm -rf "$PACKAGE_NAME"
tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
    sed '6031s/$add_dir//' -i ltmain.sh

    mkdir -vp build
    pushd build

    ../configure                        \
        --prefix=/usr                   \
        --build="$(../config.guess)"    \
        --host="$LFS_TGT"               \
        --disable-nls                   \
        --enable-shared                 \
        --enable-gprofng=no             \
        --disable-werror                \
        --enable-64-bit-bfd             \
        --enable-new-dtags              \
        --enable-default-hash-style=gnu

    make
    make DESTDIR="$LFS" install

    rm -v "$LFS"/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes,sframe}.{a,la}
    
    popd
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"