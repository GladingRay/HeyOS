puts:
    push    %bp
    movw    %sp,    %bp
    pusha
    movw    4(%bp), %si    
    movb    $0x0e,  %ah     # 0x0e代表 输出到tty
    movb    $0x00,  %bh     # 0x00代表 第0页
    movb    $0x00,  %bl     # 0x00代表 text
putc:
    movb    (%si),   %al
    inc     %si
    orb     $0x0,   %al
    je      puts_end
    int     $0x10
    jmp     putc
puts_end:
    popa
    pop     %bp
    ret

put_hex:
    push    %bp
    movw    %sp,    %bp

    pusha

    movb    $0x0e,  %ah     # 0x0e代表 输出到tty
    movb    $0x00,  %bh     # 0x00代表 第0页
    movb    $0x00,  %bl     # 0x00代表 text
    movb    $0x4,   %cl

    movw    4(%bp), %si
    movw    (%si),  %dx

    movb    %dh,    %al
    shr     %cl,    %al
    call    num2char
    int     $0x10

    movb    %dh,    %al
    andb    $0x0f,  %al
    call    num2char
    int     $0x10

    movb    %dl,    %al
    shr     %cl,    %al
    call    num2char
    int     $0x10

    movb    %dl,    %al
    andb    $0x0f,  %al
    call    num2char
    int     $0x10

    movb    $0x0d,  %al
    int     $0x10
    movb    $0x0a,  %al
    int     $0x10    
    popa
    pop     %bp
    ret


num2char:
    cmpb    $0xa,   %al
    jl      L1
    addb    $('a'-0xa),  %al
    jmp L1end
L1:
    addb    $'0',       %al
L1end:
    ret
    

    
