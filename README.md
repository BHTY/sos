# sos
Basic pmode operating system

Tasks (no particular order)
1. Rewrite some stuff
2. A20 line
3. Timer interrupt (make IDT, reprogram PIT to higher frequency) -> multithreading/multitasking! (+ message passing)
4. PS/2 keyboard driver
5. Hide a thread cleanup function at the back of thread stacks
6. ATA/IDE PIO driver

Others: VESA, libc

Current Status
* Real-mode "disk driver" (i.e. `loadsector` function that calls int 0x13)
* Switch into flat memory model (linear physical address space) protected mode
* Basic VGA (mode 0x03) text mode driver
* Prints out strings, chars, hex numbers
* Port I/O driver
* Data structures - bit array
* Cooperative multitasking
