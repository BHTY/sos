[org 0x7e00]
[bits 32]
mov al, 'A'
mov ah, 0xf0
mov [0xb8000], ax

jmp $

times 512-($-$$) db "A"