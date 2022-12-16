#!/bin/bash

docker run -i --platform=linux/amd64 -v "$PWD":/src -w /src emilienmottet/nasm:latest /bin/sh - <<EOF
set -e
./main
EOF
