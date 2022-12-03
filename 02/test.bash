#!/usr/bin/env bats

. ./impl.bash

bats_require_minimum_version "1.8.0"

function test_lhs() { #@test
  run lhs "LHS RHS"
  [ "$output" = "LHS" ]

  run lhs
  [ "$output" = "" ]

  run lhs "LHS"
  [ "$output" = "LHS" ]
}

function test_rhs() { #@test
  run rhs "LHS RHS"
  [ "$output" = "RHS" ]

  run rhs
  [ "$output" = "" ]

  run rhs "LHS"
  [ "$output" = "" ]
}

function test_translate() { #@test
  run translate "A"
  [ "$output" = "rock" ]

  run translate "B"
  [ "$output" = "paper" ]

  run translate "C"
  [ "$output" = "scissors" ]

  run translate "H"
  [ "$output" = "" ]
  [ "$status" -eq 1 ]

  run translate ""
  [ "$output" = "" ]
  [ "$status" -eq 1 ]

  run translate
  [ "$output" = "" ]
  [ "$status" -eq 1 ]
  [ "$status" -eq 1 ]
}

function test_pick_points() { #@test
  run pick_points scissors
  [ "$output" -eq 3 ]

  run pick_points paper
  [ "$output" -eq 2 ]

  run pick_points rock
  [ "$output" -eq 1 ]

  run pick_points NotHandled
  [ "$output" = "" ]
  [ "$status" -eq 1 ]

  run pick_points
  [ "$output" = "" ]
  [ "$status" -eq 1 ]
}

function test_score_points() { #@test
  run score_points win
  [ "$output" -eq 6 ]

  run score_points draw
  [ "$output" -eq 3 ]

  run score_points loss
  [ "$output" -eq 0 ]

  run score_points uhandled
  [ "$output" = "" ]
  [ "$status" -eq 1 ]

  run score_points
  [ "$output" = "" ]
  [ "$status" -eq 1 ]
}

function test_play() { #@test
  run play "paper" "rock"
  [ "$output" = "loss" ]

  run play "paper" "paper"
  [ "$output" = "draw" ]

  run play "paper" "scissors"
  [ "$output" = "win" ]

  run play "unhandled" "scissors"
  [ "$output" = "" ]
  [ "$status" -eq 1 ]

  run play "paper" "unhandled"
  [ "$output" = "" ]
  [ "$status" -eq 1 ]

  run play
  [ "$output" = "" ]
  [ "$status" -eq 1 ]
}

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
