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
mutex_t m;

extern task* curTask;

void bg(size_t arg){
    uint16_t oldpos = 0;
    uint16_t counter = 0;
    message_t msg;

    while(1){
        if(kill){
            return;
        }

        if(pop_message(&msg)){
            if(msg.data == 0xDEADBEEF){
                puts("TIMER: Message acknowledged, sending response.\n");
                send_message(curTask->next, counter);
            }
        }

        acquire_mutex(&m);
        release_mutex(&m);

        setcolor(0x04);
        oldpos = getpos();
        gotoxy(arg, 0);
        kprintf("%x", counter++);
        gotoxy(oldpos-(80*(oldpos/80)), oldpos/80);
        yield();
    }
}

void main(){ //console commands - ver and proc

    message_t msg;
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
        setcolor(0x04);
        gets(buf);
        setcolor(0x02);

        if(strcmp(buf, "ver") == 0){
            puts("POS 0.20 by Will Klees (2022)\n");
        }
        else if(strcmp(buf, "proc") == 0){
            printTasks();
        }else if(strcmp(buf, "kill") == 0){
            kill = 1;
        }else if(strcmp(buf, "pause") == 0){
            acquire_mutex(&m);
        }else if(strcmp(buf, "resume") == 0){
            release_mutex(&m);
        }else if(strcmp(buf, "count") == 0){
            kprintf("Sending message to counter thread, receiving message back with counter status\n");
            send_message(curTask->next, 0xDEADBEEF);
            while(!pop_message(&msg));
            kprintf("Response: %x\n", msg.data);
        }

        line++;

        yield();
        
        //SET_TCB(&tb);

        //print_task_block(&tb);

        //puts(str);
        //putch('\n');
    }
}
