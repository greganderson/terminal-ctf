#include <unistd.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

void gen_string(int seed, char* output, int length) {
    for (int i = 0; i < length; ++i) {
        output[i] = (char) ((seed + i) % 0xFFFF + 1);
    }
    output[length] = '\0';
}

int main(int argc, char* argv[]) {
    int seed = 42;
    int length = 7;
    char* output = (char*) malloc(length + 1);

    if (output == NULL) {
        fprintf(stderr, "Memory allocation failed\n");
        return 1;
    }

    gen_string(seed, output, length);
    printf("output: %s\n", output);

    for (int i = 0; i < length; ++i) {
        printf("%d ", output[i]);
    }
    printf("\n");

    printf("pid: %i\n", getpid());
    char psname[] = "mershy";
    strncpy(argv[0], psname, strlen(argv[0]));

    printf("Press Enter to continue...");
    getchar();

    free(output);

    return 0;
}
