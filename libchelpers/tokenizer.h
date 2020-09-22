#pragma once


typedef struct tokstr
{
    char* string;
    int count;
    char** toks;
}tokstr_t;

tokstr_t *tokenize( tokstr_t *toks );
int count_toks( char *s );

#define INIT_TOKSTR(n) { .string=n, .count=count_toks(n), .toks=alloca( sizeof(char*) * count_toks(n) ) }

