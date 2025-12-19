#!/bin/bash

ensure_root_user() {    
    if ! [ "$(id -u)" = 0 ]; then
        echo This script must be run as root! Aborting... >&2
        exit 1
    fi
}

ensure_not_root_user() {
    if [ "$(id -u)" = 0 ]; then
        echo This script must not be run as root! Aborting... >&2
        exit 1
    fi
}

ensure_lfs_path_set() {
    if [ -z "$LFS" ]; then
        echo "ERROR: \$LFS is not defined or blank" >&2
        exit 1
    fi
}

ensure_chroot() {
    if [ ! -f "/scripts/common.sh" ]; then
        echo "ERROR: This script must be running with chroot! Aborting..." >&2
        exit 1
    fi
}

with_chroot() {
    ensure_lfs_path_set && ensure_root_user

    # Set $LFS as the new root
    chroot "$LFS" /usr/bin/env -i   \
        HOME=/root                  \
        TERM="$TERM"                \
        PS1='(lfs chroot) \u:\w\$ ' \
        PATH=/usr/bin:/usr/sbin     \
        MAKEFLAGS="-j$(nproc)"      \
        TESTSUITEFLAGS="-j$(nproc)" \
        /bin/bash --login "$@"
}

FILENAME=$(basename "$0")
export LOG_DIR=$LFS/log # In chroot, $LFS is unset so this becomes just /log
export LOG_FILE=$LOG_DIR/${FILENAME%.*}.log

export LFS_VERSION="12.3"
export KERNEL_VERSION="6.13.4"
export KERNEL_VERSION_TAG="$KERNEL_VERSION-lfs-$LFS_VERSION"