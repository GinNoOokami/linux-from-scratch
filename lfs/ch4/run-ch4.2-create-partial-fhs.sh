#!/bin/bash
set -xe

. "$(dirname "$0")"/../common.sh

{
ensure_lfs_path_set && ensure_root_user

mkdir -pv "$LFS"/{etc,var} "$LFS"/usr/{bin,lib,sbin}

for i in bin lib sbin; do
  ln -svfn usr/$i "$LFS"/$i
done

case $(uname -m) in
  x86_64) mkdir -pv "$LFS"/lib64 ;;
esac

mkdir -pv "$LFS"/tools

} 2>&1 | tee "/tmp/$LOG_FILE"