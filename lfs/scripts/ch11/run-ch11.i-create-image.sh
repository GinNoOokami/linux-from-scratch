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
  
  # Create an ext4 filesystem
  mkfs.ext4 $IMG_FILE

  # Assign a loop device to the disk image file
  LOOP=$(losetup --find --show $IMG_FILE)

  # Mount the loop
  mkdir -p $IMG_MNT
  mount ${LOOP} $IMG_MNT

  # Copy over everything we built, excluding anything we don't want in the final image
  rsync -aHAX --exclude={/proc,/sys,/dev,/run,/sources,/scripts,/log} $LFS/ $IMG_MNT/
  ls -la $IMG_MNT

  # Grub requires the virtual file systems to be mounted
  mkdir -pv "$IMG_MNT"/{dev,proc,sys,run}
  mount --bind /dev  $IMG_MNT/dev
  mount -t proc proc $IMG_MNT/proc
  mount -t sysfs sysfs $IMG_MNT/sys
  mount -t tmpfs tmpfs $IMG_MNT/run

  # Install grub to the loop device
  chroot $IMG_MNT /bin/bash <<EOF
grub-install --force $LOOP
EOF

  umount $IMG_MNT/{dev,proc,sys,run}

  umount $IMG_MNT
  rm -rf $IMG_MNT

  losetup -d $LOOP

  ls -la $IMG_FILE
  cp $IMG_FILE $LFS/log
  rm $IMG_FILE
}

popd

} 2>&1 | tee "$LOG_FILE"