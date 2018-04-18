;***************************************************************************
; Program Name: main.asm
; Programmer:   Arman Ashrafian
; Class:        CS 3B
; Date:         4-12-2018
; Purpose:      AW-13
;**************************************************************************

; Include Irvine Lib
INCLUDE    ..\..\Irvine\Irvine32.inc
INCLUDE    ..\macros\Bailey.inc       ; Bailey Prototypes

.data

strPrompt byte "Enter String: ",0
strString byte 50 dup(?)
strNL     byte 10,0

.code
String_length PROC
    push ebp					; preserve base register
    mov ebp,esp					; set new stack frame
    push ebx					; preserve used registers
    push esi 
    mov ebx,[ebp+8]				; set ebx pointer to string
    mov esi,0					; esi = 0
stLoop: 
    cmp byte ptr[ebx+esi],0	    ; reached the end of the string
    je finished				    ; when yes, string input ends here
    inc esi					    ; otherwise, continue to next character`
    jmp stLoop				    ; until a NULL character is hit
finished: 
    mov eax,esi					; returns the length to EAX
    pop esi			            ; restore preserved registers
    pop ebx			            ; restore preserved registers
    pop ebp			            ; restore preserved registers
    ret                         ; returns result from eax & clears local stack frame
String_length ENDP              ; end String_length function


_start:	
    call	Clrscr

    invoke ExitProcess, 0
end _start