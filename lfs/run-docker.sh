#!/bin/bash

# SYS_ADMIN cap is required for some of the later commands, like mount /dev
docker run -v /tmp/log:/mnt/lfs/log --cap-add=SYS_ADMIN --cap-add=NET_ADMIN lfs