#!/bin/bash
set -xe

. "$(dirname "$0")"/../common.sh

{
ensure_lfs_path_set && ensure_root_user

chown -R root:root "$LFS"/{usr,lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) chown -R root:root "$LFS"/lib64 ;;
esac

} 2>&1 | tee "/tmp/$LOG_FILE"