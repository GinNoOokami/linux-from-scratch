#!/bin/bash
set -xe

. "$(dirname "$0")"/../common.sh

{
ensure_lfs_path_set && ensure_not_root_user

VERSION="6.4"
PACKAGE_NAME=ncurses-$VERSION

pushd "$LFS/sources"

rm -rf "$PACKAGE_NAME"
tar -xf $PACKAGE_NAME.tar.gz
pushd $PACKAGE_NAME

time {
    # Ensure gawk is found during first configure
    sed -i s/mawk// configure

    # Build tic dependency
    mkdir -v build
    pushd build
        ../configure
        make -C include
        make -C progs tic
    popd

    ./configure --prefix=/usr                   \
                --host="$LFS_TGT"               \
                --build="$(./config.guess)"     \
                --mandir=/usr/share/man         \
                --with-manpage-format=normal    \
                --with-shared                   \
                --without-normal                \
                --with-cxx-shared               \
                --without-debug                 \
                --without-ada                   \
                --disable-stripping             \
                --enable-widec

    make
    make DESTDIR="$LFS" TIC_PATH="$(pwd)/build/progs/tic" install
    echo "INPUT(-lncursesw)" > "$LFS/usr/lib/libncurses.so"
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "/tmp/$LOG_FILE"