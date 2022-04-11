
.equ    VGA_ADR,    0xb8000
.equ    WonB,       0x07
.equ    KER_ADR,    0x1000



.code16
.globl boot_start

boot_start:
    movw    %cs,            %ax
    movw    %ax,            %ds
    movw    %ax,            %es
    movw    $0x7c00,        %sp

    push    $msg_real
    call    puts
    add     $0x2,           %sp

    movw    $KER_ADR,       %bx             # store where memory
    movb    $0x5,           %dh             # read  how many sectors
    movb    %dl,            boot_driver     # boot device number and
    movb    boot_driver,    %dl             # record it
    call    read_disk

switch_pm:
    cli                 # clear int

    lgdt    gdt_desc
    movl    %cr0,   %eax
    or      $0x1,   %eax
    movl    %eax,   %cr0
    ljmp    $(1<<3),    $pm_start

here:
    jmp     here

.include "bios_tools.s"

.code32
.globl kernel_entry
.extern kernel_entry

pm_start:
    movw    $(2<<3),    %ax
    movw    %ax,        %ds
    movw    %ax,        %es
    movw    %ax,        %ss
    movw    %ax,        %fs
    movw    %ax,        %gs 
    movl    $0x90000,   %ebp
    movl    %ebp,       %esp

    push    $msg_pm
    call    puts_vga
    add     $0x4,   %esp

    call    KER_ADR

    jmp     .

puts_vga:
    push    %ebp
    movl    %esp,        %ebp
    pusha
    movl    0x8(%ebp),  %ebx
    movl    $VGA_ADR,   %ecx
    movb    $WonB,      %ah

putc_vga:
    movb    (%ebx),     %al
    cmpb    $0x0,       %al
    je      puts_vga_end
    movw    %ax,        (%ecx)
    inc     %ebx
    add     $0x2,       %ecx
    jmp     putc_vga

puts_vga_end:

    popa
    pop     %ebp
    ret

msg_real:    
    .ascii  "boot\r\n"  
    .byte   0
msg_pm:
    .ascii  "from vga: GR, welcom to P-M World!\r\n"
    .byte   0
error_msg:
    .ascii  "int 0x13 error\n\r"
    .byte   0
boot_driver:
    .byte   0
gdt:
    .long   0, 0    # null segment
gdt_code:
    .word   0xffff  # limit[15:0]
    .word   0x0     # base[15:0]
    .byte   0x0     # base[23:16]
    .byte   0x9a    # p dpl s type
    .byte   0xcf    # g d/b l avl limit[19:16]
    .byte   0x0     # base[31:24]     
gdt_data:
    .word   0xffff  # limit[15:0]
    .word   0x0     # ...
    .byte   0x0     # ...
    .byte   0x92    # ...
    .byte   0xcf    # ...
    .byte   0x0
gdt_desc:
    .word   gdt_desc-gdt-1
    .long   gdt
hexdata:
    .word   0x12af
.org    510
.word   0xaa55

