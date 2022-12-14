package main

import (
	"d5/impl"
	"fmt"
	"os"
)

func main() {
	if len(os.Args) < 2 {
		println("Please provide an input file")
		os.Exit(1)
	}

	input_file := os.Args[1]

	content := impl.ReadFileIntoString(input_file)

	// Part 1
	crates, instructions := impl.ExtractCrateAndInstructions(content)
	for _, instruction := range instructions {
		impl.ReorganizeCrates(crates, instruction)
	}
	fmt.Printf("Part1: %s\n", impl.GetTopCrates(crates))

	// Part 2
	crates, instructions = impl.ExtractCrateAndInstructions(content)
	for _, instruction := range instructions {
		impl.ReorganizeCratesPt2(crates, instruction)
	}
	fmt.Printf("Part2: %s\n", impl.GetTopCrates(crates))
}
