#include "heyos.h"

void kernel_entry()
{
    init_fb();
    clear_screen();
    const char * hello_str = "GR!, Welcom to OS world!\r\n";
    print_str(hello_str);
    
    for(int i = 0; ; i++);
}
