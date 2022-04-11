#pragma once

// io port map
#define REG_SCREEN_CTRL 0x3D4
#define REG_SCREEN_DATA 0x3D5



unsigned char read_io_byte(unsigned short port);

unsigned short read_io_word(unsigned short port);

void write_io_byte(unsigned short port, unsigned char data);

void write_io_word(unsigned short port, unsigned short data);