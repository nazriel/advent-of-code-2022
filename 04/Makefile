.PHONY: clean main test

test: main
	./main test_input.txt

run: main
	./main input.txt

main:
	gcc -std=c11 -I ./includes -g -o main src/main.c

clean:
	rm -f main main.o
	rm -rf *.dSYM/
