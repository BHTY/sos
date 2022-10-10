	.file	"task.c"
	.intel_syntax noprefix
	.text
.Ltext0:
	.cfi_sections	.debug_frame
	.globl	curTask
	.section	.bss
	.align 4
	.type	curTask, @object
	.size	curTask, 4
curTask:
	.zero	4
	.text
	.globl	acquire_mutex
	.type	acquire_mutex, @function
acquire_mutex:
.LFB0:
	.file 1 "task.c"
	.loc 1 8 40
	.cfi_startproc
	push	ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	mov	ebp, esp
	.cfi_def_cfa_register 5
	sub	esp, 8
	.loc 1 9 10
	jmp	.L2
.L3:
	.loc 1 10 9
	call	yield
.L2:
	.loc 1 9 11
	mov	eax, DWORD PTR [ebp+8]
	mov	eax, DWORD PTR [eax]
	.loc 1 9 10
	test	eax, eax
	jne	.L3
	.loc 1 12 8
	mov	eax, DWORD PTR curTask
	mov	edx, eax
	mov	eax, DWORD PTR [ebp+8]
	mov	DWORD PTR [eax], edx
	.loc 1 13 1
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	acquire_mutex, .-acquire_mutex
	.globl	release_mutex
	.type	release_mutex, @function
release_mutex:
.LFB1:
	.loc 1 15 31
	.cfi_startproc
	push	ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	mov	ebp, esp
	.cfi_def_cfa_register 5
	.loc 1 16 8
	mov	eax, DWORD PTR [ebp+8]
	mov	eax, DWORD PTR [eax]
	mov	edx, eax
	.loc 1 16 11
	mov	eax, DWORD PTR curTask
	.loc 1 16 7
	cmp	edx, eax
	jne	.L6
	.loc 1 17 12
	mov	eax, DWORD PTR [ebp+8]
	mov	DWORD PTR [eax], 0
.L6:
	.loc 1 19 1
	nop
	pop	ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE1:
	.size	release_mutex, .-release_mutex
	.globl	atomic_set
	.type	atomic_set, @function
atomic_set:
.LFB2:
	.loc 1 21 42
	.cfi_startproc
	push	ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	mov	ebp, esp
	.cfi_def_cfa_register 5
	sub	esp, 8
	.loc 1 22 5
	mov	eax, DWORD PTR [ebp+8]
	add	eax, 8
	sub	esp, 12
	push	eax
	call	acquire_mutex
	add	esp, 16
	.loc 1 24 5
/APP
/  24 "task.c" 1
	.intel_syntax noprefix
/  0 "" 2
	.loc 1 25 9
/  25 "task.c" 1
	mov eax, DWORD PTR [ebp+8]
	
/  0 "" 2
	.loc 1 26 9
/  26 "task.c" 1
	mov esi, DWORD PTR [ebp+12]
	
/  0 "" 2
	.loc 1 27 9
/  27 "task.c" 1
	mov edi, DWORD PTR [eax]
	
/  0 "" 2
	.loc 1 28 9
/  28 "task.c" 1
	mov ecx, DWORD PTR [eax+4]
	
/  0 "" 2
	.loc 1 29 9
/  29 "task.c" 1
	rep movsb
/  0 "" 2
	.loc 1 30 5
/  30 "task.c" 1
	.att_syntax prefix
/  0 "" 2
	.loc 1 32 5
/NO_APP
	mov	eax, DWORD PTR [ebp+8]
	add	eax, 8
	sub	esp, 12
	push	eax
	call	release_mutex
	add	esp, 16
	.loc 1 33 1
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE2:
	.size	atomic_set, .-atomic_set
	.globl	atomic_read
	.type	atomic_read, @function
atomic_read:
.LFB3:
	.loc 1 35 43
	.cfi_startproc
	push	ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	mov	ebp, esp
	.cfi_def_cfa_register 5
	sub	esp, 8
	.loc 1 36 5
	mov	eax, DWORD PTR [ebp+8]
	add	eax, 8
	sub	esp, 12
	push	eax
	call	acquire_mutex
	add	esp, 16
	.loc 1 38 5
/APP
/  38 "task.c" 1
	.intel_syntax noprefix
/  0 "" 2
	.loc 1 39 9
/  39 "task.c" 1
	mov eax, DWORD PTR [ebp+8]
	
/  0 "" 2
	.loc 1 40 9
