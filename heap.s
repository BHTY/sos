	.file	"heap.c"
	.intel_syntax noprefix
	.text
	.globl	HEAPSIZE
	.section	.bss
	.align 4
	.type	HEAPSIZE, @object
	.size	HEAPSIZE, 4
HEAPSIZE:
	.zero	4
	.globl	heapStart
	.align 4
	.type	heapStart, @object
	.size	heapStart, 4
heapStart:
	.zero	4
	.text
	.globl	printhex
	.type	printhex, @function
printhex:
	push	ebp
	mov	ebp, esp
	sub	esp, 24
	sub	esp, 8
	lea	eax, [ebp-18]
	push	eax
	push	DWORD PTR [ebp+8]
	call	hex
	add	esp, 16
	sub	esp, 12
	lea	eax, [ebp-18]
	push	eax
	call	puts
	add	esp, 16
	nop
	leave
	ret
	.size	printhex, .-printhex
	.globl	init_heap
	.type	init_heap, @function
init_heap:
	push	ebp
	mov	ebp, esp
	sub	esp, 24
	mov	eax, DWORD PTR [ebp+12]
	mov	DWORD PTR HEAPSIZE, eax
	mov	eax, DWORD PTR [ebp+8]
	mov	DWORD PTR heapStart, eax
	mov	DWORD PTR [ebp-24], 0
	mov	eax, DWORD PTR HEAPSIZE
	sub	eax, 16
	mov	DWORD PTR [ebp-20], eax
	mov	DWORD PTR [ebp-16], 0
	mov	DWORD PTR [ebp-12], 0
	mov	eax, DWORD PTR heapStart
	sub	esp, 4
	push	16
	lea	edx, [ebp-24]
	push	edx
	push	eax
	call	kmemcpy
	add	esp, 16
	nop
	leave
	ret
	.size	init_heap, .-init_heap
	.globl	kmalloc
	.type	kmalloc, @function
kmalloc:
	push	ebp
	mov	ebp, esp
	sub	esp, 16
	mov	eax, DWORD PTR heapStart
	mov	DWORD PTR [ebp-4], eax
	mov	eax, DWORD PTR [ebp+8]
	and	eax, 3
	test	eax, eax
	je	.L4
	mov	eax, DWORD PTR [ebp+8]
	and	eax, -4
	add	eax, 4
	jmp	.L5
.L4:
	mov	eax, DWORD PTR [ebp+8]
.L5:
	mov	DWORD PTR [ebp+8], eax
.L13:
	mov	eax, DWORD PTR [ebp-4]
	mov	eax, DWORD PTR [eax]
	test	eax, eax
	jne	.L6
	mov	eax, DWORD PTR [ebp-4]
	mov	eax, DWORD PTR [eax+4]
	mov	edx, DWORD PTR [ebp+8]
	add	edx, 16
	cmp	eax, edx
	jb	.L6
	mov	eax, DWORD PTR [ebp-4]
	mov	eax, DWORD PTR [eax+4]
	mov	DWORD PTR [ebp-8], eax
	mov	eax, DWORD PTR [ebp-4]
	mov	eax, DWORD PTR [eax+12]
	mov	DWORD PTR [ebp-12], eax
	mov	eax, DWORD PTR [ebp-4]
	mov	DWORD PTR [eax], 1
	mov	eax, DWORD PTR [ebp-4]
	mov	edx, DWORD PTR [ebp+8]
	mov	DWORD PTR [eax+4], edx
	mov	edx, DWORD PTR [ebp-4]
	mov	eax, DWORD PTR [ebp+8]
	add	eax, edx
	add	eax, 16
	mov	edx, eax
	mov	eax, DWORD PTR [ebp-4]
	mov	DWORD PTR [eax+12], edx
	mov	eax, DWORD PTR [ebp-4]
	mov	eax, DWORD PTR [eax+12]
	mov	DWORD PTR [ebp-16], eax
	mov	eax, DWORD PTR [ebp-16]
	mov	DWORD PTR [eax], 0
	mov	eax, DWORD PTR [ebp-16]
	mov	edx, DWORD PTR [ebp-4]
	mov	DWORD PTR [eax+8], edx
	cmp	DWORD PTR [ebp-12], 0
	je	.L7
	mov	eax, DWORD PTR [ebp-12]
	mov	eax, DWORD PTR [eax]
	test	eax, eax
	je	.L8
