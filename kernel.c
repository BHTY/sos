#pragma GCC diagnostic ignored "-Wint-conversion"

#include "types.h"
#include "string.h"
#include "terminal.h"
#include "bitarray.h"
#include "8042.h"
#include "heap.h"

#define TOTALHEAPSIZE   65536
uint32_t HEAP[16384];

#define STACK_SIZE  4096

typedef struct task{
    uint32_t esp;
    struct task* next;
    struct task* prev;
} task;

task* curTask;
task mainTask;
task otherTask;
task thirdTask;

void yield();
void resume();
void printhex(uint32_t hexnum);

void print_TCB(task* ptr){
    puts("\n");
    printhex(ptr);
    puts(" ptr->prev= ");
    printhex(ptr->prev);
    puts(" ptr->next= ");
    printhex(ptr->next);
    puts(" ptr->esp= ");
    printhex(ptr->esp);
}

void printAllThreads(){
    task* startingPtr = curTask;
    task* curPtr = startingPtr;

    while(1){
        print_TCB(curPtr);
        curPtr = curPtr->next;

        if(curPtr == startingPtr){
            break;
        }
    }
}

void thread_cleanup(){
    task* tmp = curTask;

    curTask->prev->next = curTask->next;
    curTask->next->prev = curTask->prev;

    kfree(curTask->esp);
    curTask = curTask->next;
    kfree(tmp);

    //context switch into new curTask
    resume();
}

void createTask(task* ptr, void (*fun)(), void* arg){ 
    uint32_t stack = kmalloc(STACK_SIZE);
    
    ptr->esp = stack + STACK_SIZE - 11*sizeof(uint32_t);
    ptr->next = 0;

    *(uint32_t*)     (  stack + STACK_SIZE - 1 * sizeof(uint32_t)   )    = (uint32_t)arg;
    *(uint32_t*)     (  stack + STACK_SIZE - 3 * sizeof(uint32_t)   )    = (uint32_t)fun;
    *(uint32_t*)     (  stack + STACK_SIZE - 2 * sizeof(uint32_t)   )    = (uint32_t)thread_cleanup;
}


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

void debug(){
    char str[20];
    hex(curTask->esp, str);
    puts(str);
    putch('\n');
    //puts("yo");
}


asm(".intel_syntax noprefix");

//store processor state
asm("yield:\n\t"
    "   pushfd\n\t"
    "   push ebp\n\t"
    "   push edi\n\t"
    "   push esi\n\t"
    "   push edx\n\t"
    "   push ecx\n\t"
    "   push ebx\n\t"
    "   push eax\n\t");

//curTask->esp = esp
asm("\n\tmov eax, DWORD PTR curTask\n\t"
    "   mov DWORD PTR [eax], esp\n\t");

//curTask = curTask->next & esp = curTask->esp
asm("\n\t\tmov eax, DWORD PTR curTask\n\t"
    "   mov eax, DWORD PTR [eax+4]\n\t"
    "   mov DWORD PTR curTask, eax\n\t"
    "   resume:\n\t"
    "   mov eax, DWORD PTR curTask\n\t"
    "   mov esp, DWORD PTR [eax]\n\t");

//restore and return
asm("   pop eax\n\t"
    "   pop ebx\n\t"
    "   pop ecx\n\t"
    "   pop edx\n\t"
    "   pop esi\n\t"
    "   pop edi\n\t"
    "   pop ebp\n\t"
    "   popfd\n\t"
    "   ret");

asm(".att_syntax prefix");

uint32_t globalesp;

void main(){

    //init_heap(HEAP, TOTALHEAPSIZE);
    init_heap(0x100000, 0x100000);

    curTask = &mainTask;

    createTask(&otherTask, biff, 0);
    createTask(&thirdTask, otherbiff, 0);

    mainTask.next = &otherTask;
    otherTask.next = &thirdTask;
    thirdTask.next = &mainTask;

    mainTask.prev = &thirdTask;
    otherTask.prev = &mainTask;
    thirdTask.prev = &otherTask;

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
