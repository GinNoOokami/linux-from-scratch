#!/bin/bash
set -xe

. "$(dirname "$0")"/../common.sh

{
ensure_root_user && ensure_chroot

time {
  mkdir -p /boot/grub
  cat > /boot/grub/grub.cfg << EOF
# Begin /boot/grub/grub.cfg
set default=0
set timeout=5

insmod ext2
set root=(hd0)
set gfxpayload=1024x768x32

menuentry "GNU/Linux, Linux $KERNEL_VERSION_TAG" {
        linux   /boot/vmlinuz-$KERNEL_VERSION_TAG root=/dev/sda ro
}
EOF
}

} 2>&1 | tee "$LOG_FILE"