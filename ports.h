/*
    ports.h - Port I/O Driver for Kernel mode
*/

#define io_write_8(port, data)  __asm__ volatile ("outb %1, %0" : : "dN" ((uint16_t)port), "a" ((uint8_t)(data)))
#define io_write_16(port, data)  __asm__ volatile ("outw %1, %0" : : "dN" ((uint16_t)port), "a" ((uint16_t)(data)))
#define io_write_32(port, data)  __asm__ volatile ("outl %1, %0" : : "dN" ((uint16_t)port), "a" ((uint32_t)(data)))

uint8_t io_read_8(uint16_t port);
uint16_t io_read_16(uint16_t port);
uint32_t io_read_32(uint16_t port);