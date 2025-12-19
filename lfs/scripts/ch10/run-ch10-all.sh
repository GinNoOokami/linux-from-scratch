#!/bin/bash
PWD=$(dirname "$0")
. "$PWD/../common.sh"
set -xeuo pipefail

ensure_root_user

time {
  with_chroot "$PWD/run-ch10.02-create-fstab.sh"
  with_chroot "$PWD/run-ch10.03-build-linux-kernel.sh"
  with_chroot "$PWD/run-ch10.04-create-grub-config.sh"
}
