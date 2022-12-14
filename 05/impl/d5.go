package impl

import (
	"fmt"
	"io"
	"os"
	"regexp"
	"strconv"
	"strings"
)

// define struct for instruction
type Instruction struct {
	count int
	from  int
	to    int
}

type Crate struct {
	letter   string
	position int
}

func ReadFileIntoString(filename string) string {
	f, err := os.Open(filename)
	if err != nil {
		panic(err)
	}
	defer f.Close()

	content, err := io.ReadAll(f)
	if err != nil {
		panic(err)
	}

	return string(content)
}

func ParseInstruction(line string) (Instruction, error) {
	pattern := `move (\d+) from (\d) to (\d)`
	regex := regexp.MustCompile(pattern)

	result := regex.FindStringSubmatch(line)
	if len(result) == 0 {
		return Instruction{}, fmt.Errorf("faile to parse line with instruction")
	}
	var err error
	instruction := Instruction{}
	instruction.count, err = strconv.Atoi(result[1])
	if err != nil {
		return Instruction{}, err
	}
	instruction.from, err = strconv.Atoi(result[2])
	if err != nil {
		return Instruction{}, err
	}
	instruction.to, err = strconv.Atoi(result[3])
	if err != nil {
		return Instruction{}, err
	}

	return instruction, nil
}

func ParseCrates(line string) []Crate {
	crates := []Crate{}
	matches := (len(strings.TrimSuffix(line, " ")) + 1) / 4
	for i := 0; i < matches; i++ {
		chr := line[i*4+1]
		if chr != ' ' {
			crates = append(crates, Crate{letter: string(chr), position: i + 1})
		}
	}

	return crates
}

func ExtractCrateAndInstructions(content string) (map[int][]Crate, []Instruction) {
	cratesMap := map[int][]Crate{}
	var instructions []Instruction = []Instruction{}

	for _, line := range strings.Split(content, "\n") {
		if strings.HasPrefix(strings.ToLower(line), "move") {
			instruction, err := ParseInstruction(line)
			if err != nil {
				panic(err)
			}
			instructions = append(instructions, instruction)
		} else if strings.Contains(strings.ToLower(line), "[") {
			crates := ParseCrates(line)
			for _, crate := range crates {
				cratesMap[crate.position] = append(cratesMap[crate.position], crate)
			}
		}
	}

	return cratesMap, instructions
}

func ReorganizeCrates(crates map[int][]Crate, instruction Instruction) {
	take := crates[instruction.from][0:instruction.count]
	crates[instruction.from] = crates[instruction.from][instruction.count:]

	dest := crates[instruction.to]
	for _, t := range take {
		dest = append([]Crate{t}, dest...)
	}
	crates[instruction.to] = dest
}

func ReorganizeCratesPt2(crates map[int][]Crate, instruction Instruction) {
	take := crates[instruction.from][0:instruction.count]
	crates[instruction.from] = crates[instruction.from][instruction.count:]

	dest := crates[instruction.to]
	for i := len(take) - 1; i >= 0; i-- {
		dest = append([]Crate{take[i]}, dest...)
	}
	crates[instruction.to] = dest
}

func GetTopCrates(crates map[int][]Crate) string {
	top := make([]string, len(crates))
	for pos, crate := range crates {
		top[pos-1] = crate[0].letter
	}
	return strings.Join(top, "")
}
