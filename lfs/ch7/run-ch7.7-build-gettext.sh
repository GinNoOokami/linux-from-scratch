#!/bin/bash
set -xe

. "$(dirname "$0")"/../common.sh

{
ensure_root_user

VERSION="0.22"
PACKAGE_NAME=gettext-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
    ./configure --disable-shared

    make
    cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "/tmp/$LOG_FILE"