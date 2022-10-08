nasm -f bin sos.asm -o sos.bin
nasm -f bin pmode.asm -o pmode.bin
cat sos.bin pmode.bin > main.bin
qemu-system-x86_64 main.bin
