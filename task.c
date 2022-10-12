#include "task.h"
#include "heap.h"
#include "types.h"
#include "terminal.h"
#include "string.h"

task* curTask;

void acquire_mutex(volatile mutex_t *p){
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

void* atomic_read_lock(atomic_t *p){
    acquire_mutex(&(p->lock));
    return p->data;
}

void atomic_set_release(atomic_t *p, void *value){
    while(p->lock != curTask){
        yield();
    }

    p->data = value;

    release_mutex(&(p->lock));
}

void atomic_set(atomic_t *p, void *value){ //use LOCK
    acquire_mutex(&(p->lock));

    asm(".intel_syntax noprefix");
        asm("mov eax, DWORD PTR [ebp+8]\n\t");
        asm("mov esi, DWORD PTR [ebp+12]\n\t");
        asm("mov edi, DWORD PTR [eax]\n\t");
        asm("mov ecx, DWORD PTR [eax+4]\n\t");
        asm("rep movsb");
    asm(".att_syntax prefix");
    
    release_mutex(&(p->lock));
}

void atomic_read(atomic_t *p, void *value){ //use LOCK
    acquire_mutex(&(p->lock));
    
    asm(".intel_syntax noprefix");
        asm("mov eax, DWORD PTR [ebp+8]\n\t");
        asm("mov edi, DWORD PTR [ebp+12]\n\t");
        asm("mov esi, DWORD PTR [eax]\n\t");
        asm("mov ecx, DWORD PTR [eax+4]\n\t");
        asm("rep movsb");
    asm(".att_syntax prefix");

    release_mutex(&(p->lock));
}

void send_message(task *recipient, void *contents){
    message_t **msg = &(recipient->msg);
    
    while(*msg){
        yield();
        msg = (*msg)->next;
    }

    *msg = kmalloc(sizeof(message_t));
    (*msg)->next = 0;
    (*msg)->sender = curTask;
    (*msg)->data = contents;
}

bool pop_message(message_t *msg){
    yield();

    if(curTask->msg){

        message_t *oldmsg = curTask->msg;

        kmemcpy(msg, curTask->msg, sizeof(message_t));
        curTask->msg = curTask->msg->next;
        kfree(oldmsg);

        return 1;
    }
    return 0;
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

void trace(task* tsk){
    uint32_t EBP = *(uint32_t*)(tsk->esp + 24);
    uint32_t EIP = *(uint32_t*)(tsk->esp + 32);

    kprintf("Performing stack trace\n");
    kprintf("CS:%p\n", EIP);

    while(EBP){
        if(*(uint32_t*)(EBP+4)){kprintf("CS:%p\n", *(uint32_t*)(EBP+4));}
        else{break;}
        EBP = *(uint32_t*)EBP;
    }

}

void thread_cleanup(){
    task* tmp = curTask;

    curTask->prev->next = curTask->next;
    curTask->next->prev = curTask->prev;

    kfree(curTask->stack);
    curTask = curTask->next;
    kfree(tmp);

    //context switch into new curTask
    resume();
}

void createTask(task* ptr, void (*fun)(), void* arg){ 
    uint32_t stack = kmalloc(STACK_SIZE);
    
    ptr->esp = stack + STACK_SIZE - 11*sizeof(uint32_t);
    ptr->stack = stack;

    *(uint32_t*)     (  stack + STACK_SIZE - 1 * sizeof(uint32_t)   )    = (uint32_t)arg;
    *(uint32_t*)     (  stack + STACK_SIZE - 3 * sizeof(uint32_t)   )    = (uint32_t)fun;
    *(uint32_t*)     (  stack + STACK_SIZE - 2 * sizeof(uint32_t)   )    = (uint32_t)thread_cleanup;
}

void init_tasking(){
    curTask = kmalloc(sizeof(task));
    curTask->next = curTask;
    curTask->prev = curTask;
}

task* spawnThread(void (*fun)(), void* arg){ 
    task* temp = curTask->next;
    curTask->next = kmalloc(sizeof(task));
    curTask->next->prev = curTask;
    curTask->next->next = temp;
    //curTask->next->next->prev = 
    createTask(curTask->next, fun, arg);

    return curTask->next;
}