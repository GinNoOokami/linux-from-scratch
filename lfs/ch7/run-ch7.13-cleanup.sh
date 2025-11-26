#!/bin/bash
set -xe

. "$(dirname "$0")"/../common.sh

{
ensure_root_user

# Cleanup documentation that shouldn't end up in the final system
rm -rf /usr/share/{info,man,doc}/*

# Cleanup unnecessary libtool files
find /usr/{lib,libexec} -name \*.la -delete

# Cleanup the temporary toolchain we no longer need
rm -rf /tools

} 2>&1 | tee "/tmp/$LOG_FILE"