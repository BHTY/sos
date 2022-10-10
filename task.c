#include "task.h"
#include "heap.h"
#include "types.h"
#include "terminal.h"

task* curTask;

void acquire_mutex(mutex_t *p){
    while(*p){
        yield();
    }
    *p = curTask;
}

void release_mutex(mutex_t *p){
    if(*p == curTask){
        *p = 0;
    }
}

void printTask(task* ptr){
    kprintf("%p ESP=%p EIP=%p EAX=%p EBX=%p ECX=%p\n", ptr, ptr->esp + 36, *(uint32_t*)(ptr->esp+32), *(uint32_t*)(ptr->esp), *(uint32_t*)(ptr->esp+4), *(uint32_t*)(ptr->esp+8));
    kprintf(" EDX=%p ESI=%p EDI=%p EFLAGS=%b\n", *(uint32_t*)(ptr->esp+12), *(uint32_t*)(ptr->esp+16), *(uint32_t*)(ptr->esp+20), *(uint32_t*)(ptr->esp+28));
}

void printTasks(){ //print address, reg contents
    task* ptr = curTask;

    do{
        printTask(ptr);
        ptr = ptr->next;
    }while(ptr != curTask);
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

    *(uint32_t*)     (  stack + STACK_SIZE - 1 * sizeof(uint32_t)   )    = (uint32_t)arg;
    *(uint32_t*)     (  stack + STACK_SIZE - 3 * sizeof(uint32_t)   )    = (uint32_t)fun;
    *(uint32_t*)     (  stack + STACK_SIZE - 2 * sizeof(uint32_t)   )    = (uint32_t)thread_cleanup;
}

void init_tasking(){
    curTask = kmalloc(sizeof(task));
    curTask->next = curTask;
    curTask->prev = curTask;
}

void spawnThread(void (*fun)(), void* arg){ 
    task* temp = curTask->next;
    curTask->next = kmalloc(sizeof(task));
    curTask->next->prev = curTask;
    curTask->next->next = temp;
    createTask(curTask->next, fun, arg);
}