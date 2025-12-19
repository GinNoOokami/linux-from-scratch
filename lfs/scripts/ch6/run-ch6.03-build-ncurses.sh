#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_lfs_path_set && ensure_not_root_user

VERSION="6.5"
PACKAGE_NAME=ncurses-$VERSION

pushd "$LFS/sources"

rm -rf "$PACKAGE_NAME"
tar -xf $PACKAGE_NAME.tar.gz
pushd $PACKAGE_NAME

time {
    # Build tic dependency
    mkdir -v build
    pushd build
        ../configure AWK=gawk
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
                AWK=gawk

    make
    make DESTDIR="$LFS" TIC_PATH="$(pwd)/build/progs/tic" install

    ln -sv libncursesw.so "$LFS/usr/lib/libncurses.so"
    sed -e 's/^#if.*XOPEN.*$/#if 1/' \
        -i $LFS/usr/include/curses.h
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"