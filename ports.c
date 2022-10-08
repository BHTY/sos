#include "types.h"

uint8_t io_read_8(uint16_t port){
    uint8_t io;
	__asm__ volatile ("inb %1, %0" : "=a" (io) : "dN" (port));
    return io;
}

uint16_t io_read_16(uint16_t port){
    uint16_t io;
	__asm__ volatile ("inw %1, %0" : "=a" (io) : "dN" (port));
    return io;
}

uint32_t io_read_32(uint16_t port){
    uint32_t io;
	__asm__ volatile ("inl %1, %0" : "=a" (io) : "dN" (port));
    return io;
}