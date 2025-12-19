#!/bin/bash
set -xeuo pipefail

. "$(dirname "$0")"/../common.sh

{
ensure_root_user

pushd /tmp

time {
  IMG_FILE=lfs.img
  IMG_MNT=/mnt/img
  SIZE_MB=2048

  # Create a disk image file
  dd if=/dev/zero of=$IMG_FILE bs=1M count=$SIZE_MB
  
  mkfs.ext4 $IMG_FILE

  # Assign a loop device to the disk image file
  LOOP=$(losetup --find --show $IMG_FILE)
  echo Using loop device: ${LOOP}

  # Create a partition for the root fs
#   sfdisk $LOOP <<EOF
# label: dos
# unit: sectors
# ${LOOP}p1 : start=2048, type=83, bootable
# EOF

#   # Rescan the partition table
#   kpartx -a $LOOP

#   sfdisk -d $LOOP
#   lsblk $LOOP

#   # Create a fs in the root fs partition we created
#   mkfs.ext4 ${LOOP}p1

  mkdir -p $IMG_MNT
  mount ${LOOP} $IMG_MNT

  rsync -aHAX --exclude={/proc,/sys,/dev,/run,/sources,/scripts} $LFS/ $IMG_MNT/
  ls -la $IMG_MNT

  with_chroot <<EOF
set -x
mount | grep -E '/(dev|proc|sys)'
df /boot
lsblk
grub-install --boot-directory=/boot --force --skip-fs-probe $LOOP
EOF

  umount $IMG_MNT
  losetup -d $LOOP

  ls -la $IMG_FILE
  rm $IMG_FILE
}

popd

} 2>&1 | tee "$LOG_FILE"