#!/bin/bash

PWD=$(dirname "$0")

"$PWD"/run-ch5.2-build-binutils-pass1.sh
"$PWD"/run-ch5.3-build-gcc-pass1.sh
"$PWD"/run-ch5.4-build-kernel-headers.sh
"$PWD"/run-ch5.5-build-glibc.sh
"$PWD"/run-ch5.6-build-libstdc++.sh