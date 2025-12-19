#!/bin/bash
set -xe

PWD="$(dirname "$0")"

# Ensure we've loaded our env vars
# shellcheck disable=SC1090
. ~/.bashrc

# Chapters 1 through 4 are configured in the dockerfile, so we start at chapter 5
sh "$PWD/ch5/run-ch5-all.sh"
sh "$PWD/ch6/run-ch6-all.sh"
sudo "$PWD/ch7/run-ch7-all.sh"
sudo "$PWD/ch8/run-ch8-all.sh"
sudo "$PWD/ch8/run-ch9-all.sh"
sudo "$PWD/ch8/run-ch10-all.sh"
sudo "$PWD/ch8/run-ch11-all.sh"