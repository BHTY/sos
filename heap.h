#ifndef __HEAP_H
#define __HEAP_H
#include "types.h"

void init_heap(void*, size_t);
void* kmalloc(size_t);
void kfree(void*);
#endif