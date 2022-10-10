[bits 32]

extern curTask
global yield
global resume

yield:
    ;store current processor state
    pushfd
    push ebp
    push edi
    push esi
    push edx
    push ecx
    push ebx
    push eax

    ;curTask->esp = esp
    mov eax, DWORD [curTask]
    mov DWORD [eax], esp

    ;curTask = curTask->next
    mov eax, DWORD [curTask]
    mov eax, DWORD [eax+4]
    mov DWORD [curTask], eax

    ;esp = curTask->esp
    resume: 
        mov eax, DWORD [curTask]
        mov esp, DWORD [eax]

        ;restore and return
        pop eax
        pop ebx
        pop ecx
        pop edx
        pop esi
        pop edi
        pop ebp
        popfd
        ret