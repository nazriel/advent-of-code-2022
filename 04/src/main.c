#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "main.h"

struct Line* get_lines(const char* filename) {
    return NULL;
}

struct Pair* extract_pairs(struct Line* lines) {
    return NULL;
}

unsigned int count_overlapping_pairs(struct Pair* pairs) {
    unsigned int overlaping = 0;
    return overlaping;
}

int main(int argc, const char** argv) {
    struct Line* lines = get_lines(argv[1]);
    struct Pair* pairs = extract_pairs(lines);
    printf("overlaping pairs: %d\n", count_overlapping_pairs(pairs));
    return 0;
}
