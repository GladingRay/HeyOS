#pragma once
#define VGA_ADR     0xb8000
#define TEXT_MODE   0x7
#define ROWS        25
#define COLS        80

typedef struct _vga_elem 
{
    char ch;
    char mode;
} vga_elem, * pvga_elem;

typedef struct _cursor
{
    unsigned int x;
    unsigned int y;
} cursor, * pcursor;

extern pvga_elem frame_buffer;
extern cursor cs;

void init_fb();

void clear_screen();

void print_str(const char * str);

