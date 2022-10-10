#ifndef __TASKS_H
#define __TASKS_H
#include "types.h"

#define STACK_SIZE  4096

typedef struct task{
    uint32_t esp;
    struct task* next;
    struct task* prev;
} task;

typedef volatile uint32_t mutex_t;

void acquire_mutex(mutex_t *p);
void release_mutex(mutex_t *p);
void spawnThread(void (*fun)(), void* arg);
void init_tasking();
void yield();
void resume();
void createTask(task* ptr, void (*fun)(), void* arg);  
void printTasks();
#endif