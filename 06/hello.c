#include <stdio.h>

extern FILE* open_file();
extern char read_and_print(FILE*);

int main() {
    FILE* h = open_file();
    if (h == NULL) {
        printf("Error: open_file() failed\n");
        return 1;
    }

    char c;
    // do
    // {
        c = read_and_print(h);
        printf("%c", c);
    // } while (c != -1);

    fclose(h);
    // read_file(h);

    return 0;
}
