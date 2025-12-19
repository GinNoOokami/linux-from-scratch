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
fi

chown -v lfs "$LFS"/{usr{,/*},var,etc,tools,log}
case $(uname -m) in
  x86_64) chown -v lfs "$LFS"/lib64 ;;
esac 

} 2>&1 | tee "$LOG_FILE"