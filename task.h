#ifndef __TASKS_H
#define __TASKS_H
#include "types.h"

#define STACK_SIZE  4096

typedef volatile uint32_t mutex_t;

typedef struct task{
    uint32_t esp;
    struct task* next;
    struct task* prev;
    struct message_t *msg;
} task;

typedef struct{
    void* data;
    size_t size;
    mutex_t lock;
} atomic_t;

typedef struct message_t{
    void* data;
    struct task* sender;
    struct message_t *next;
} message_t;

//right now, messages are a quick and dirty hack
//eventually, TIDs/PIDs will be a thing, also messages will use atomic_t after base functionality is checked

void send_message(task* recipient, void* contents);
bool pop_message(message_t *msg);
void atomic_read(atomic_t *p, void *value);
void atomic_set(atomic_t *p, void *value);
void acquire_mutex(mutex_t *p);
void release_mutex(mutex_t *p);
void spawnThread(void (*fun)(), void* arg);
void init_tasking();
void yield();
void resume();
void createTask(task* ptr, void (*fun)(), void* arg);  
void printTasks();
#endif