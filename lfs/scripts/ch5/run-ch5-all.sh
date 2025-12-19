#!/bin/bash
PWD=$(dirname "$0")
. "$PWD/../common.sh"
set -xeuo pipefail

ensure_not_root_user

time {
  sh "$PWD/run-ch5.02-build-binutils-pass1.sh"
  sh "$PWD/run-ch5.03-build-gcc-pass1.sh"
  sh "$PWD/run-ch5.04-build-kernel-headers.sh"
  sh "$PWD/run-ch5.05-build-glibc.sh"
  sh "$PWD/run-ch5.06-build-libstdc++.sh"
}
