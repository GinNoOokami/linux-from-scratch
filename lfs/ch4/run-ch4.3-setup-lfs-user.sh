#!/bin/bash
set -xe

. "$(dirname "$0")"/../common.sh

{
ensure_lfs_path_set && ensure_root_user

if ! grep -qF "lfs" /etc/group; then
  groupadd lfs
fi

if ! grep -qF "lfs" /etc/passwd ; then
  useradd -s /bin/bash -g lfs -m -k /dev/null lfs
  echo lfs | passwd --stdin lfs
fi

chown -v lfs "$LFS"/{usr{,/*},lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) chown -v lfs "$LFS"/lib64 ;;
esac

} 2>&1 | tee "/tmp/$LOG_FILE"