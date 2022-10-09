	.file	"kernel.c"
	.intel_syntax noprefix
	.text
	.globl	HEAP
	.section	.bss
	.align 32
	.type	HEAP, @object
	.size	HEAP, 65536
HEAP:
	.zero	65536
	.globl	curTask
	.align 4
	.type	curTask, @object
	.size	curTask, 4
curTask:
	.zero	4
	.globl	mainTask
	.align 4
	.type	mainTask, @object
	.size	mainTask, 12
mainTask:
	.zero	12
	.globl	otherTask
	.align 4
	.type	otherTask, @object
	.size	otherTask, 12
otherTask:
	.zero	12
	.globl	thirdTask
	.align 4
	.type	thirdTask, @object
	.size	thirdTask, 12
thirdTask:
	.zero	12
	.section	.rodata
.LC0:
	.string	"passing to kfree: "
	.text
	.globl	thread_cleanup
	.type	thread_cleanup, @function
thread_cleanup:
	push	ebp
	mov	ebp, esp
	sub	esp, 24
	mov	eax, DWORD PTR curTask
	mov	DWORD PTR [ebp-12], eax
	mov	edx, DWORD PTR curTask
	mov	eax, DWORD PTR curTask
	mov	eax, DWORD PTR [eax+8]
	mov	edx, DWORD PTR [edx+4]
	mov	DWORD PTR [eax+4], edx
	sub	esp, 12
	push	OFFSET FLAT:.LC0
	call	puts
	add	esp, 16
	mov	eax, DWORD PTR curTask
	mov	eax, DWORD PTR [eax]
	sub	esp, 12
	push	eax
	call	printhex
	add	esp, 16
	mov	eax, DWORD PTR curTask
	mov	eax, DWORD PTR [eax]
	sub	esp, 12
	push	eax
	call	kfree
	add	esp, 16
	mov	eax, DWORD PTR curTask
	mov	eax, DWORD PTR [eax+4]
	mov	DWORD PTR curTask, eax
	sub	esp, 12
	push	DWORD PTR [ebp-12]
	call	kfree
	add	esp, 16
	call	resume
	nop
	leave
	ret
	.size	thread_cleanup, .-thread_cleanup
	.globl	createTask
	.type	createTask, @function
createTask:
	push	ebp
	mov	ebp, esp
	sub	esp, 40
	sub	esp, 12
	push	4096
	call	kmalloc
	add	esp, 16
	mov	DWORD PTR [ebp-12], eax
	mov	eax, DWORD PTR [ebp-12]
	lea	edx, [eax+4056]
	mov	eax, DWORD PTR [ebp+8]
	mov	DWORD PTR [eax], edx
	mov	eax, DWORD PTR [ebp+8]
	mov	DWORD PTR [eax+4], 0
	mov	eax, DWORD PTR [ebp-12]
	add	eax, 4088
	mov	edx, eax
	mov	eax, DWORD PTR [ebp+12]
	mov	DWORD PTR [edx], eax
	mov	eax, DWORD PTR [ebp-12]
	add	eax, 4092
	mov	edx, OFFSET FLAT:thread_cleanup
	mov	DWORD PTR [eax], edx
	nop
	leave
	ret
	.size	createTask, .-createTask
	.globl	biff
	.type	biff, @function
biff:
	push	ebp
	mov	ebp, esp
	sub	esp, 16
	mov	DWORD PTR [ebp-4], 0
	nop
	leave
	ret
	.size	biff, .-biff
	.section	.rodata
.LC1:
	.string	"THREAD 3: "
.LC2:
	.string	"Returned from yield!\n"
	.text
	.globl	otherbiff
	.type	otherbiff, @function
otherbiff:
	push	ebp
	mov	ebp, esp
	sub	esp, 8
.L6:
	sub	esp, 12
	push	2
	call	setcolor
	add	esp, 16
	sub	esp, 12
	push	OFFSET FLAT:.LC1
	call	puts
	add	esp, 16
	call	yield
	sub	esp, 12
	push	3
	call	setcolor
	add	esp, 16
	sub	esp, 12
	push	OFFSET FLAT:.LC2
	call	puts
	add	esp, 16
	jmp	.L6
	.size	otherbiff, .-otherbiff
	.globl	debug
	.type	debug, @function
debug:
	push	ebp
	mov	ebp, esp
	sub	esp, 40
	mov	eax, DWORD PTR curTask
	mov	eax, DWORD PTR [eax]
	sub	esp, 8
	lea	edx, [ebp-28]
	push	edx
	push	eax
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
	   mov DWORD PTR [eax], esp
	
	
		mov eax, DWORD PTR curTask
	   mov eax, DWORD PTR [eax+4]
	   mov DWORD PTR curTask, eax
	   resume:
	   mov eax, DWORD PTR curTask
	   mov esp, DWORD PTR [eax]
	
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
/NO_APP
	.globl	globalesp
	.section	.bss
	.align 4
	.type	globalesp, @object
	.size	globalesp, 4
globalesp:
	.zero	4
	.section	.rodata
.LC3:
	.string	"THREAD 1: "
.LC4:
	.string	"YIELDING\n"
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
	sub	esp, 4
	sub	esp, 8
	push	65536
	push	OFFSET FLAT:HEAP
	call	init_heap
	add	esp, 16
	mov	DWORD PTR curTask, OFFSET FLAT:mainTask
	mov	DWORD PTR mainTask+4, OFFSET FLAT:otherTask
	sub	esp, 8
	push	OFFSET FLAT:biff
	push	OFFSET FLAT:otherTask
	call	createTask
	add	esp, 16
	sub	esp, 8
	push	OFFSET FLAT:otherbiff
	push	OFFSET FLAT:thirdTask
	call	createTask
	add	esp, 16
	mov	DWORD PTR otherTask+4, OFFSET FLAT:thirdTask
	mov	eax, DWORD PTR curTask
	mov	DWORD PTR thirdTask+4, eax
	mov	DWORD PTR mainTask+8, OFFSET FLAT:thirdTask
	mov	DWORD PTR otherTask+8, OFFSET FLAT:mainTask
	mov	DWORD PTR thirdTask+8, OFFSET FLAT:otherTask
.L9:
	sub	esp, 12
	push	2
	call	setcolor
	add	esp, 16
	sub	esp, 12
	push	OFFSET FLAT:.LC3
	call	puts
	add	esp, 16
	sub	esp, 12
	push	4
	call	setcolor
	add	esp, 16
	sub	esp, 12
	push	OFFSET FLAT:.LC4
	call	puts
	add	esp, 16
	call	yield
	jmp	.L9
	.size	main, .-main
	.ident	"GCC: (GNU) 10.2.0"
