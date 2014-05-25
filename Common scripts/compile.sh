#!/bin/bash

echo '[+] Assembling with Nasm ... '
nasm -f $2 -o $1.o $1.nasm

echo '[+] Linking ...'
ld -o $1 $1.o

echo '[+] Your Shellcode:'
for i in $(objdump -d $1 | grep '^ ' |cut -f2); do echo -n "\x"$i; done;echo

echo '[+] To compile it, execute'
echo 'gcc -ggdb -z execstack -fno-stack-protector shellcode.c -o shellcode'

echo '[+] Done!'
