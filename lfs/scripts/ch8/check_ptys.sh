#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xe

{
ensure_root_user && ensure_chroot

# Make sure PTYs works before building
output=$(python3 -c 'from pty import spawn; spawn(["echo", "ok"])')
if [[ $output != ok* ]]; then
  echo 'PTY not working, check mounts'
  exit 1
fi

} 2>&1 | tee "$LOG_FILE"