/  40 "task.c" 1
	mov edi, DWORD PTR [ebp+12]
	
/  0 "" 2
	.loc 1 41 9
/  41 "task.c" 1
	mov esi, DWORD PTR [eax]
	
/  0 "" 2
	.loc 1 42 9
/  42 "task.c" 1
	mov ecx, DWORD PTR [eax+4]
	
/  0 "" 2
	.loc 1 43 9
/  43 "task.c" 1
	rep movsb
/  0 "" 2
	.loc 1 44 5
/  44 "task.c" 1
	.att_syntax prefix
/  0 "" 2
	.loc 1 46 5
/NO_APP
	mov	eax, DWORD PTR [ebp+8]
	add	eax, 8
	sub	esp, 12
	push	eax
	call	release_mutex
	add	esp, 16
	.loc 1 47 1
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE3:
	.size	atomic_read, .-atomic_read
	.section	.rodata
	.align 4
.LC0:
	.string	"%p ESP=%p EIP=%p EAX=%p EBX=%p ECX=%p\n"
	.align 4
.LC1:
	.string	" EDX=%p ESI=%p EDI=%p EFLAGS=%b\n"
	.text
	.globl	printTask
	.type	printTask, @function
printTask:
.LFB4:
	.loc 1 49 26
	.cfi_startproc
	push	ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	mov	ebp, esp
	.cfi_def_cfa_register 5
	push	esi
	push	ebx
	.cfi_offset 6, -12
	.cfi_offset 3, -16
	.loc 1 50 169
	mov	eax, DWORD PTR [ebp+8]
	mov	eax, DWORD PTR [eax]
	.loc 1 50 174
	add	eax, 8
	.loc 1 50 5
	mov	ebx, DWORD PTR [eax]
	.loc 1 50 143
	mov	eax, DWORD PTR [ebp+8]
	mov	eax, DWORD PTR [eax]
	.loc 1 50 148
	add	eax, 4
	.loc 1 50 5
	mov	ecx, DWORD PTR [eax]
	.loc 1 50 119
	mov	eax, DWORD PTR [ebp+8]
	mov	eax, DWORD PTR [eax]
	.loc 1 50 5
	mov	edx, DWORD PTR [eax]
	.loc 1 50 92
	mov	eax, DWORD PTR [ebp+8]
	mov	eax, DWORD PTR [eax]
	.loc 1 50 97
	add	eax, 32
	.loc 1 50 5
	mov	eax, DWORD PTR [eax]
	.loc 1 50 64
	mov	esi, DWORD PTR [ebp+8]
	mov	esi, DWORD PTR [esi]
	.loc 1 50 5
	add	esi, 36
	sub	esp, 4
	push	ebx
	push	ecx
	push	edx
	push	eax
	push	esi
	push	DWORD PTR [ebp+8]
	push	OFFSET FLAT:.LC0
	call	kprintf
	add	esp, 32
	.loc 1 51 147
	mov	eax, DWORD PTR [ebp+8]
	mov	eax, DWORD PTR [eax]
	.loc 1 51 152
	add	eax, 28
	.loc 1 51 5
	mov	ebx, DWORD PTR [eax]
	.loc 1 51 120
	mov	eax, DWORD PTR [ebp+8]
	mov	eax, DWORD PTR [eax]
	.loc 1 51 125
	add	eax, 20
	.loc 1 51 5
	mov	ecx, DWORD PTR [eax]
	.loc 1 51 93
	mov	eax, DWORD PTR [ebp+8]
	mov	eax, DWORD PTR [eax]
	.loc 1 51 98
	add	eax, 16
	.loc 1 51 5
	mov	edx, DWORD PTR [eax]
	.loc 1 51 66
	mov	eax, DWORD PTR [ebp+8]
	mov	eax, DWORD PTR [eax]
	.loc 1 51 71
	add	eax, 12
	.loc 1 51 5
	mov	eax, DWORD PTR [eax]
	sub	esp, 12
	push	ebx
	push	ecx
	push	edx
	push	eax
	push	OFFSET FLAT:.LC1
	call	kprintf
	add	esp, 32
	.loc 1 52 1
	nop
	lea	esp, [ebp-8]
	pop	ebx
	.cfi_restore 3
	pop	esi
	.cfi_restore 6
	pop	ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE4:
	.size	printTask, .-printTask
	.globl	printTasks
	.type	printTasks, @function
