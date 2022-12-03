#!/usr/bin/env bats

. ./impl.bash

bats_require_minimum_version "1.8.0"

function test_solution() { #@test
  run solution "A Y"
  [ "$output" -eq 8 ]

  run solution "B X"
  [ "$output" -eq 1 ]

   run solution "C Z"
  [ "$output" -eq 6 ]
}

function test_loop() { #@test
  run loop test_input.txt
  [ "$output" -eq 15 ]
}
