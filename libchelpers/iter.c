#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <ctype.h>
#include <string.h>
#include <stdint.h>
#include <stdbool.h>

#include <time.h>

#include "iter.h"


iter_t * iter_next( iter_t *iter )
{
    if ( !iter->data )
        iter->data = iter->start;
    else
        iter->data += iter->elsize;
    
    if ((uint8_t*)iter->data >= iter->end)
    {
        if(iter->circ){
            iter->data = iter->start;
            iter->loops++;
        }
        else
            iter->data = NULL;
    } 

    iter->count++;

    return iter->data ? iter : NULL;
}