printTasks:
.LFB5:
	.loc 1 54 18
	.cfi_startproc
	push	ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	mov	ebp, esp
	.cfi_def_cfa_register 5
	sub	esp, 24
	.loc 1 55 11
	mov	eax, DWORD PTR curTask
	mov	DWORD PTR [ebp-12], eax
.L11:
	.loc 1 58 9 discriminator 1
	sub	esp, 12
	push	DWORD PTR [ebp-12]
	call	printTask
	add	esp, 16
	.loc 1 59 13 discriminator 1
	mov	eax, DWORD PTR [ebp-12]
	mov	eax, DWORD PTR [eax+4]
	mov	DWORD PTR [ebp-12], eax
	.loc 1 60 16 discriminator 1
	mov	eax, DWORD PTR curTask
	.loc 1 60 5 discriminator 1
	cmp	DWORD PTR [ebp-12], eax
	jne	.L11
	.loc 1 61 1
	nop
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE5:
	.size	printTasks, .-printTasks
	.globl	thread_cleanup
	.type	thread_cleanup, @function
thread_cleanup:
.LFB6:
	.loc 1 63 22
	.cfi_startproc
	push	ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	mov	ebp, esp
	.cfi_def_cfa_register 5
	sub	esp, 24
	.loc 1 64 11
	mov	eax, DWORD PTR curTask
	mov	DWORD PTR [ebp-12], eax
	.loc 1 66 34
	mov	edx, DWORD PTR curTask
	.loc 1 66 12
	mov	eax, DWORD PTR curTask
	mov	eax, DWORD PTR [eax+8]
	.loc 1 66 34
	mov	edx, DWORD PTR [edx+4]
	.loc 1 66 25
	mov	DWORD PTR [eax+4], edx
	.loc 1 67 34
	mov	edx, DWORD PTR curTask
	.loc 1 67 12
	mov	eax, DWORD PTR curTask
	mov	eax, DWORD PTR [eax+4]
	.loc 1 67 34
	mov	edx, DWORD PTR [edx+8]
	.loc 1 67 25
	mov	DWORD PTR [eax+8], edx
	.loc 1 69 18
	mov	eax, DWORD PTR curTask
	mov	eax, DWORD PTR [eax]
	.loc 1 69 5
	sub	esp, 12
	push	eax
	call	kfree
	add	esp, 16
	.loc 1 70 22
	mov	eax, DWORD PTR curTask
	mov	eax, DWORD PTR [eax+4]
	.loc 1 70 13
	mov	DWORD PTR curTask, eax
	.loc 1 71 5
	sub	esp, 12
	push	DWORD PTR [ebp-12]
	call	kfree
	add	esp, 16
	.loc 1 74 5
	call	resume
	.loc 1 75 1
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE6:
	.size	thread_cleanup, .-thread_cleanup
	.globl	createTask
	.type	createTask, @function
createTask:
.LFB7:
	.loc 1 77 53
	.cfi_startproc
	push	ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	mov	ebp, esp
	.cfi_def_cfa_register 5
	sub	esp, 24
	.loc 1 78 22
	sub	esp, 12
	push	4096
	call	kmalloc
	add	esp, 16
	.loc 1 78 14
	mov	DWORD PTR [ebp-12], eax
	.loc 1 80 35
	mov	eax, DWORD PTR [ebp-12]
	lea	edx, [eax+4052]
	.loc 1 80 14
	mov	eax, DWORD PTR [ebp+8]
	mov	DWORD PTR [eax], edx
	.loc 1 82 44
	mov	eax, DWORD PTR [ebp-12]
	add	eax, 4092
	.loc 1 82 6
	mov	edx, eax
	.loc 1 82 76
	mov	eax, DWORD PTR [ebp+16]
	.loc 1 82 74
	mov	DWORD PTR [edx], eax
	.loc 1 83 44
	mov	eax, DWORD PTR [ebp-12]
	add	eax, 4084
	.loc 1 83 6
	mov	edx, eax
	.loc 1 83 76
	mov	eax, DWORD PTR [ebp+12]
	.loc 1 83 74
	mov	DWORD PTR [edx], eax
	.loc 1 84 44
	mov	eax, DWORD PTR [ebp-12]
	add	eax, 4088
	.loc 1 84 76
	mov	edx, OFFSET FLAT:thread_cleanup
	.loc 1 84 74
	mov	DWORD PTR [eax], edx
	.loc 1 85 1
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE7:
	.size	createTask, .-createTask
	.globl	init_tasking
	.type	init_tasking, @function
