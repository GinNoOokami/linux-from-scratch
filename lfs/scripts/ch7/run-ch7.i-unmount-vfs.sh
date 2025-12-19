#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -x

{
ensure_lfs_path_set && ensure_root_user

mountpoint -q $LFS/dev/shm && umount $LFS/dev/shm
umount $LFS/dev/pts
umount $LFS/{sys,proc,run,dev}

} 2>&1 | tee "$LOG_FILE"

