#!/bin/bash
set -xe

. "$(dirname "$0")"/../common.sh

{
ensure_root_user && ensure_chroot

time {
  echo $LFS_VERSION > /etc/lfs-release

  cat > /etc/lsb-release << EOF
DISTRIB_ID="Linux From Scratch"
DISTRIB_RELEASE="$LFS_VERSION"
DISTRIB_CODENAME="LFS"
DISTRIB_DESCRIPTION="Linux From Scratch"
EOF

  cat > /etc/os-release << EOF
NAME="Linux From Scratch"
VERSION="$LFS_VERSION"
ID=lfs
PRETTY_NAME="Linux From Scratch $LFS_VERSION"
VERSION_CODENAME="LFS"
HOME_URL="https://www.linuxfromscratch.org/lfs/"
RELEASE_TYPE="stable"
EOF
}

} 2>&1 | tee "$LOG_FILE"