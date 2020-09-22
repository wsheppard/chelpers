#pragma once

typedef struct iter
{
    uint8_t *start;
    uint32_t elsize;
    uint8_t *last;
    uint8_t *end;
    bool circ;
}iter_t;

#define ARRAY_SIZE(a) ( sizeof(a) / sizeof(*a) )

#define ITER_INIT( a, n, c ) &(iter_t){ \
    .start=(uint8_t*)a, \
    .elsize=sizeof(*a), \
    .end=((uint8_t*)a)+sizeof(*a)*n, \
    .circ=c }

#define ITER_FROM_ARRAY( a, c ) &(iter_t){ \
    .start=(uint8_t*)a, \
    .elsize=sizeof(*a), \
    .end=((uint8_t*)a)+sizeof(a), \
    .circ=c }

void* iter_next( iter_t *iter );
