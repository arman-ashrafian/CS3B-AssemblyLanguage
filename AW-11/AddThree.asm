;******************************************************
; Program Name: AW-11
; Programmer:   Arman Ashrafian
; Class:        CS 3B
; Date:         4-10-2018
; Purpose:      Add three numbers
;*****************************************************

INCLUDE    ..\..\Irvine\Irvine32.inc

.data

dVal1 dword 15
dVal2 dword 18
dVal3 dword -7
dVal4 dword 11
dVal5 dword 22

.code
main PROC
    call NewLine

    push dVal1      ; push args
    push dVal2
    push dVal3      
    call AddThree   ; AddThree(dVal1, dVal2, dVal3)
    add esp, 12     ; clean stack

    call WriteDec   ; print result
    call NewLine    ; print newline

    ; AddThree(dVal2, dVal3, dVal4)
    push dVal2
    push dVal3
    push dVal4
    call AddThree
    add esp, 12     ; clean stack
    call WriteDec
    call NewLine

    ; AddThree(dVal3, dVal4, dVal5)
    push dVal3
    push dVal4
    push dVal5
    call AddThree
    add esp, 12     ; clean stack
    call WriteDec
    call NewLine

    ; AddThree(dVal1, dVal3, dVal5)
    push dVal1
    push dVal3
    push dVal5
    call AddThree
    add esp, 12     ; clean stack
    call WriteDec
    call NewLine

    call NewLine
    invoke ExitProcess, 0
main ENDP

; ****************************************************
AddThree PROC
; - AddThree(int, int, int)
; - sum returned in EAX 
;*****************************************************
    push ebp            ; save base ptr
    mov ebp,esp         ; set base of new stack frame
    mov eax,[ebp+16]    ; eax = param1
    add eax,[ebp+12]    ; eax += param2
    add eax,[ebp+8]     ; eax += param3
    pop ebp             ; restore base ptr
    ret                 ; return
AddThree ENDP

; ****************************************************
NewLine PROC
; - print new line
; ****************************************************
    push eax
    mov al, 10
    call WriteChar
    pop eax
    ret
NewLine ENDP

end main