#!/bin/bash
PWD=$(dirname "$0")
. "$PWD/../common.sh"
set -xeuo pipefail

ensure_root_user

time {
  with_chroot "$PWD/run-ch11.01-configure-release.sh"
  sh "$PWD/run-ch11.i-create-image.sh"
}
