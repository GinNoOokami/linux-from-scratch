#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="3.13.2"
PACKAGE_NAME=Python-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
    ./configure                 \
        --prefix=/usr           \
        --enable-shared         \
        --with-system-expat     \
        --enable-optimizations

    make

    # Disable a test that fails in Docker due to VSOCK issues
    make test TESTOPTS="--timeout 180 -x test_socket"

    make install

    # Ignore warning about updating pip separately
    cat > /etc/pip.conf << EOF
[global]
root-user-action = ignore
disable-pip-version-check = true
EOF

    # Install the preformatted docs
    pkg_name="$(echo $PACKAGE_NAME | awk '{print tolower($0)}')"
    install -v -dm755 /usr/share/doc/$pkg_name/html

    tar                                         \
        --strip-components=1                    \
        --no-same-owner                         \
        --no-same-permissions                   \
        -C /usr/share/doc/$pkg_name/html        \
        -xvf ../$pkg_name-docs-html.tar.bz2
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"