init_tasking:
.LFB8:
	.loc 1 87 20
	.cfi_startproc
	push	ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	mov	ebp, esp
	.cfi_def_cfa_register 5
	sub	esp, 8
	.loc 1 88 15
	sub	esp, 12
	push	12
	call	kmalloc
	add	esp, 16
	.loc 1 88 13
	mov	DWORD PTR curTask, eax
	.loc 1 89 12
	mov	eax, DWORD PTR curTask
	.loc 1 89 19
	mov	edx, DWORD PTR curTask
	mov	DWORD PTR [eax+4], edx
	.loc 1 90 12
	mov	eax, DWORD PTR curTask
	.loc 1 90 19
	mov	edx, DWORD PTR curTask
	mov	DWORD PTR [eax+8], edx
	.loc 1 91 1
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE8:
	.size	init_tasking, .-init_tasking
	.globl	spawnThread
	.type	spawnThread, @function
spawnThread:
.LFB9:
	.loc 1 93 43
	.cfi_startproc
	push	ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	mov	ebp, esp
	.cfi_def_cfa_register 5
	push	ebx
	sub	esp, 20
	.cfi_offset 3, -12
	.loc 1 94 25
	mov	eax, DWORD PTR curTask
	.loc 1 94 11
	mov	eax, DWORD PTR [eax+4]
	mov	DWORD PTR [ebp-12], eax
	.loc 1 95 12
	mov	ebx, DWORD PTR curTask
	.loc 1 95 21
	sub	esp, 12
	push	12
	call	kmalloc
	add	esp, 16
	.loc 1 95 19
	mov	DWORD PTR [ebx+4], eax
	.loc 1 96 12
	mov	eax, DWORD PTR curTask
	mov	eax, DWORD PTR [eax+4]
	.loc 1 96 25
	mov	edx, DWORD PTR curTask
	mov	DWORD PTR [eax+8], edx
	.loc 1 97 12
	mov	eax, DWORD PTR curTask
	mov	eax, DWORD PTR [eax+4]
	.loc 1 97 25
	mov	edx, DWORD PTR [ebp-12]
	mov	DWORD PTR [eax+4], edx
	.loc 1 98 23
	mov	eax, DWORD PTR curTask
	mov	eax, DWORD PTR [eax+4]
	.loc 1 98 5
	sub	esp, 4
	push	DWORD PTR [ebp+12]
	push	DWORD PTR [ebp+8]
	push	eax
	call	createTask
	add	esp, 16
	.loc 1 99 1
	nop
	mov	ebx, DWORD PTR [ebp-4]
	leave
	.cfi_restore 5
	.cfi_restore 3
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE9:
	.size	spawnThread, .-spawnThread
