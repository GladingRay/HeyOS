#include "string.h"

int hey_strlen(const char * str) 
{
    int ret = 0;
    for(; str[ret]; ++ret);
    return ret;
}