#!/bin/bash

PWD=$(dirname "$0")

"$PWD"/run-ch4.2-create-partial-fhs.sh
"$PWD"/run-ch4.3-setup-lfs-user.sh
su -c /tmp/lfs-scripts/ch4/run-ch4.4-setup-lfs-env.sh - lfs
