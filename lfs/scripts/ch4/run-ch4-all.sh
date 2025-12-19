#!/bin/bash
set -xe

PWD=$(dirname "$0")
. "$PWD/../common.sh"
ensure_root_user

time {
  sh "$PWD/run-ch4.02-create-partial-fhs.sh"
  sh "$PWD/run-ch4.03-setup-lfs-user.sh"
  su -c "$PWD/run-ch4.04-setup-lfs-env.sh" - lfs # Run as lfs user
  sh "$PWD/run-ch4.i-setup-lfs-sudo.sh"
}
