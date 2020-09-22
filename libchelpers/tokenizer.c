#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <ctype.h>
#include <string.h>
#include <stdint.h>
#include <stdbool.h>

#include "tokenizer.h"

int count_toks( char *s )
{
    int ret = 0;
    for ( ; *s; s++)
        if (*s==',') ret++;

    return ret + 1;
}

int sep( char* s, char** toks )
{
    char *v = s;
    char *tok;

    while( tok = strsep( &v, "," ) )
    {
        printf("Got tok: %s\n", tok);
        *toks++ = tok;
    }

    return 0;
}

tokstr_t *tokenize( tokstr_t *toks )
{
    sep( toks->string, toks->toks );
    return toks;
}
