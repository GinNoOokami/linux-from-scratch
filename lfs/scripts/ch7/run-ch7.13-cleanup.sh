#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

# Cleanup documentation that shouldn't end up in the final system
rm -rf /usr/share/{info,man,doc}/*

# Cleanup unnecessary libtool files
find /usr/{lib,libexec} -name \*.la -delete

# Cleanup the temporary toolchain we no longer need
rm -rf /tools

} 2>&1 | tee "$LOG_FILE"