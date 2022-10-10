#pragma GCC diagnostic ignored "-Wint-conversion"

#include "types.h"
#include "string.h"
#include "terminal.h"
#include "bitarray.h"
#include "8042.h"
#include "heap.h"
#include "task.h"

void clearscreen(){
    uint8_t *ptr;

    for(ptr = 0xb8000; ptr < (0xb8000+80*25*2); ptr++){
        *ptr = 0;
    }
}

uint8_t kill = 0;

void bg(size_t arg){
    uint16_t oldpos = 0;
    uint16_t counter = 0;

    while(1){
        if(kill){
            return;
        }

        setcolor(0x04);
        oldpos = getpos();
        gotoxy(arg, 0);
        kprintf("%x", counter++);
        gotoxy(oldpos-(80*(oldpos/80)), oldpos/80);
        yield();
    }
}

void main(){ //console commands - ver and proc

    uint8_t line = 1;
    char buf[100];

    clearscreen();

    init_heap(0x100000, 0x100000);

    init_tasking();
    spawnThread(bg, 76);

    setcolor(0x0B);
    puts("Welcome to POS 0.20!\n");
    setcolor(0x0E);

    while(1){
        setcolor(0x0E);
        puts("cmd> ");
        gets(buf);
        setcolor(0x02);

        if(strcmp(buf, "ver") == 0){
            puts("POS 0.20 by Will Klees (2022)\n");
        }
        else if(strcmp(buf, "proc") == 0){
            printTasks();
        }else if(strcmp(buf, "kill") == 0){
            kill = 1;
        }

        line++;
        yield();
        
        //SET_TCB(&tb);

        //print_task_block(&tb);

        //puts(str);
        //putch('\n');
    }
}
