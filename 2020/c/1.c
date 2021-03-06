#include <stdio.h>
#include <stdlib.h>
#include "aoc.h"

enum {
    NBUF = 1024
};

int main(void)
{
    int in[NBUF], *p, n, i, j, x;

    hinit();

    /* Read expenses from STDIN into hash table (kudos sam-kirby) */
    for (n = 0, p = &in[0]; n < NBUF && scanf("%d\n", p++) != EOF; n++) {
        hintinsert(in[n], in[n]);
    }

    /* Part A */
    for (i = 0; i < n; i++) {
        x = 2020 - in[i];
        if (hintlookup(x) != NULL) {
            printf("A) %d * %d = %d\n", in[i], x, in[i] * x);
            break;
        }
    }

    /* Part B */
    for (i = 0; i < n; i++) {
        for (j = i + 1; j < n; j++) {
            x = 2020 - in[i] - in[j];
            if (hintlookup(x) != NULL) {
                printf("B) %d * %d * %d = %d\n", in[i], in[j], x,
                       in[i] * in[j] * x);
                i = j = n;
            }
        }
    }

    hfree(free);

    return 0;
}
