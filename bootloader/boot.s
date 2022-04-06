.code16
.globl _start

_start:
    movw    %cs,    %ax
    movw    %ax,    %ds
    movw    %ax,    %es

    movw    $msg,   %si
    call    puts
1:
    jmp     1b

puts:
    movb    $0x0e,  %ah     # 0x0e代表 输出到tty
    movb    $0x00,  %bh     # 0x00代表 第0页
    movb    $0x00,  %bl     # 0x00代表 text
putc:
    movb    (%si),  %al
    inc     %si
    orb     $0x0,   %al
    je      puts_end
    int     $0x10
    jmp     putc
puts_end:
    ret

msg:    
    .ascii "GR, Welcom to OS World!\r\n"  
    .byte 0

.org    510
.word   0xaa55