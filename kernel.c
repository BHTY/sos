#pragma GCC diagnostic ignored "-Wint-conversion"

#include "types.h"
#include "string.h"
#include "terminal.h"
#include "bitarray.h"
#include "8042.h"
#include "heap.h"
#include "task.h"
#include "ports.h"

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

        yield();

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

void DVD(size_t arg){
    uint16_t _1, _2, _3, _4;
    uint8_t x, y;
    uint16_t *textptr = 0xb8000;
    x = 0;
    y = 0;
    int8_t dirX, dirY;
    uint16_t counter = 0x4000;

    dirX = 1;
    dirY = 1;

    _1 = textptr[y * 80 + x];
    _2 = textptr[y * 80 + x+1];
    _3 = textptr[(y+1) * 80 + x];
    _4 = textptr[(y+1) * 80 + x+1];

    while(1){
        textptr[y * 80 + x] = _1;
        textptr[y * 80 + x+1] = _2;
        textptr[(y+1) * 80 + x] = _3;
        textptr[(y+1) * 80 + x+1] = _4;

        //change X and Y
        if(dirX == 1){
            x++;
        }else if(dirX == -1){
            x--;
        }
        if(dirY == 1){
            y++;
        }else if(dirY == -1){
            y--;
        }

        if(x == 78){
            dirX = -1;
        }
        if(x == 0){
            dirX = 1;
        }
        if(y == 0){
            dirY = 1;
        }
        if(y == 23){
            dirY = -1;
        }

        _1 = textptr[y * 80 + x];
        _2 = textptr[y * 80 + x+1];
        _3 = textptr[(y+1) * 80 + x];
        _4 = textptr[(y+1) * 80 + x+1];

        textptr[y * 80 + x] = 0x4444;
        textptr[y * 80 + x+1] = 0x2222;
        textptr[(y+1) * 80 + x] = 0x1111;
        textptr[(y+1) * 80 + x+1] = 0xEEEE;     

        while(counter--){
            yield();
        }
        counter = 0x4000;
    }
}

void main(){ //console commands - ver and proc

    message_t msg;
    uint8_t line = 1;
    char buf[80];

    clearscreen();

    init_heap(0x100000, 0x100000);
    init_tasking();

    task *timer = spawnThread(bg, 76);

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
            yield();
            setcolor(0x02);
            printTasks();
        }else if(strcmp(buf, "kill") == 0){
            kill = 1;
        }else if(strcmp(buf, "pause") == 0){
            acquire_mutex(&m);
        }else if(strcmp(buf, "resume") == 0){
            release_mutex(&m);
        }else if(strcmp(buf, "count") == 0){
            kprintf("Sending message to counter thread, receiving message back with counter status\n");
            send_message(timer, 0xDEADBEEF);
            while(!pop_message(&msg)){yield();}
            kprintf("Response: %x\n", msg.data);
        }else if(strcmp(buf, "win") == 0){
            *(uint8_t*)(0xb8001) = 0x44;
            *(uint8_t*)(0xb8003) = 0xAA;
            *(uint8_t*)(0xb80a1) = 0x11;
            *(uint8_t*)(0xb80a3) = 0xEE;
        }else if(strcmp(buf, "spawn") == 0){
            puts("Spawning demo thread\n");
            spawnThread(DVD, 0);
        }else if(strcmp(buf, "mem") == 0){
            printBlocks();
        }else if(strcmp(buf, "trace") == 0){
            yield();
            setcolor(0x02);
            trace(curTask->next);
        }else if(strcmp(buf, "crash") == 0){
            asm(".intel_syntax noprefix");
            asm("JMP 0xFFFF:0");
            asm(".att_syntax prefix");
        }else if(strcmp(buf, "help") == 0){
            puts("If you're using this, you should really be able to help yourself\nBut just in case...\n");
            puts("ver - prints out version number information\n");
            puts("proc - prints out information on running threads\n");
            puts("mem - prints out memory usage information\n");
            puts("pause - Pauses the counter running in the upper right-hand corner of the screen\n");
            puts("resume - Resumes the counter if paused\n");
            puts("count - Sends a message to the counter thread then waits for a response back\n");
            puts("spawn - Spawns thread with bouncing logo around screen\n");
            puts("crash - Go figure.\n");
            puts("help - Imagine that.\n");
        }

        line++;

        yield();
        
        //SET_TCB(&tb);

        //print_task_block(&tb);

        //puts(str);
        //putch('\n');
    }
}
