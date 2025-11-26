#!/bin/bash
set -xe

. "$(dirname "$0")"/../common.sh

{
ensure_root_user

VERSION="20230810"
PACKAGE_NAME=iana-etc-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.gz
pushd $PACKAGE_NAME

cp services protocols /etc

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "/tmp/$LOG_FILE"