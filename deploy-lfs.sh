#!/bin/bash
set -xe

REMOTE_HOST=$1
SSH_PORT=$2

rsync -av --delete -e "sshpass -p lfs ssh -p $SSH_PORT" "$(dirname "$0")/lfs/" "lfs@$REMOTE_HOST:/tmp/lfs-scripts/"
rsync -av --delete -e "sshpass -p lfs ssh -p $SSH_PORT" "$(dirname "$0")/lfs/" "lfs@$REMOTE_HOST:/mnt/lfs/tmp/lfs-scripts/"
