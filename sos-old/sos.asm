[org 0x7c00]

mov ax, 0
mov es, ax
mov [diskNum], dl

;mov eax, hello
;push ax
;call puts

push 0x7e00 ;address to store into
push 0x00 ;head number
push 0x0002 ;cylinder/sector number
push 0x01 ;# of sectors

call loadsector

;mov ah, 0x0e
;mov al, [0x7e00]
;int 0x10

cli
lgdt [GDT_Descriptor]
mov eax, cr0
or eax, 1
mov cr0, eax
jmp CODE_SEG:0x7e00

jmp $

CODE_SEG equ code_descriptor - GDT_Start
DATA_SEG equ data_descriptor - GDT_Start

GDT_Descriptor:
    dw GDT_End - GDT_Start - 1 ;size
    dd GDT_Start ;start

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
        dw 0
        db 0x92
        db 0xcf
        db 0
    GDT_End:


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


putch:
    ; char to print is pushed on the stack
    mov BP, SP
    mov al, BYTE [BP+0x02]
    mov ah, 0x0e ;function to print
    int 0x10 ;issue interrupt
    ret

puts:
    ; pointer to string is pushed on the stack
    mov BP, SP
    mov si, WORD [BP+0x02]
    puts_loop: 
        mov al, BYTE [si]
        cmp al, 0x00
        je puts_exit
        push ax
        call putch
        inc si
        jmp puts_loop
    puts_exit:
        ret

diskNum: db 0

times 510-($-$$) db 0
db 0x55, 0xaa