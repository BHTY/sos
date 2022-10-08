/*
    PS/2 driver
*/

#include "types.h"
#include "ports.h"

char getch(){
    while(!(io_read_8(0x64) & 0x1));
	uint8_t scancode = io_read_8(0x60);

    return 0;
}