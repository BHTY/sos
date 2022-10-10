#include "types.h"
#include "heap.h"
#include "string.h"
#include "terminal.h"

#define ALIGNMENT   4
#define align(x)	(((x % 4) == 0) ? x : (x + 4) - x % 4)

size_t HEAPSIZE;
void *heapStart;

typedef struct MemBlock{
	bool used;
	size_t size;
	struct MemBlock *prev;
	struct MemBlock *next;
	uint8_t data[0];
} MemBlock;

void printBlock(MemBlock *blk){
	if(blk->used){
		puts("USED ");
	}
	else{
		puts("FREE ");
	}
	kprintf("%p: %d bytes\n", blk->data, blk->size);
}

void printBlocks(){
	MemBlock *blk = heapStart;

	while(1){
		printBlock(blk);
		blk = blk->next;

		if(!blk){
			break;
		}
	}
}


void printhex(uint32_t hexnum){
    char str[10];
    hex(hexnum, str);
    puts(str);
}

void init_heap(void* start, size_t length){
	MemBlock temp;
    HEAPSIZE = length;
    heapStart = start;
	temp.used = false;
	temp.size = HEAPSIZE - sizeof(MemBlock);
	temp.prev = 0;
	temp.next = 0;
	kmemcpy(heapStart, &temp, sizeof(MemBlock));
}


void* kmalloc(size_t sz){
	MemBlock *curBlock = (MemBlock*)heapStart;
	MemBlock *oldNext;
	MemBlock *nextBlock;
	size_t oldSize;

	sz = align(sz);

	while (true){

		if (!(curBlock->used)){ //free block found

			if (curBlock->size >= (16 + sz)){ //is block big enough?
				oldSize = curBlock->size;
				oldNext = curBlock->next;
				//format current block
				curBlock->used = true;
				curBlock->size = sz;
				curBlock->next = (MemBlock*)((size_t)curBlock + 16 + sz);
				nextBlock = curBlock->next;

				nextBlock->used = false;
				nextBlock->prev = curBlock;

				if (oldNext == 0 || oldNext->used){ 
					nextBlock->next = oldNext;
					nextBlock->size = oldSize - (16 + sz);
				}
				else{ //oldnext is free, merge
					nextBlock->next = oldNext->next;
					nextBlock->size = oldSize - sz + oldNext->size;
				}

				break;
			}

		}

		curBlock = curBlock->next;

        if(!curBlock){
            return NULL;
        }
	}

	return curBlock->data;
}

void kfree(void* ptr){
	MemBlock* curBlock = (MemBlock*)((size_t)ptr - 16);
	//printf("%p", curBlock);

	if (curBlock->prev && !(curBlock->prev->used)){ //if block behind this is free, merge
		curBlock->prev->next = curBlock->next;
		curBlock->prev->size += 16 + curBlock->size;
		curBlock = curBlock->prev;
	}

	//if next block is unused, merge with that as well
	if (curBlock->next && !(curBlock->next->used)){
		curBlock->size += 16 + curBlock->next->size;
		curBlock->next = curBlock->next->next;
	}

	//mark as free
	curBlock->used = false;
}