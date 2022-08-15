# sos
Basic pmode operating system

Tasks (no particular order)
1. Port I/O driver & 8042 PS/2 keyboard driver
2. Kernel heap (kmalloc/kfree from a flat linear physical pool) & associated data structures - array, linked list, bit array
3. Virtual memory / paging (mapping virtual address space)
4. PS/2 mouse driver
5. IDE PIO driver
6. Filesystem driver
7. VESA video driver + virtual terminal
8. Multitasking/multithreading kernel with message passing
9. libc

Current Status
* Real-mode "disk driver" (i.e. `loadsector` function that calls int 0x13)
* Switch into flat memory model (linear physical address space) protected mode
* Basic VGA (mode 0x03) text mode driver
* Prints out strings, chars, hex numbers

VESA DDI
- Setting video mode (width, height, bpp, refresh rate)
- Waiting for VBlank (syncing to vertical refresh)
- Allocating off-screen surfaces
- Blitting from one surface to another (with 32<->16bpp color-space conversion) & alpha if desired
- Basic primitive draw operations
- - Line draw
- - Circles
- - Basic polygons (filled and otherwise)
- - Text (vector and raster fonts)
