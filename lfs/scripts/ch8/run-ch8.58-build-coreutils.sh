#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="9.6"
PACKAGE_NAME=coreutils-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
    patch -Np1 -i ../coreutils-9.6-i18n-1.patch

    # Disable a test known to fail in Docker containers due to overelayfs
    # https://github.com/containers/podman/issues/5493
    sed -i '/tests\/tail\/inotify-dir-recreate.sh/d' Makefile.in
    sed -i '/tests\/tail\/inotify-dir-recreate.sh/d' tests/local.mk

    # Reconfigure the make configure/make files because of the patch
    autoreconf -fv
    automake -af

    FORCE_UNSAFE_CONFIGURE=1 ./configure \
                --prefix=/usr            \
                --enable-no-install-program=kill,uptime
    
    make

    # First run the root tests
    make NON_ROOT_USERNAME=tester check-root

    # Some tests require the tester to be part of multiple groups
    if grep -qF "dummy" /etc/group; then
        groupdel dummy
    fi
    groupadd -g 102 dummy -U tester
    
    # Then modify the permissions and run the rest as a non-root user
    chown -R tester . 
    su tester -c "PATH=$PATH make -k RUN_EXPENSIVE_TESTS=yes check" < /dev/null

    # Remove the temporary group
    groupdel dummy

    make install

    # Move to appropriate location according to the FHS
    mv -v /usr/bin/chroot /usr/sbin
    mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
    sed -i 's/"1"/"8"/' /usr/share/man/man8/chroot.8
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"