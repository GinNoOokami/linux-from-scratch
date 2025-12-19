#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_lfs_path_set && ensure_root_user

mkdir -pv "$LFS"/{dev,proc,sys,run}

mount -v --bind /dev "$LFS/dev"

mount -vt devpts devpts -o gid=5,mode=0620,ptmxmode=0666 "$LFS/dev/pts"
mount -vt proc proc "$LFS/proc"
mount -vt sysfs sysfs "$LFS/sys"
mount -vt tmpfs tmpfs "$LFS/run"

if [ -h "$LFS"/dev/shm ]; then
  install -v -d -m 1777 "$LFS$(realpath /dev/shm)"
else
  mount -vt tmpfs -o nosuid,nodev tmpfs "$LFS/dev/shm"
fi

} 2>&1 | tee "$LOG_FILE"