#!/bin/bash
set -xe

. "$(dirname "$0")"/../common.sh

{
ensure_lfs_path_set && ensure_root_user

mkdir -v "$LFS"/sources
chmod -v a+wt "$LFS"/sources

wget https://www.linuxfromscratch.org/lfs/view/12.0/wget-list-sysv
wget --input-file=wget-list-sysv --continue --directory-prefix="$LFS"/sources

pushd "$LFS/sources"
  wget https://www.linuxfromscratch.org/lfs/view/12.0/md5sums
  md5sum -c md5sums
  rm md5sums
popd

chown root:root "$LFS"/sources/*

} 2>&1 | tee "/tmp/$LOG_FILE"