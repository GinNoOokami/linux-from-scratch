#!/bin/bash
set -xe

. "$(dirname "$0")"/../common.sh

{
ensure_lfs_path_set && ensure_not_root_user

VERSION="5.45"
PACKAGE_NAME=file-$VERSION

pushd "$LFS/sources"

rm -rf "$PACKAGE_NAME"
tar -xf $PACKAGE_NAME.tar.gz
pushd $PACKAGE_NAME

time {
    mkdir build
    pushd build
        # Make a temp copy of the file command for the host to match the one we're making
        ../configure --disable-bzlib        \
                     --disable-libseccomp   \
                     --disable-xzlib        \
                     --disable-zlib

        make
    popd

    ./configure --prefix=/usr       \
                --host="$LFS_TGT"   \
                --build="$(./config.guess)"

    make FILE_COMPILE="$(pwd)/build/src/file"
    make DESTDIR="$LFS" install

    rm -v "$LFS/usr/lib/libmagic.la"
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "/tmp/$LOG_FILE"