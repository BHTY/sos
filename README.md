# sos
Basic pmode operating system

Version 0.2 (in progress) tasks - post to OSdev "What does your OS look like?" and separate into v0.2 branch when done
* ATA/IDE PIO driver

Version 0.3 Tasks
* Filesystem driver
- Executable loader (decide on relocations vs PIC)
* Make the message passing not suck ass (add PIDs/TIDs for sender/receiver instead of slinging around task* pointers, make messages atomic, add -1 for systemwide broadcast)
* Basic terminal (no scripting capabilities - yet)
* * ver
* * cd
* * ls
* * mkd
* * del
* * <app name> - execs app

Version 0.4 tasks
* Preemptive multitasking (timer interrupt - make IDT, reprogram PIT to higher frequency)
* Filesystem driver
* Executable loader (decide on relocations vs PIC)
* VM86 monitor
* PS/2 mouse driver

Version 0.5 tasks
* VESA VCI driver
* Graphical terminal & demos
* Begin windowing system
* Mini libc
* Distinguish threads from processes - a process has a PID and associated message queue - that is a shared resource among threads for a given process

Current Status
* Real-mode "disk driver" (i.e. `loadsector` function that calls int 0x13)
* Switch into flat memory model (linear physical address space) protected mode
* Basic VGA (mode 0x03) text mode driver
* Prints out strings, chars, hex numbers
* Port I/O driver
* Data structures - bit array
* Kernel heap
* Cooperative multitasking (thread_cleanup function)
* PS/2 keyboard driver
* Mutexes and shitty atomic variables (basically variables with getters and setters protected by a mutex)
* Basic interthread message passing (message queue is a linked list of messages with a sender and void* message)
* Stack trace (return addresses only - no function names or local vars)
