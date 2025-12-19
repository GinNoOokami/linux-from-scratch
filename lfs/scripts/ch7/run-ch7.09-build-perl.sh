#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="5.40.1"
PACKAGE_NAME=perl-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
    sh Configure    -des                                        \
                    -Dprefix=/usr                               \
                    -Dvendorprefix=/usr                         \
                    -Duseshrplib                                \
                    -Dprivlib=/usr/lib/perl5/5.40/core_perl     \
                    -Darchlib=/usr/lib/perl5/5.40/core_perl     \
                    -Dsitelib=/usr/lib/perl5/5.40/site_perl     \
                    -Dsitearch=/usr/lib/perl5/5.40/site_perl    \
                    -Dvendorlib=/usr/lib/perl5/5.40/vendor_perl \
                    -Dvendorarch=/usr/lib/perl5/5.40/vendor_perl

    make
    make install
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"