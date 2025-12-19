#!/bin/bash
PWD=$(dirname "$0")
. "$PWD/../common.sh"
set -xeuo pipefail

ensure_root_user

time {
  with_chroot "$PWD/run-ch9.02-build-lfs-bootscripts.sh"
  with_chroot "$PWD/run-ch9.04-device-management.sh"
  with_chroot "$PWD/run-ch9.05-configure-network.sh"
  with_chroot "$PWD/run-ch9.06-configure-bootscripts.sh"
  with_chroot "$PWD/run-ch9.07-configure-locale.sh"
  with_chroot "$PWD/run-ch9.08-configure-inputrc.sh"
  with_chroot "$PWD/run-ch9.09-configure-shells.sh"
}
