#pragma once

#include "x86_io.h"

#define VGA_ADR     0xb8000
#define TEXT_MODE   0x7
#define ROWS        25
#define COLS        80
#define LINE_OFFSET(x_, y_) (x_ * COLS + y_)

typedef struct _vga_elem 
{
    char ch;
    char mode;
} vga_elem, * pvga_elem;

typedef struct _cursor
{
    unsigned char x;
    unsigned char y;
} cursor, * pcursor;

extern pvga_elem frame_buffer;
extern cursor cs;

void init_fb();

void clear_screen();

void print_str(const char * str, int row, int col);

void print_ch(unsigned char ch);

void offset2rl(unsigned short offset, pcursor pcs);

void set_cs(pcursor pcs);

void hey_memcpy(unsigned char * src, unsigned char * dest, unsigned short size);

void handle_scrolling();


