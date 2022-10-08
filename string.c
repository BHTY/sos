#include "types.h"

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