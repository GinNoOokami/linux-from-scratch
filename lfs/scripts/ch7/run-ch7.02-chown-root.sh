#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_lfs_path_set && ensure_root_user

chown --from lfs -R root:root "$LFS"/{usr,lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) chown --from lfs -R root:root "$LFS"/lib64 ;;
esac

} 2>&1 | tee "$LOG_FILE"