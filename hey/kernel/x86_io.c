#include "x86_io.h"

unsigned char read_io_byte(unsigned short port)
{
    unsigned char ret;
    __asm__("in %%dx, %%al" : "=a"(ret) :"d"(port) :);
    return ret;
}

unsigned short read_io_word(unsigned short port)
{
    unsigned short ret;
    __asm__("in %%dx, %%ax" : "=a"(ret) :"d"(port) :);
    return ret;
}

void write_io_byte(unsigned short port, unsigned char data)
{
    __asm__("out %%al, %%dx" : :"d"(port), "a"(data) :);
}

void write_io_word(unsigned short port, unsigned short data)
{
    __asm__("out %%ax, %%dx" : :"d"(port), "a"(data) :);
}