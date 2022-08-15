# sos
Basic pmode operating system

Tasks (no particular order)
- IDE PIO driver
- Filesystem driver
- PS/2 keyboard/mouse driver
- VESA video driver
- Kernel heap (malloc/free from a flat linear physical pool)
- Virtual memory / paging (mapping virtual address space)

VESA DDI
- Setting video mode (width, height, bpp, refresh rate)
- Allocating off-screen surfaces
- Blitting from one surface to another (with 32<->16bpp color-space conversion)
- Basic draw operations
-   Line draw
-   Circles
-   Basic polygons (filled and otherwise)
-   Text (vector and raster fonts)
