i386-elf-gcc -ffreestanding -m32 -g -c "kernel.c" -o "kernel.o"
nasm "kernel_entry.asm" -f elf -o "kernel_entry.o"
i386-elf-ld -o "full_kernel.bin" -Ttext 0x1000 "kernel_entry.o" "kernel.o" --oformat binary
nasm "boot.asm" -f bin -o "boot.bin"
cat "boot.bin" "full_kernel.bin" > "everything.bin"
nasm "zeroes.asm" -f bin -o "zeroes.bin"
cat "everything.bin" "zeroes.bin" > "sos.bin"
qemu-system-x86_64 -drive format=raw,file="sos.bin",index=0, -m 128M
