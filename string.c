#include "types.h"
#include "terminal.h"

int memcmp(void *ptr1, void *ptr2, size_t count)
{
	uint8_t *temp1 = (uint8_t*) ptr1;
	uint8_t *temp2 = (uint8_t*) ptr2;

	for (size_t i = 0; i < count; i++)
	{
		if (temp1[i] != temp2[i])
		{
			return 1;
		}
	}

	return 0;
}

size_t strlen(char *str)
{
    size_t retval;
    
    for (retval = 0; *str; str++) retval++;
    
    return retval;
}

void kmemset(unsigned char* ptr, unsigned char value, size_t num){
    while(num--){
        *(ptr++) = value;
    }
}

void kmemcpy(unsigned char* dst, unsigned char* src, size_t count){
    while(count--){
        *(dst++) = *(src++);
    }
}

char* kstrcpy(char* dest, char* src){
    char* ptr = dest;

    while(*src){
        *(dest++) = *(src++);
    }

    *dest = 0;

    return ptr;
}

int strcmp(char *s1, char *s2)
{
	if (strlen(s1) != strlen(s2)){
        return 1;
    }

	return memcmp(s1, s2, strlen(s1));
}