.Letext0:
	.file 2 "task.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.long	0x2b6
	.value	0x4
	.long	.Ldebug_abbrev0
	.byte	0x4
	.uleb128 0x1
	.long	.LASF20
	.byte	0xc
	.long	.LASF21
	.long	.LASF22
	.long	.Ltext0
	.long	.Letext0-.Ltext0
	.long	.Ldebug_line0
	.uleb128 0x2
	.long	.LASF2
	.byte	0x2
	.byte	0x7
	.byte	0x1b
	.long	0x38
	.uleb128 0x3
	.byte	0x4
	.byte	0x7
	.long	.LASF23
	.uleb128 0x4
	.long	0x31
	.uleb128 0x5
	.long	.LASF3
	.byte	0xc
	.byte	0x2
	.byte	0x9
	.byte	0x10
	.long	0x72
	.uleb128 0x6
	.string	"esp"
	.byte	0x2
	.byte	0xa
	.byte	0xe
	.long	0x31
	.byte	0
	.uleb128 0x7
	.long	.LASF0
	.byte	0x2
	.byte	0xb
	.byte	0x12
	.long	0x72
	.byte	0x4
	.uleb128 0x7
	.long	.LASF1
	.byte	0x2
	.byte	0xc
	.byte	0x12
	.long	0x72
	.byte	0x8
	.byte	0
	.uleb128 0x8
	.byte	0x4
	.long	0x3d
	.uleb128 0x2
	.long	.LASF3
	.byte	0x2
	.byte	0xd
	.byte	0x3
	.long	0x3d
	.uleb128 0x9
	.byte	0xc
	.byte	0x2
	.byte	0xf
	.byte	0x9
	.long	0xb5
	.uleb128 0x7
	.long	.LASF4
	.byte	0x2
	.byte	0x10
	.byte	0xb
	.long	0xb5
	.byte	0
	.uleb128 0x7
	.long	.LASF5
	.byte	0x2
	.byte	0x11
	.byte	0xc
	.long	0x31
	.byte	0x4
	.uleb128 0x7
	.long	.LASF6
	.byte	0x2
	.byte	0x12
	.byte	0xd
	.long	0x25
	.byte	0x8
	.byte	0
	.uleb128 0xa
	.byte	0x4
	.uleb128 0x2
	.long	.LASF7
	.byte	0x2
	.byte	0x13
	.byte	0x3
	.long	0x84
	.uleb128 0xb
	.long	.LASF24
	.byte	0x1
	.byte	0x6
	.byte	0x7
	.long	0xd5
	.uleb128 0x5
	.byte	0x3
	.long	curTask
	.uleb128 0x8
	.byte	0x4
	.long	0x78
	.uleb128 0xc
	.long	.LASF8
	.byte	0x1
	.byte	0x5d
	.byte	0x6
	.long	.LFB9
	.long	.LFE9-.LFB9
	.uleb128 0x1
	.byte	0x9c
	.long	0x11f
	.uleb128 0xd
	.string	"fun"
	.byte	0x1
	.byte	0x5d
	.byte	0x19
	.long	0x126
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0xd
	.string	"arg"
	.byte	0x1
	.byte	0x5d
	.byte	0x27
	.long	0xb5
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0xe
	.long	.LASF10
	.byte	0x1
	.byte	0x5e
	.byte	0xb
	.long	0xd5
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.byte	0
	.uleb128 0xf
	.long	0x126
	.uleb128 0x10
	.byte	0
	.uleb128 0x8
	.byte	0x4
	.long	0x11f
	.uleb128 0x11
	.long	.LASF25
	.byte	0x1
	.byte	0x57
	.byte	0x6
	.long	.LFB8
	.long	.LFE8-.LFB8
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0xc
	.long	.LASF9
	.byte	0x1
	.byte	0x4d
	.byte	0x6
	.long	.LFB7
	.long	.LFE7-.LFB7
	.uleb128 0x1
	.byte	0x9c
	.long	0x191
	.uleb128 0xd
	.string	"ptr"
	.byte	0x1
	.byte	0x4d
	.byte	0x17
	.long	0xd5
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0xd
	.string	"fun"
	.byte	0x1
	.byte	0x4d
	.byte	0x23
	.long	0x126
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0xd
	.string	"arg"
	.byte	0x1
	.byte	0x4d
	.byte	0x31
	.long	0xb5
	.uleb128 0x2
	.byte	0x91
	.sleb128 8
	.uleb128 0xe
	.long	.LASF11
	.byte	0x1
	.byte	0x4e
	.byte	0xe
	.long	0x31
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.byte	0
	.uleb128 0x12
	.long	.LASF12
	.byte	0x1
	.byte	0x3f
	.byte	0x6
	.long	.LFB6
	.long	.LFE6-.LFB6
	.uleb128 0x1
	.byte	0x9c
	.long	0x1b7
	.uleb128 0x13
	.string	"tmp"
	.byte	0x1
	.byte	0x40
	.byte	0xb
	.long	0xd5
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.byte	0
	.uleb128 0x12
	.long	.LASF13
	.byte	0x1
	.byte	0x36
	.byte	0x6
	.long	.LFB5
	.long	.LFE5-.LFB5
	.uleb128 0x1
	.byte	0x9c
	.long	0x1dd
	.uleb128 0x13
	.string	"ptr"
	.byte	0x1
	.byte	0x37
	.byte	0xb
	.long	0xd5
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.byte	0
	.uleb128 0xc
	.long	.LASF14
	.byte	0x1
	.byte	0x31
	.byte	0x6
	.long	.LFB4
	.long	.LFE4-.LFB4
	.uleb128 0x1
	.byte	0x9c
	.long	0x203
	.uleb128 0xd
	.string	"ptr"
	.byte	0x1
	.byte	0x31
	.byte	0x16
	.long	0xd5
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.byte	0
	.uleb128 0xc
	.long	.LASF15
	.byte	0x1
	.byte	0x23
	.byte	0x6
	.long	.LFB3
	.long	.LFE3-.LFB3
	.uleb128 0x1
	.byte	0x9c
	.long	0x236
	.uleb128 0xd
	.string	"p"
	.byte	0x1
	.byte	0x23
	.byte	0x1c
	.long	0x236
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x14
	.long	.LASF16
	.byte	0x1
	.byte	0x23
	.byte	0x25
	.long	0xb5
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.byte	0
	.uleb128 0x8
	.byte	0x4
	.long	0xb7
	.uleb128 0xc
	.long	.LASF17
	.byte	0x1
	.byte	0x15
	.byte	0x6
	.long	.LFB2
	.long	.LFE2-.LFB2
	.uleb128 0x1
	.byte	0x9c
	.long	0x26f
	.uleb128 0xd
	.string	"p"
	.byte	0x1
	.byte	0x15
	.byte	0x1b
	.long	0x236
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x14
	.long	.LASF16
	.byte	0x1
	.byte	0x15
	.byte	0x24
	.long	0xb5
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.byte	0
	.uleb128 0x15
	.long	.LASF18
	.byte	0x1
	.byte	0xf
	.byte	0x6
	.long	.LFB1
	.long	.LFE1-.LFB1
	.uleb128 0x1
	.byte	0x9c
	.long	0x293
	.uleb128 0xd
	.string	"p"
	.byte	0x1
	.byte	0xf
	.byte	0x1d
	.long	0x293
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.byte	0
	.uleb128 0x8
	.byte	0x4
	.long	0x25
	.uleb128 0x16
	.long	.LASF19
	.byte	0x1
	.byte	0x8
	.byte	0x6
	.long	.LFB0
	.long	.LFE0-.LFB0
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0xd
	.string	"p"
	.byte	0x1
	.byte	0x8
	.byte	0x26
	.long	0x293
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.byte	0
	.byte	0
	.section	.debug_abbrev,"",@progbits
