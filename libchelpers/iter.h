#pragma once

typedef struct iter
{
    uint8_t *start;
    uint32_t elsize;
    void *data;
    uint8_t *end;
    bool circ;
    uint32_t count;
    uint32_t loops;
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


iter_t* iter_next( iter_t *iter );
