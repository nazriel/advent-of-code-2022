#!/usr/bin/env bash

set -e

function lhs() {
  echo "$1" | awk '{ print $1 }'
}

function rhs() {
  echo "$1" | awk '{ print $2 }'
}

function translate() {
  case "$1" in
    A|X) echo "rock" ;;
    B|Y) echo "paper" ;;
    C|Z) echo "scissors" ;;
    *) return 1 ;;
  esac
}

function pick_points() {
  case "$1" in
    paper) echo 2 ;;
    scissors) echo 3 ;;
    rock) echo 1 ;;
    *) return 1 ;;
  esac
}

function score_points() {
  case "$1" in
    win) echo 6 ;;
    draw) echo 3 ;;
    loss) echo 0 ;;
    *) return 1 ;;
  esac
}

function play() {
  local oponent="$1"
  local player="$2"

  declare -A win=(
    [scissors]="rock"
    [rock]="paper"
    [paper]="scissors"
  )

  if [ -z "$oponent" ] || [ -z "$player" ] || [ -z "${win[$oponent]}" ] || [ -z "${win[$player]}" ]; then
    return 1
  fi

  test "$oponent" = "$player" && { echo "draw"; return; }
  test "${win[$oponent]}" = "$player" && { echo "win"; return; }

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
