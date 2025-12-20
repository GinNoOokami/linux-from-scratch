#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="4.17.3"
PACKAGE_NAME=shadow-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
    # Disable the installation of the groups program and its man pages, as Coreutils provides a better version
    # Also, prevent the installation of manual pages that were already installed earlier
    sed -i 's/groups$(EXEEXT) //' src/Makefile.in
    find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \;
    find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
    find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \;

    # Use the more secure YESCRYPT
    sed -e 's:#ENCRYPT_METHOD DES:ENCRYPT_METHOD YESCRYPT:' \
        -e 's:/var/spool/mail:/var/mail:'                   \
        -e '/PATH=/{s@/sbin:@@;s@/bin:@@}'                  \
        -i etc/login.defs

    touch /usr/bin/passwd
    ./configure             \
        --sysconfdir=/etc   \
        --disable-static    \
        --with-{b,yes}crypt \
        --without-libbsd    \
        --with-group-name-max-length=32
    
    make
    
    make exec_prefix=/usr install
    make -C man install-man

    # Enable user/group password shadowing
    pwconv
    grpconv

    # Create the useradd default parameters
    mkdir -p /etc/default
    useradd -D --gid 999

    # Hardcode a default root password- it's just a toy OS after all
    echo lfs | passwd root -s
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"