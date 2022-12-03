.PHONY: input clean run test

all: input main run

main:
	ldc2 main.d

run: main
	./main input.txt

test:
	ldc2 -unittest -run main.d

input:
	@echo "Puzzles differ by user - you have to login and provide session ID from cookie via SESSION_ID env variable"
	@curl --silent -H "Cookie: session=${SESSION_ID}" https://adventofcode.com/2022/day/1/input > input.txt

clean:
	rm *.o
	rm main

