clear
i386-elf-gcc -ffreestanding -m32 -g -c "kernel.c" -o "kernel.o"
i386-elf-gcc -ffreestanding -m32 -g -c "heap.c" -o "heap.o"
i386-elf-gcc -ffreestanding -m32 -g -c "string.c" -o "string.o"
i386-elf-gcc -ffreestanding -m32 -g -c "terminal.c" -o "terminal.o"
i386-elf-gcc -ffreestanding -m32 -g -c "ports.c" -o "ports.o"
i386-elf-gcc -ffreestanding -m32 -g -c "8042.c" -o "8042.o"
i386-elf-gcc -ffreestanding -m32 -g -c "bitarray.c" -o "bitarray.o"
i386-elf-gcc -ffreestanding -m32 -g -c "task.c" -o "task2.o"
nasm "kernel_entry.asm" -f elf -o "kernel_entry.o"
nasm "task.asm" -f elf -o "task1.o"
i386-elf-ld -o "full_kernel.bin" -Ttext 0x1000 "kernel_entry.o" "task1.o" "task2.o" "heap.o" "kernel.o" "string.o" "terminal.o" "ports.o" "8042.o" "bitarray.o" --oformat binary
nasm "boot.asm" -f bin -o "boot.bin"
cat "boot.bin" "full_kernel.bin" > "everything.bin"
nasm "zeroes.asm" -f bin -o "zeroes.bin"
cat "everything.bin" "zeroes.bin" > "sos.bin"
qemu-system-x86_64 -drive format=raw,file="sos.bin",index=0, -m 128M
