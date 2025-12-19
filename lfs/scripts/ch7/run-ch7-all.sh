#!/bin/bash
PWD=$(dirname "$0")
. "$PWD/../common.sh"
set -xeuo pipefail

ensure_root_user

time {
  sh "$PWD/run-ch7.02-chown-root.sh"
  sh "$PWD/run-ch7.03-mount-vfs.sh"

  with_chroot $PWD/run-ch7.05-create-full-fhs.sh
  with_chroot $PWD/run-ch7.06-essential-sysfiles.sh
  with_chroot $PWD/run-ch7.07-build-gettext.sh
  with_chroot $PWD/run-ch7.08-build-bison.sh
  with_chroot $PWD/run-ch7.09-build-perl.sh
  with_chroot $PWD/run-ch7.10-build-python.sh
  with_chroot $PWD/run-ch7.11-build-texinfo.sh
  with_chroot $PWD/run-ch7.12-build-util-linux.sh
  with_chroot $PWD/run-ch7.13-cleanup.sh
}