.L7:
	mov	eax, DWORD PTR [ebp-16]
	mov	edx, DWORD PTR [ebp-12]
	mov	DWORD PTR [eax+12], edx
	mov	eax, DWORD PTR [ebp-8]
	sub	eax, DWORD PTR [ebp+8]
	lea	edx, [eax-16]
	mov	eax, DWORD PTR [ebp-16]
	mov	DWORD PTR [eax+4], edx
	jmp	.L10
.L8:
	mov	eax, DWORD PTR [ebp-12]
	mov	edx, DWORD PTR [eax+12]
	mov	eax, DWORD PTR [ebp-16]
	mov	DWORD PTR [eax+12], edx
	mov	eax, DWORD PTR [ebp-8]
	sub	eax, DWORD PTR [ebp+8]
	mov	edx, eax
	mov	eax, DWORD PTR [ebp-12]
	mov	eax, DWORD PTR [eax+4]
	add	edx, eax
	mov	eax, DWORD PTR [ebp-16]
	mov	DWORD PTR [eax+4], edx
	jmp	.L10
.L6:
	mov	eax, DWORD PTR [ebp-4]
	mov	eax, DWORD PTR [eax+12]
	mov	DWORD PTR [ebp-4], eax
	cmp	DWORD PTR [ebp-4], 0
	jne	.L13
	mov	eax, 0
	jmp	.L12
.L10:
	mov	eax, DWORD PTR [ebp-4]
	add	eax, 16
.L12:
	leave
	ret
	.size	kmalloc, .-kmalloc
	.section	.rodata
.LC0:
	.string	"\n\n"
	.text
	.globl	kfree
	.type	kfree, @function
kfree:
	push	ebp
	mov	ebp, esp
	sub	esp, 24
	mov	eax, DWORD PTR [ebp+8]
	sub	eax, 16
	mov	DWORD PTR [ebp-12], eax
	mov	eax, DWORD PTR [ebp-12]
	mov	eax, DWORD PTR [eax+8]
	test	eax, eax
	je	.L15
	mov	eax, DWORD PTR [ebp-12]
	mov	eax, DWORD PTR [eax+8]
	mov	eax, DWORD PTR [eax]
	test	eax, eax
	jne	.L15
	mov	eax, DWORD PTR [ebp-12]
	mov	eax, DWORD PTR [eax+8]
	mov	edx, DWORD PTR [ebp-12]
	mov	edx, DWORD PTR [edx+12]
	mov	DWORD PTR [eax+12], edx
	mov	eax, DWORD PTR [ebp-12]
	mov	eax, DWORD PTR [eax+8]
	mov	edx, DWORD PTR [eax+4]
	mov	eax, DWORD PTR [ebp-12]
	mov	eax, DWORD PTR [eax+4]
	add	edx, eax
	mov	eax, DWORD PTR [ebp-12]
	mov	eax, DWORD PTR [eax+8]
	add	edx, 16
	mov	DWORD PTR [eax+4], edx
	mov	eax, DWORD PTR [ebp-12]
	mov	eax, DWORD PTR [eax+8]
	mov	DWORD PTR [ebp-12], eax
.L15:
	mov	eax, DWORD PTR [ebp-12]
	mov	eax, DWORD PTR [eax+12]
	test	eax, eax
	je	.L16
	mov	eax, DWORD PTR [ebp-12]
	mov	eax, DWORD PTR [eax+12]
	mov	eax, DWORD PTR [eax]
	test	eax, eax
	jne	.L16
	mov	eax, DWORD PTR [ebp-12]
	mov	edx, DWORD PTR [eax+4]
	mov	eax, DWORD PTR [ebp-12]
	mov	eax, DWORD PTR [eax+12]
	mov	eax, DWORD PTR [eax+4]
	add	eax, edx
	lea	edx, [eax+16]
	mov	eax, DWORD PTR [ebp-12]
	mov	DWORD PTR [eax+4], edx
	mov	eax, DWORD PTR [ebp-12]
	mov	eax, DWORD PTR [eax+12]
	mov	edx, DWORD PTR [eax+12]
	mov	eax, DWORD PTR [ebp-12]
	mov	DWORD PTR [eax+12], edx
.L16:
	mov	eax, DWORD PTR [ebp-12]
	mov	DWORD PTR [eax], 0
	sub	esp, 12
	push	OFFSET FLAT:.LC0
	call	puts
	add	esp, 16
	mov	eax, DWORD PTR [ebp+8]
	sub	esp, 12
	push	eax
	call	printhex
	add	esp, 16
.L17:
	jmp	.L17
	.size	kfree, .-kfree
	.ident	"GCC: (GNU) 10.2.0"
