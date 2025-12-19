#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="1.47.2"
PACKAGE_NAME=e2fsprogs-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.gz
pushd $PACKAGE_NAME

time {
    # Remove a test known to fail
    rm -rf tests/m_assume_storage_prezeroed

    mkdir -v build
    pushd    build

    ../configure                \
        --prefix=/usr           \
        --sysconfdir=/etc       \
        --enable-elf-shlibs     \
        --disable-libblkid      \
        --disable-libuuid       \
        --disable-uuidd         \
        --disable-fsck
    
    make
    make check
    make install

    # Remove useless static libs
    rm -fv /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a

    # This package installs a gzipped .info file but doesn't update the system-wide dir file
    gunzip -v /usr/share/info/libext2fs.info.gz
    install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info

    # Install additional docs
    makeinfo -o      doc/com_err.info ../lib/et/com_err.texinfo
    install -v -m644 doc/com_err.info /usr/share/info
    install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info

    popd
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"