#pragma once

#include <stdlib.h>
#include <time.h>

#define PACKED __attribute__ ((packed))
#define CLEANUP __attribute__ ((__cleanup__(cleanup)))

#define FOR_EACH_SEP(res,str,sep) \
    for ( char**__cur = &(char*){str}, *res; ((res=strsep(__cur,sep)));  )

#define FOR_EACH_SEP_LITERAL(res,str,sep) \
    FOR_EACH_SEP(res,(char[]){str},sep)


#define MEM_STR(p,n) ({\
	static char __thread __msstorage[128];\
	char *scur = __msstorage;\
	const char *var = (const char*)(p);\
	const char *end = var+(n);\
	for( ; var<end; var++ )\
	scur += sprintf(scur, "%02X", *var);\
	*scur = 0;\
	__msstorage;})

#define MAC_STR(p) ({\
	static char __thread outstr[19];\
	char *scur = outstr;\
	char *var = (char*)p;\
	char *end = var+6;\
	for( ; var<end; var++ )\
	scur += sprintf(scur, "%02X:", *var);\
	outstr[17] = 0;\
	outstr;})

int msleep(long msec);
