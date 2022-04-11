#include "screen.h"

pvga_elem frame_buffer = VGA_ADR;
cursor cs = {0, 0};

void init_fb()
{
    frame_buffer = VGA_ADR;
    cs.x = 0;
    cs.y = 0;
    set_cs(&cs);
}

void clear_screen() 
{
    // pvga_elem frame_buffer = VGA_ADR;
    for(int row = 0; row < ROWS; ++row) {
        for(int col = 0; col < COLS; ++col) {
            frame_buffer[LINE_OFFSET(row, col)].ch   = ' ';
            frame_buffer[LINE_OFFSET(row, col)].mode = TEXT_MODE;
        }
    }
    cs.x = 0;
    cs.y = 0;
    set_cs(&cs);

}

void print_str(const char * str, int row, int col)
{
    unsigned short offset = LINE_OFFSET(row, col);
    for(int i = 0; str[i]; i++) {
        print_ch(str[i]);
    }
}

void print_ch(unsigned char ch)
{
    unsigned short offset = LINE_OFFSET(cs.x, cs.y);
    if(ch == '\r')
    {
        cs.y = 0;
    }
    else if(ch == '\n')
    {
        cs.x += 1;
    }
    else {
        frame_buffer[offset].ch      = ch;
        frame_buffer[offset].mode    = TEXT_MODE;
        offset += 1;
        offset2rl(offset, &cs);
    }

    handle_scrolling();
    set_cs(&cs);
}

void offset2rl(unsigned short offset, pcursor pcs)
{
    pcs->y = offset % COLS;
    pcs->x = offset / COLS;
}

void set_cs(pcursor pcs)
{
    unsigned short offset = LINE_OFFSET(pcs->x, pcs->y);
    
    write_io_byte(REG_SCREEN_CTRL, 14);
    write_io_byte(REG_SCREEN_DATA, (unsigned char)(offset >> 8));

    write_io_byte(REG_SCREEN_CTRL, 15);
    write_io_byte(REG_SCREEN_DATA, (unsigned char)(offset));
}

void handle_scrolling()
{
    if(cs.x >= 25) {
        hey_memcpy((unsigned char *)(frame_buffer+COLS), (unsigned char *)frame_buffer, (ROWS - 1) * COLS * sizeof(vga_elem));
        cs.x = 24;
        for(int i = 0; i < COLS; i++) {
            frame_buffer[LINE_OFFSET(24, i)].ch = ' ';
            frame_buffer[LINE_OFFSET(24, i)].mode = TEXT_MODE;
        }
        // clear_screen();
    }
    
}

void hey_memcpy(unsigned char * src, unsigned char * dest, unsigned short size)
{
    for(unsigned int i = 0; i < size; ++i) {
        dest[i] = src[i];
    }   
}