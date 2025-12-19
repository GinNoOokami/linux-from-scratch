#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

SHORT_VER="5.40"
VERSION="$SHORT_VER.1"
PACKAGE_NAME=perl-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
    # Use system libs instead of internal ones
    export BUILD_ZLIB=False
    export BUILD_BZIP2=0

    sh Configure                                            \
        -des                                                \
        -D prefix=/usr                                      \
        -D vendorprefix=/usr                                \
        -D privlib=/usr/lib/perl5/$SHORT_VER/core_perl      \
        -D archlib=/usr/lib/perl5/$SHORT_VER/core_perl      \
        -D sitelib=/usr/lib/perl5/$SHORT_VER/site_perl      \
        -D sitearch=/usr/lib/perl5/$SHORT_VER/site_perl     \
        -D vendorlib=/usr/lib/perl5/$SHORT_VER/vendor_perl  \
        -D vendorarch=/usr/lib/perl5/$SHORT_VER/vendor_perl \
        -D man1dir=/usr/share/man/man1                      \
        -D man3dir=/usr/share/man/man3                      \
        -D pager="/usr/bin/less -isR"                       \
        -D useshrplib                                       \
        -D usethreads
    
    make
    TEST_JOBS=$(nproc) make test_harness

    # Install and cleanup
    make install
    unset BUILD_ZLIB BUILD_BZIP2
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"