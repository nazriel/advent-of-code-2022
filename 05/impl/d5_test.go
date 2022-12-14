package impl

import "testing"

func TestReadFileIntoString(t *testing.T) {
	expected :=
		`    [D]
[N] [C]
[Z] [M] [P]
 1   2   3

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
`

	actual := ReadFileIntoString("../test_input.txt")
	if actual != expected {
		t.Errorf("expected %v, got %v", expected, actual)
	}
}

func TestParseInstructionValidInput(t *testing.T) {
	expected := Instruction{1, 2, 1}
	actual, err := ParseInstruction("move 1 from 2 to 1")
	if err != nil {
		t.Errorf("failed to parse instruction: %v", err)
	}
	if actual != expected {
		t.Errorf("expected %v, got %v", expected, actual)
	}
}

func TestParseInstructionInValidInput(t *testing.T) {
	_, err := ParseInstruction("move 1 from 2")
	if err == nil {
		t.Errorf("parsing should fail: %v", err)
	}
}

func TestExampleInputPart1(t *testing.T) {
	content := ReadFileIntoString("../test_input.txt")

	crates, instructions := ExtractCrateAndInstructions(content)
	for _, instruction := range instructions {
		ReorganizeCrates(crates, instruction)
	}
	actual := GetTopCrates(crates)
	expected := "CMZ"
	if actual != expected {
		t.Errorf("expected %v, got %v", expected, actual)
	}
}

func TestExampleInputPart2(t *testing.T) {
	content := ReadFileIntoString("../test_input.txt")

	crates, instructions := ExtractCrateAndInstructions(content)
	for _, instruction := range instructions {
		ReorganizeCratesPt2(crates, instruction)
	}
	actual := GetTopCrates(crates)
	expected := "MCD"
	if actual != expected {
		t.Errorf("expected %v, got %v", expected, actual)
	}
}
