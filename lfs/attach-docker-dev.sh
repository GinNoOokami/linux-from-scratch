#!/bin/bash

docker exec -it "$(docker ps --format json | jq 'select(.Image="lfs") | .Names' | sed s/\"//g)" bash