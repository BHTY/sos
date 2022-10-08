#include "types.h"
#include "string.h"
#include "terminal.h"
#include "bitarray.h"
#include "8042.h"
#include "heap.h"

#define TOTALHEAPSIZE   16384
uint8_t HEAP[16384];

#define STACK_SIZE  512

uint32_t stacks[16384];
size_t stackptr = 0;

typedef struct task{
    uint32_t esp;
    struct task* next;
} task;

task* curTask;
task mainTask;
task otherTask;
task thirdTask;

void yield();

void createTask(task* ptr, void (*fun)()){ //varargs
    char str[20];
    uint32_t stack = kmalloc(STACK_SIZE);

    //push EIP, EFLAGS, EBP, EDI, ESI, EDX, ECX, EBX, EAX
    //ptr->esp = stackptr + STACK_SIZE - 9 * sizeof(uint32_t);
    //ptr->esp += (uint32_t)stacks;
    
    ptr->esp = stack + STACK_SIZE - 9*sizeof(uint32_t);
    
    ptr->next = 0;

    //*(uint32_t*)   (  (uint32_t)(stacks) + stackptr + STACK_SIZE - sizeof(uint32_t)    ) = (uint32_t)fun;
    *(uint32_t*)     (  stack + STACK_SIZE - sizeof(uint32_t)   )    = (uint32_t)fun;

    /*puts("  ");
    hex((uint32_t)(stackptr) + STACK_SIZE - sizeof(uint32_t), str);
    puts(str);
    puts("  ");*/
    
    stackptr += STACK_SIZE;
}


void biff(){

uint32_t counter = 0;
    char str[10];
    while(1){
        hex(counter, str);
        puts(str);
        counter++;
        yield();
    }
}

void otherbiff(){
    while(1){
    puts("Thread 3");
    yield();}
}

void debug(){
    char str[20];
    hex(curTask->esp, str);
    puts(str);
    putch('\n');
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

void main(){
    char str[20];

    init_heap(HEAP, TOTALHEAPSIZE);
    
    curTask = &mainTask;

    mainTask.next = &otherTask;

    createTask(&otherTask, biff);
    createTask(&thirdTask, otherbiff);
    otherTask.next = &thirdTask;
    thirdTask.next = curTask;

    while(1){
        puts("Thread 1 about to yield\n");
        yield();
        puts("Task-switched back into thread 1\n");
        
        //SET_TCB(&tb);

        //print_task_block(&tb);

        //puts(str);
        //putch('\n');
    }
}

/**void tnt(){
    size_t data[10];

    yield();

    kmemset(data, 0, sizeof(data));

    bitarray_t bitarray;

    bitarray.elements = 64;
    bitarray.data = data;

    for(int i = 0; i < 24; i++){
        bitarray_set(&bitarray, i, true);
    }

    char str[20];
    hex(0xDEADBEEF, str);

    while(1){
        hex(bitarray.data[0], str);
        puts(str);
        putch('\n');
        getch();
    }

    return;
}**/