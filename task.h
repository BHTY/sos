#ifndef __TASKS_H
#define __TASKS_H
#include "types.h"

#define STACK_SIZE  4096

typedef struct task{
    uint32_t esp;
    struct task* next;
    struct task* prev;
} task;

void spawnThread(void (*fun)(), void* arg);
void init_tasking();
void yield();
void resume();
void createTask(task* ptr, void (*fun)(), void* arg);  
#endif