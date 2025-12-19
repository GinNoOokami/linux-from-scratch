#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_lfs_path_set && ensure_not_root_user

VERSION="14.2.0"
PACKAGE_NAME=gcc-$VERSION

pushd "$LFS/sources"

rm -rf "$PACKAGE_NAME"
tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

tar -xf ../mpfr-4.2.1.tar.xz
mv -v mpfr-4.2.1 mpfr
tar -xf ../gmp-6.3.0.tar.xz
mv -v gmp-6.3.0 gmp
tar -xf ../mpc-1.3.1.tar.gz
mv -v mpc-1.3.1 mpc

time {
    # Change default lib dir for 64bit libs to "lib" on 64bit systems
    case $(uname -m) in
    x86_64)
        sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64
    ;;
    esac

    # Change libgcc and libstdc++ headers to enable POSIX threads support
    sed '/thread_header =/s/@.*@/gthr-posix.h/' \
        -i libgcc/Makefile.in libstdc++-v3/include/Makefile.in
    
    mkdir -vp build
    cd build

    ../configure                                    \
        --build="$(../config.guess)"                \
        --host="$LFS_TGT"                           \
        --target="$LFS_TGT"                         \
        LDFLAGS_FOR_TARGET=-L$PWD/$LFS_TGT/libgcc   \
        --prefix=/usr                               \
        --with-build-sysroot="$LFS"                 \
        --enable-default-pie                        \
        --enable-default-ssp                        \
        --disable-nls                               \
        --disable-multilib                          \
        --disable-libatomic                         \
        --disable-libgomp                           \
        --disable-libquadmath                       \
        --disable-libsanitizer                      \
        --disable-libssp                            \
        --disable-libvtv                            \
        --enable-languages=c,c++

    make
    make DESTDIR="$LFS" install

    ln -sv gcc "$LFS/usr/bin/cc"
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"