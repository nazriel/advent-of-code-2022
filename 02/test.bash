#!/usr/bin/env bats

. ./impl.bash

bats_require_minimum_version "1.8.0"

function test_loop() { #@test
  run loop test_input.txt
  [ "$status" -eq 0 ]
}
