#!/bin/bash

ensure_root_user() {    
    if ! [ "$(id -u)" = 0 ]; then
        echo This script must be run as root! Aborting... >&2
        exit 1
    fi
}

ensure_not_root_user() {
    if [ "$(id -u)" = 0 ]; then
        echo This script must not be run as root! Aborting... >&2
        exit 1
    fi
}

ensure_lfs_path_set() {
    if [ -z "$LFS" ]; then
        echo "ERROR: $LFS is not defined or blank" >&2
        exit 1
    fi
}

FILENAME=$(basename "$0")
export LOG_FILE=${FILENAME%.*}.log