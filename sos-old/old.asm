[org 0x7c00]

;mov eax, hello
;push ax
;call puts

;mov ax, 0xb800
;mov ds, ax
;mov di, 0
;mov al, 0x41
;mov BYTE [di], al

push 0x41
push 0x01
push 0x02
call putc

jmp $

putc:
    ; X, Y, char, pushed onto the stack
    mov BP, SP
    mov cl, BYTE [BP+0x02] ;y
    mov bl, BYTE [BP+0x04] ;x
    mov al, BYTE [BP+0x06] ;char

    imul cx, 0x50
    add cx, bx
    shl cx, 1
    mov di, cx

    mov cx, 0xb800
    mov dx, ds
    mov ds, cx
    mov BYTE [di], al
    mov ds, dx

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


hello: db "Loading the real mode filesystem driver!", 0

times 510-($-$$) db 0
db 0x55, 0xaa