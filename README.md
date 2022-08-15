# sos
Basic pmode operating system

Tasks (no particular order)
1. Kernel heap (kmalloc/kfree from a flat linear physical pool)
2. Virtual memory / paging (mapping virtual address space)
3. PS/2 keyboard/mouse driver
4. IDE PIO driver
5. Filesystem driver
6. VESA video driver
7. Multitasking/multithreading kernel with message passing

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
