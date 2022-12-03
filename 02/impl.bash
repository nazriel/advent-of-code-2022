#!/usr/bin/env bash

set -e

function solution() {
  local line="$1"
  echo 0
}

function loop() {
  local input_file="${1:="test_input.txt"}"

  if [ ! -f "$input_file" ]; then
    echo "input file doesn't exist" >&2
    return 1
  fi

  score=0
  while IFS=$'$\n' read -r line; do
    total=$(solution "$line")
    score=$((score + total))
  done < "$input_file"
  echo "$score"
}
