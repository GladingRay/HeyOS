#include "heyos.h"

void kernel_entry()
{
    init_fb();
    clear_screen();
    char * hello_str = "[rrr]GR! Welcom to OS world!\r\n";
    for(int i = 0; i < 99; i++)
    {
        hello_str[1] = '0' + i / 100;
        hello_str[2] = '0' + (i % 100) / 10;
        hello_str[3] = '0' + (i % 10);  
        print_str(hello_str, cs.x, cs.y);
    }
    
    for(int i = 0; ; i++);
}
