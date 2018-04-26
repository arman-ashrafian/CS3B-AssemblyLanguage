;***************************************************************************
; Program Name: main.asm
; Programmer:   Arman Ashrafian
; Class:        CS 3B
; Date:         4-24-2018
; Purpose:      AW-14
;**************************************************************************

; Include Irvine Lib
INCLUDE    ..\..\Irvine\Irvine32.inc
INCLUDE    ..\macros\Bailey.inc       ; Bailey Prototypes


extern String_equals@0:Near32
String_equals EQU String_equals@0

.data

strString1 byte "Arman",0
strString2 byte "Arman",0
strAL      byte "AL = ",0

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
    ret 4                       ; returns result from eax & clears local stack frame
String_length ENDP              ; end String_length function


_start:	
    mov eax, 0
    call	Clrscr

    push offset strString1
    push offset strString2
    call String_equals      ; return bool in AL
    add esp, 8
    
    invoke putstring, addr strString1
    call Crlf
    invoke putstring, addr strString2
    call Crlf
    invoke putstring, addr strAL
    call WriteDec
    

    invoke ExitProcess, 0
end _start