#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <ctype.h>
#include <string.h>
#include <stdint.h>
#include <stdbool.h>

#include <time.h>

#include "iter.h"


void* iter_next( iter_t *iter )
{
    if ( !iter->last )
        iter->last = iter->start;
    else
        iter->last += iter->elsize;
    
    if (iter->last >= iter->end)
    {
        if(iter->circ)
            iter->last = iter->start;
        else
            iter->last = NULL;
    } 

    printf("%p\n", iter->last);

    return iter->last;
}



