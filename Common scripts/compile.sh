#!/bin/bash

echo '[+] Assembling with Nasm ... '
nasm -f elf32 -o $1.o $1.nasm

echo '[+] Linking ...'
ld -o $1 $1.o

echo '[+] Your Shellcode:'
echo for i in $(objdump -d bind | grep '^ ' |cut -f2); do echo -n "\x"$i; done;echo

echo '[+] To compile it, execute'
echo 'gcc -ggdb -z execstack -fno-stack-protector shellcode.c -o shellcode'

echo '[+] Done!'
