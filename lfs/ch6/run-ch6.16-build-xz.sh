#!/bin/bash
set -xe

. "$(dirname "$0")"/../common.sh

{
ensure_lfs_path_set && ensure_not_root_user

VERSION="5.4.4"
PACKAGE_NAME=xz-$VERSION

pushd "$LFS/sources"

rm -rf "$PACKAGE_NAME"
tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
    ./configure --prefix=/usr                       \
                --host="$LFS_TGT"                   \
                --build="$(build-aux/config.guess)" \
                --disable-static                    \
                --docdir=/usr/share/doc/$PACKAGE_NAME
    
    make
    make DESTDIR="$LFS" install

    rm -v "$LFS/usr/lib/liblzma.la"
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "/tmp/$LOG_FILE"