.Ldebug_abbrev0:
	.uleb128 0x1
	.uleb128 0x11
	.byte	0x1
	.uleb128 0x25
	.uleb128 0xe
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x1b
	.uleb128 0xe
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x10
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x2
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x3
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0x35
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x5
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x9
	.uleb128 0x13
	.byte	0x1
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xb
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0xc
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2116
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xd
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0xe
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0xf
	.uleb128 0x15
	.byte	0x1
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x10
	.uleb128 0x18
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x11
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2116
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x12
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2116
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x13
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x14
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x15
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2117
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x16
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2116
	.uleb128 0x19
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_aranges,"",@progbits
	.long	0x1c
	.value	0x2
	.long	.Ldebug_info0
	.byte	0x4
	.byte	0
	.value	0
	.value	0
	.long	.Ltext0
	.long	.Letext0-.Ltext0
	.long	0
	.long	0
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF7:
	.string	"atomic_t"
.LASF23:
	.string	"unsigned int"
.LASF17:
	.string	"atomic_set"
.LASF9:
	.string	"createTask"
.LASF10:
	.string	"temp"
.LASF11:
	.string	"stack"
.LASF21:
	.string	"task.c"
.LASF3:
	.string	"task"
.LASF19:
	.string	"acquire_mutex"
.LASF22:
	.string	"/home/will/sos"
.LASF18:
	.string	"release_mutex"
.LASF4:
	.string	"data"
.LASF8:
	.string	"spawnThread"
.LASF6:
	.string	"lock"
.LASF13:
	.string	"printTasks"
.LASF12:
	.string	"thread_cleanup"
.LASF2:
	.string	"mutex_t"
.LASF5:
	.string	"size"
.LASF15:
	.string	"atomic_read"
.LASF16:
	.string	"value"
.LASF14:
	.string	"printTask"
.LASF1:
	.string	"prev"
.LASF24:
	.string	"curTask"
.LASF20:
	.string	"GNU C17 10.2.0 -m32 -masm=intel -mtune=i386 -march=i386 -g -ffreestanding"
.LASF0:
	.string	"next"
.LASF25:
	.string	"init_tasking"
	.ident	"GCC: (GNU) 10.2.0"
