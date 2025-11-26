#!/bin/bash
set -xe

. "$(dirname "$0")"/../common.sh

{
ensure_root_user

VERSION="5.38.0"
PACKAGE_NAME=perl-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
    sh Configure    -des                                        \
                    -Dprefix=/usr                               \
                    -Dvendorprefix=/usr                         \
                    -Duseshrplib                                \
                    -Dprivlib=/usr/lib/perl5/5.38/core_perl     \
                    -Darchlib=/usr/lib/perl5/5.38/core_perl     \
                    -Dsitelib=/usr/lib/perl5/5.38/site_perl     \
                    -Dsitearch=/usr/lib/perl5/5.38/site_perl    \
                    -Dvendorlib=/usr/lib/perl5/5.38/vendor_perl \
                    -Dvendorarch=/usr/lib/perl5/5.38/vendor_perl

    make
    make install
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "/tmp/$LOG_FILE"