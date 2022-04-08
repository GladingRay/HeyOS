
.code16
.globl _start

.equ    VGA_ADR,    0xb800
.equ    WonB,       0x0f

_start:
    movw    %cs,    %ax
    movw    %ax,    %ds
    movw    %ax,    %es
    movw    $0x9000,    %sp

    push    $msg
    call    puts
    add     $0x2,   %sp

    movw    $0x7e00,   %bx
    movb    $0x1,       %dh
    movb    %dl,        boot_driver
    movb    boot_driver,    %dl

    call    read_disk
    movb    $'G',       %al
    push    $0x7e00
    call    put_hex
    add     $0x2,   %sp

here:
    jmp     here

.include "bios_tools.s"

#puts_vga:
#    push    %bp
#    movw    %sp,        %bp
#    pusha
#    movw    0x4(%bp),   %si
#    movw    $(VGA_ADR+0x90),   %di
#    movb    $WonB,      %ah

#putc_vga:
#    movb    (%si),      %al
#    cmpb    $0x0,       %al
#    je      puts_vga_end
#    movw    %ax,        (%di)
#    inc     %si
#   addw    $0x2,       %di
#    jmp     putc_vga

# puts_vga_end:

#    popa
#    pop     %bp
#    ret

msg:    
    .ascii  "from vga: GR, Welcom to boot World!\r\n"  
    .byte   0
error_msg:
    .ascii  "int 0x13 error\n\r"
    .byte   0
boot_driver:
    .byte   0

.org    510
.word   0xaa55
hexdata:
    .word   0x12af
