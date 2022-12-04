#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "main.h"

struct Line* get_lines(const char* filename) {
    FILE* fh = fopen(filename, "r");
    if (!fh) {
        fprintf(stderr, "failed to open %s file for reading", filename);
        return NULL;
    }
    const size_t buffLen = 255;
    char buff[buffLen];

    struct Line* head = NULL;
    struct Line* current_node = NULL;
    while (fgets(buff, buffLen, fh)) {
        struct Line* new_node = (struct Line*) malloc(sizeof(struct Line));
        new_node->len = strlen(buff);
        new_node->data = malloc(sizeof(char) * new_node->len);
        strncpy((char*) new_node->data, buff, new_node->len - 1);

        ((char*) new_node->data)[new_node->len] = '\0';

        if (current_node) {
            current_node->next = new_node;
        }
        current_node = new_node;
        if (!head) {
            head = current_node;
        }
    }
    fclose(fh);
    fh = NULL;

    return head;
}

struct Pair* extract_pairs(struct Line* lines) {
    struct Pair* head = NULL;
    struct Pair* current_pair = NULL;

    struct Line* current_line = lines;

    while (current_line) {
        struct Pair* new_pair = (struct Pair*) malloc(sizeof(struct Pair));
        sscanf(current_line->data, "%d-%d,%d-%d",
            &new_pair->left.start, &new_pair->left.end,
            &new_pair->right.start, &new_pair->right.end
        );
        printf("pairs %d, %d, %d, %d\n",
            new_pair->left.start, new_pair->left.end,
            new_pair->right.start, new_pair->right.end
        );
        if (current_pair) {
            current_pair->next = new_pair;
        }
        current_pair = new_pair;
        if (!head) {
            head = current_pair;
        }

        /* clean-up lines */
        free((void*) current_line->data);
        current_line->len = 0;
        struct Line* next = current_line->next;
        free(current_line);

        current_line = next;
    }
    return head;
}

unsigned int count_overlapping_pairs(struct Pair* pairs) {
    unsigned int overlaping = 0;
    struct Pair* pair = pairs;
    while (pair) {
        if (pair->left.start >= pair->right.start && pair->left.end <= pair->right.end) {
            overlaping += 1;
        } else if (pair->right.start >= pair->left.start && pair->right.end <= pair->left.end) {
            overlaping += 1;
        }
        pair = pair->next;
    }

    return overlaping;
}

int main(int argc, const char** argv) {
    struct Line* lines = get_lines(argv[1]);
    struct Pair* pairs = extract_pairs(lines);
    printf("overlaping pairs: %d\n", count_overlapping_pairs(pairs));
    return 0;
}
