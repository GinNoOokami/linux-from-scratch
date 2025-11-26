#!/bin/bash
set -xe

. "$(dirname "$0")"/../common.sh
ensure_lfs_path_set && ensure_root_user

# Set $LFS as the new root
chroot "$LFS" /usr/bin/env -i   \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin     \
    /bin/bash --login