#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="14.2.0"
PACKAGE_NAME=gcc-$VERSION

pushd "/sources"

rm -rf $PACKAGE_NAME
tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
    case $(uname -m) in
        x86_64)
        sed -e '/m64=/s/lib64/lib/' \
            -i.orig gcc/config/i386/t-linux64
	;;
	esac

	mkdir -v build
	pushd build

    ../configure                    \
        --prefix=/usr               \
        LD=ld                       \
        --enable-languages=c,c++    \
        --enable-default-pie        \
        --enable-default-ssp        \
        --enable-host-pie           \
        --disable-multilib          \
        --disable-bootstrap         \
        --disable-fixincludes       \
        --with-system-zlib

	make

    # Set the hard stack size to unlimited
    ulimit -s -H unlimited

    # Remove/fix several known test failures
    sed -e '/cpython/d'               -i ../gcc/testsuite/gcc.dg/plugin/plugin.exp
    sed -e 's/no-pic /&-no-pie /'     -i ../gcc/testsuite/gcc.target/i386/pr113689-1.c
    sed -e 's/300000/(1|300000)/'     -i ../libgomp/testsuite/libgomp.c-c++-common/pr109062.c
    sed -e 's/{ target nonpic } //' \
        -e '/GOTPCREL/d'              -i ../gcc/testsuite/gcc.target/i386/fentryname3.c
    
    # Test the results as a non-privileged user, but do not stop at errors
    chown -R tester .
    su tester -c "PATH=$PATH make -j$(nproc) -k check"

    # Get a summary of the test results
    ../contrib/test_summary | grep -A7 Summ

    make install

    # Switch ownership back to root
    chown -v -R root:root /usr/lib/gcc/$(gcc -dumpmachine)/$VERSION/include{,-fixed}

    # Create required symlink
    ln -svr /usr/bin/cpp /usr/lib

    # Symlink the cc man page
    ln -sv gcc.1 /usr/share/man/man1/cc.1

    # Add symlink for LTO
    ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/$VERSION/liblto_plugin.so /usr/lib/bfd-plugins/

    # Perform a sanity check
    echo 'int main(){}' > dummy.c
    cc dummy.c -v -Wl,--verbose &> dummy.log
    readelf -l a.out | grep ': /lib'
    grep -E -o '/usr/lib.*/S?crt[1in].*succeeded' dummy.log
    grep -B4 '^ /usr/include' dummy.log
    grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
    grep "/lib.*/libc.so.6 " dummy.log
    grep found dummy.log
    rm -v dummy.c a.out dummy.log

    # Move a misplaced file
    mkdir -pv /usr/share/gdb/auto-load/usr/lib
    mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib

    popd
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"
