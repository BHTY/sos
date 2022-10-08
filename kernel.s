	.file	"kernel.c"
	.intel_syntax noprefix
	.text
	.globl	stacks
	.section	.bss
	.align 32
	.type	stacks, @object
	.size	stacks, 16384
stacks:
	.zero	16384
	.globl	stackptr
	.align 4
	.type	stackptr, @object
	.size	stackptr, 4
stackptr:
	.zero	4
	.globl	curTask
	.align 4
	.type	curTask, @object
	.size	curTask, 4
curTask:
	.zero	4
	.globl	mainTask
	.align 4
	.type	mainTask, @object
	.size	mainTask, 8
mainTask:
	.zero	8
	.globl	otherTask
	.align 4
	.type	otherTask, @object
	.size	otherTask, 8
otherTask:
	.zero	8
	.text
	.globl	createTask
	.type	createTask, @function
createTask:
	push	ebp
	mov	ebp, esp
	mov	eax, DWORD PTR stackptr
	add	eax, 502
	sal	eax, 2
	add	eax, OFFSET FLAT:stacks
	mov	edx, eax
	mov	eax, DWORD PTR [ebp+8]
	mov	DWORD PTR [eax], edx
	mov	eax, DWORD PTR [ebp+8]
	mov	DWORD PTR [eax+4], 0
	mov	eax, DWORD PTR [ebp+8]
	mov	eax, DWORD PTR [eax]
	add	eax, 36
	mov	edx, eax
	mov	eax, DWORD PTR [ebp+12]
	mov	DWORD PTR [edx], eax
	mov	eax, DWORD PTR stackptr
	add	eax, 512
	mov	DWORD PTR stackptr, eax
	nop
	pop	ebp
	ret
	.size	createTask, .-createTask
	.section	.rodata
.LC0:
	.string	"abc"
	.text
	.globl	biff
	.type	biff, @function
biff:
	push	ebp
	mov	ebp, esp
	sub	esp, 8
	sub	esp, 12
	push	OFFSET FLAT:.LC0
	call	puts
	add	esp, 16
	call	yield
	nop
	leave
	ret
	.size	biff, .-biff
	.globl	debug
	.type	debug, @function
debug:
	push	ebp
	mov	ebp, esp
	sub	esp, 40
	mov	eax, DWORD PTR curTask
	mov	edx, eax
	sub	esp, 8
	lea	eax, [ebp-28]
	push	eax
	push	edx
	call	hex
	add	esp, 16
	sub	esp, 12
	lea	eax, [ebp-28]
	push	eax
	call	puts
	add	esp, 16
	sub	esp, 12
	push	10
	call	putch
	add	esp, 16
	nop
	leave
	ret
	.size	debug, .-debug
	.globl	TESTFUNC
	.type	TESTFUNC, @function
TESTFUNC:
	push	ebp
	mov	ebp, esp
	sub	esp, 16
	mov	eax, DWORD PTR curTask
	mov	eax, DWORD PTR [eax+4]
	mov	DWORD PTR curTask, eax
	mov	eax, DWORD PTR curTask
	mov	eax, DWORD PTR [eax]
	mov	DWORD PTR [ebp-4], eax
	nop
	leave
	ret
	.size	TESTFUNC, .-TESTFUNC
/APP
	.intel_syntax noprefix
	yield:
	   pushfd
	   push ebp
	   push edi
	   push esi
	   push edx
	   push ecx
	   push ebx
	   push eax
	
	
		mov eax, DWORD PTR curTask
	   mov eax, DWORD PTR [eax+4]
	   mov DWORD PTR curTask, eax
	   mov eax, DWORD PTR curTask
	   mov esx, DWORD PTR [eax]
	
	   pop eax
	   pop ebx
	   pop ecx
	   pop edx
	   pop esi
	   pop edi
	   pop ebp
	   popfd
	   ret
	.att_syntax prefix
	.section	.rodata
	.align 4
.LC1:
	.string	"Hello, world from Protected Mode!"
/NO_APP
	.text
	.globl	main
	.type	main, @function
main:
	lea	ecx, [esp+4]
	and	esp, -16
	push	DWORD PTR [ecx-4]
	push	ebp
	mov	ebp, esp
	push	ecx
	sub	esp, 36
	mov	DWORD PTR curTask, OFFSET FLAT:mainTask
	mov	DWORD PTR mainTask+4, OFFSET FLAT:otherTask
	mov	eax, DWORD PTR curTask
	mov	DWORD PTR otherTask+4, eax
	mov	edx, OFFSET FLAT:mainTask
	sub	esp, 8
	lea	eax, [ebp-28]
	push	eax
	push	edx
	call	hex
	add	esp, 16
	sub	esp, 12
	lea	eax, [ebp-28]
	push	eax
	call	puts
	add	esp, 16
	sub	esp, 12
	push	32
	call	putch
	add	esp, 16
	mov	edx, OFFSET FLAT:otherTask
	sub	esp, 8
	lea	eax, [ebp-28]
	push	eax
	push	edx
	call	hex
	add	esp, 16
	sub	esp, 12
	lea	eax, [ebp-28]
	push	eax
	call	puts
	add	esp, 16
	sub	esp, 12
	push	32
	call	putch
	add	esp, 16
	sub	esp, 8
	push	OFFSET FLAT:biff
	push	OFFSET FLAT:otherTask
	call	createTask
	add	esp, 16
.L6:
	sub	esp, 12
	push	OFFSET FLAT:.LC1
	call	puts
	add	esp, 16
	call	yield
	jmp	.L6
	.size	main, .-main
	.ident	"GCC: (GNU) 10.2.0"
