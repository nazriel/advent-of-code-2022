#ifndef MAIN_H
#define MAIN_H

#include <stddef.h>

struct Line  {
    const char* data;
    size_t len;
    struct Line* next;
};

struct Assigment {
    unsigned int start;
    unsigned int end;
};

struct Pair {
    struct Assigment left;
    struct Assigment right;
    struct Pair* next;
};

struct Line* get_lines(const char* filename);
struct Pair* extract_pairs(struct Line* lines);
unsigned int count_contained_pairs(struct Pair* pairs);
unsigned int count_overlapping_pairs(struct Pair* pairs);

#endif
