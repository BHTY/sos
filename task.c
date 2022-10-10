#include "task.h"
#include "heap.h"
#include "types.h"
#include "terminal.h"

task* curTask;

void printTask(task* ptr){
    kprintf("%p ESP=%p EBP=%p EAX=%p EBX=%p ECX=%p\n", ptr, ptr->esp, -1, -1, -1, -1);
    kprintf(" EDX=%p ESI=%p EDI=%p EFLAGS=%b\n", -1, -1, -1, -1);
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