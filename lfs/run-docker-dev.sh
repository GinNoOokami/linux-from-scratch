#!/bin/bash

PWD="$(dirname "$0")"

# The extra caps are required for various parts of the build to work --cap-add=SYS_ADMIN --cap-add=NET_ADMIN
docker run --privileged -d -t -v /tmp/log:/mnt/lfs/log -v "$PWD"/scripts:/mnt/lfs/scripts:ro lfs bash
