# sos
Basic pmode operating system

Tasks (no particular order)
1. Timer interrupt (make IDT, reprogram PIT to higher frequency) -> multithreading/multitasking! (+ message passing)
2. PS/2 keyboard driver
3. ATA/IDE PIO driver

Others: VESA, libc

Current Status
* Real-mode "disk driver" (i.e. `loadsector` function that calls int 0x13)
* Switch into flat memory model (linear physical address space) protected mode
* Basic VGA (mode 0x03) text mode driver
* Prints out strings, chars, hex numbers
* Port I/O driver
* Data structures - bit array
* Kernel heap
* Cooperative multitasking (thread_cleanup function)
