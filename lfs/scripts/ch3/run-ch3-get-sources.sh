#!/bin/bash
set -xe

. "$(dirname "$0")"/../common.sh

{
ensure_lfs_path_set && ensure_root_user
mkdir -v "$LFS"/sources
chmod -v a+wt "$LFS"/sources

# wget https://www.linuxfromscratch.org/lfs/view/12.4/wget-list-sysv
# wget --input-file=wget-list-sysv --continue --directory-prefix="$LFS"/sources
# rm wget-list-sysv

# Workaround to get around intermittent ftp outages
cp -r /tmp/sources/ "$LFS"/

pushd "$LFS/sources"
  wget https://www.linuxfromscratch.org/lfs/view/12.3/md5sums
  md5sum -c md5sums
  rm md5sums
popd

chown root:root "$LFS"/sources/*

} 2>&1 | tee "$LOG_FILE"