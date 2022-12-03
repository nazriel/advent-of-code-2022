#!/usr/bin/env bash

set -e

function lhs() {
  echo "$1" | awk '{ print $1 }'
}

function rhs() {
  echo "$1" | awk '{ print $2 }'
}

function translate() {
  echo "scissors"
}

function pick_points() {
  echo 0
}

function score_points() {
  echo 0
}

function play() {
  local oponent="$1"
  local player="$2"
  echo "loss"
}

function solution() {
  local line="$1"
  oponent=$(translate "$(lhs "$line")")
  player=$(translate "$(rhs "$line")")
  result=$(play "$oponent" "$player")

  points_for_result=$(score_points "$result")
  points_for_pick=$(pick_points "$player")

  total=$((points_for_pick + points_for_result))
  echo "$total"
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
