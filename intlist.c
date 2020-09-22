#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <ctype.h>
#include <string.h>
#include <stdint.h>
#include <stdbool.h>

#include "iter.h"
#include "tokenizer.h"

int main(int c, char *v[])
{
    char *next, *ptr;

    tokstr_t toks = INIT_TOKSTR(v[1]);

    long ret;

    if (c<2)
        return -1;

    printf("Size of tokstr_t is : %lu\n", sizeof(tokstr_t));
    tokenize( &toks );

    printf("I got %d toks...\n", toks.count);

    printf("Tok1: [%p] %s\n", toks.toks[0], toks.toks[0]);
    printf("Tok1: [%p] %s\n", toks.toks[1], toks.toks[1]);
    printf("Tok1: [%p] %s\n", toks.toks[2], toks.toks[2]);
    printf("Tok1: [%p] %s\n", toks.toks[3], toks.toks[3]);
    printf("Tok1: [%p] %s\n", toks.toks[4], toks.toks[4]);

    iter_t *iter;
    iter = ITER_INIT( toks.toks, toks.count, true );

    char **tok;
    while( tok = iter_next(iter) ) 
    {
        printf("[%p]\n",  *tok);
        printf("[%s]\n", *tok);
    }

    return 0;

    for ( v++,c-- ; c ; c--) 
    {
        ptr = *v++;
        do
        {
            printf("%d\n", *ptr);

            /* Ignores LEADING ws but not TRAILING */
            ret = strtol(ptr, &next, 10);

            if (!ret && errno)
                return 1;

            /* We're stuck - get unstuck */
            if (ptr == next)
            {
                /* Gobble TRAILING whitespace */
                while( isspace(*ptr) ) ptr++;

                /* Test for bad format */
                if (*ptr == ',')
                    ptr++;
                else
                    return printf("Bad format\n"),1;
            }
            else
            {
                printf("The number(unsigned long integer) is %ld\n", ret);
                printf("String part is |%s|\n", ptr);

                ptr = next;
            }

        }while(*ptr);
    }

    return 0;
}
