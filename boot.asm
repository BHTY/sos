[org 0x7c00]
KERNEL_LOCATION equ 0x1000

mov ax, 0
mov es, ax
mov [diskNum], dl

push KERNEL_LOCATION ;address to store into
push 0x00 ;head number
push 0x0002 ;cylinder/sector number
push 0x20 ;# of sectors

call loadsector

cli
lgdt [GDT_Descriptor]
mov eax, cr0
or eax, 1
mov cr0, eax

jmp CODE_SEG:start_protected_mode

jmp $

CODE_SEG equ code_descriptor - GDT_Start
DATA_SEG equ data_descriptor - GDT_Start

GDT_Start:
    null_descriptor:
        dd 0
        dd 0
    code_descriptor:
        dw 0xffff
        dw 0
        db 0
        db 0x9a
        db 0xcf
        db 0
    data_descriptor:
        dw 0xffff
        dw 0
        db 0
        db 0x92
        db 0xcf
        db 0
    GDT_End:

GDT_Descriptor:
    dw GDT_End - GDT_Start - 1 ;size
    dd GDT_Start ;start

loadsector:
    mov BP, SP
    mov al, BYTE [BP+0x02] ;# of sectors to read
    mov cx, WORD [BP+0x04] ;cylinder # stored in ch, sector number stored in cl
    mov dh, BYTE [BP+0x06] ;head number
    mov bx, WORD [BP+0x08] ;address to store into

    mov ah, 2
    mov dl, [diskNum]
    int 0x13
    ret

[bits 32]
start_protected_mode:
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000
    mov esp, ebp
    jmp CODE_SEG:KERNEL_LOCATION


diskNum: db 0

times 510-($-$$) db 0
db 0x55, 0xaa