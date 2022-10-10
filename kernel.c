#pragma GCC diagnostic ignored "-Wint-conversion"

#include "types.h"
#include "string.h"
#include "terminal.h"
#include "bitarray.h"
#include "8042.h"
#include "heap.h"
#include "task.h"

void biff(size_t var){

    char str[10];

    //return;
    var = 511;

    while(1){
        hex(var, str);
        puts(str);
        //var++;
        yield();
    }
}

void otherbiff(void* var){

    //return;

    while(1){
        setcolor(0x02);
        puts("THREAD 3: ");
        yield();
        setcolor(0x03);
        puts("Returned from yield!\n");
    }
}

void main(){

    init_heap(0x100000, 0x100000);

    init_tasking();
    spawnThread(biff, 0);
    spawnThread(otherbiff, 0);

    while(1){
        setcolor(0x02);
        kprintf("THREAD %d: ", 1);
        setcolor(0x04);
        puts("YIELDING\n");
        yield();
        
        //SET_TCB(&tb);

        //print_task_block(&tb);

        //puts(str);
        //putch('\n');
    }
}
