#!/bin/bash
set -xe

. "$(dirname "$0")"/../common.sh

{
ensure_root_user && ensure_chroot

time {
    # Create the custom udev rules
    chmod +x /usr/lib/udev/init-net-rules.sh
    bash /usr/lib/udev/init-net-rules.sh
    cat /etc/udev/rules.d/70-persistent-net.rules
}

} 2>&1 | tee "$LOG_FILE"