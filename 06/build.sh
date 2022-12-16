#!/bin/bash

docker run -i --platform=linux/amd64 -v "$PWD":/src -w /src emilienmottet/nasm:latest /bin/sh - <<EOF
set -e
nasm -f elf64 -o main.o main.asm
gcc main.o hello.c -o main
EOF
