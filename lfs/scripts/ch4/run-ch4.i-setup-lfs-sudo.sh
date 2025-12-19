#!/bin/bash
set -xeuo pipefail

. "$(dirname "$0")"/../common.sh
ensure_root_user

# Later, we will need to run commands as root so prepare for that
echo "lfs ALL = NOPASSWD : ALL" >> /etc/sudoers
echo 'Defaults env_keep += "LFS LC_ALL LFS_TGT PATH CONFIG_SITE MAKEFLAGS"' >> /etc/sudoers