#include "screen.h"

pvga_elem frame_buffer = VGA_ADR;
cursor cs = {0, 0};

void init_fb()
{
    frame_buffer = VGA_ADR;
    cs.x = 0;
    cs.y = 0;
}

void clear_screen() 
{
    // pvga_elem frame_buffer = VGA_ADR;
    for(int row = 0; row < ROWS; ++row) {
        for(int col = 0; col < COLS; ++col) {
            frame_buffer[row * COLS + col].ch   = ' ';
            frame_buffer[row * COLS + col].mode = TEXT_MODE;
        }
    }
}

void print_str(const char * str)
{
    // pvga_elem frame_buffer = VGA_ADR;
    for(int i = 0; str[i]; i++) {
        frame_buffer[i].ch      = str[i];
        frame_buffer[i].mode    = TEXT_MODE;
    }
}