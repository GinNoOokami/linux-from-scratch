#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

time {
    # Cleanup some extra files leftover from running tests
    rm -rf /tmp/{*,.*}

    # Remove useless libtool archive files
    find /usr/lib /usr/libexec -name \*.la -delete

    # Remove the temporary build toolchain
    find /usr -depth -name $(uname -m)-lfs-linux-gnu\* | xargs rm -rf

    # Remove the tester account
    userdel -r tester || true
}


} 2>&1 | tee "$LOG_FILE"