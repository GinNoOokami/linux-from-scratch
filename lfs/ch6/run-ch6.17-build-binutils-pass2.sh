#!/bin/bash
set -xe

. "$(dirname "$0")"/../common.sh

{
ensure_lfs_path_set && ensure_not_root_user

VERSION="2.41"
PACKAGE_NAME=binutils-$VERSION

pushd "$LFS/sources"

rm -rf "$PACKAGE_NAME"
tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
    sed '6009s/$add_dir//' -i ltmain.sh

    mkdir -vp build
    cd build

    ../configure                        \
        --prefix=/usr                   \
        --build="$(../config.guess)"    \
        --host="$LFS_TGT"               \
        --disable-nls                   \
        --enable-shared                 \
        --enable-gprofng=no             \
        --disable-werror                \
        --enable-64-bit-bfd

    make
    make DESTDIR="$LFS" install

    rm -v "$LFS"/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes,sframe}.{a,la}
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "/tmp/$LOG_FILE"