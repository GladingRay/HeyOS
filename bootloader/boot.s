.code16
.globl _start



_start:
    movw    %cs,    %ax
    movw    %ax,    %ds
    movw    %ax,    %es
    movw    $0x8000,    %sp
    push    $msg
    call    puts
    add     $0x2,   %sp
    push    $hexdata
    call    put_hex
    add     $0x2,   %sp

here:
    jmp     here

.include "bios_tools.s"


msg:    
    .ascii  "GR, Welcom to boot World!\r\n"  
    .byte   0
hexdata:
    .word   0x12af
len:
    .byte .-msg
.org    510
.word   0xaa55
