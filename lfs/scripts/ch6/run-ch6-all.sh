#!/bin/bash
PWD=$(dirname "$0")
. "$PWD/../common.sh"
set -xeuo pipefail

ensure_not_root_user

time {
  sh "$PWD/run-ch6.02-build-m4.sh"
  sh "$PWD/run-ch6.03-build-ncurses.sh"
  sh "$PWD/run-ch6.04-build-bash.sh"
  sh "$PWD/run-ch6.05-build-coreutils.sh"
  sh "$PWD/run-ch6.06-build-diffutils.sh"
  sh "$PWD/run-ch6.07-build-file.sh"
  sh "$PWD/run-ch6.08-build-findutils.sh"
  sh "$PWD/run-ch6.09-build-gawk.sh"
  sh "$PWD/run-ch6.10-build-grep.sh"
  sh "$PWD/run-ch6.11-build-gzip.sh"
  sh "$PWD/run-ch6.12-build-make.sh"
  sh "$PWD/run-ch6.13-build-patch.sh"
  sh "$PWD/run-ch6.14-build-sed.sh"
  sh "$PWD/run-ch6.15-build-tar.sh"
  sh "$PWD/run-ch6.16-build-xz.sh"
  sh "$PWD/run-ch6.17-build-binutils-pass2.sh"
  sh "$PWD/run-ch6.18-build-gcc-pass2.sh"
}
