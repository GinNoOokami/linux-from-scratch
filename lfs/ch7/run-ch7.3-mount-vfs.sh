#!/bin/bash
set -xe

. "$(dirname "$0")"/../common.sh

{
ensure_lfs_path_set && ensure_root_user

mkdir -pv "$LFS"/{dev,proc,sys,run}

mount -v --bind /dev "$LFS"/dev
mount -v --bind /dev/pts "$LFS"/dev/pts

mount -vt proc proc "$LFS"/proc
mount -vt sysfs sysfs "$LFS"/sys
mount -vt tmpfs tmpfs "$LFS"/run

if [ -h $LFS/dev/shm ]; then
  mkdir -pv "$LFS/$(readlink $LFS/dev/shm)"
else
  mount -t tmpfs -o nosuid,nodev tmpfs $LFS/dev/shm
fi

} 2>&1 | tee "/tmp/$LOG_FILE"