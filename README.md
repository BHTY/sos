# sos
Basic pmode operating system

Tasks (no particular order)
1. Kernel heap (kmalloc/kfree from a flat linear physical pool) & associated data structures - array, linked list, bit array
4. Virtual memory / paging (mapping virtual address space)
5. PS/2 keyboard/mouse driver
6. IDE PIO driver
7. Filesystem driver
8. VESA video driver + virtual terminal
9. Multitasking/multithreading kernel with message passing
10. libc

VESA DDI
- Setting video mode (width, height, bpp, refresh rate)
- Waiting for VBlank (syncing to vertical refresh)
- Allocating off-screen surfaces
- Blitting from one surface to another (with 32<->16bpp color-space conversion)
- Basic draw operations
- - Line draw
- - Circles
- - Basic polygons (filled and otherwise)
- - Text (vector and raster fonts)
