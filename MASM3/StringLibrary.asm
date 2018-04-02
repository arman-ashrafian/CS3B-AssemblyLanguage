;***************************************************************************
; Program Name: StringLibrary.asm
; Programmer:   Arman Ashrafian
; Class:        CS 3B
; Date:         4-12-2018
; Purpose:      String Library
;**************************************************************************

; Dot Directives
.486
    .model flat, STDCALL
    .stack 4096
    option casemap :none

; Include Libraries
    INCLUDE ..\..\Irvine\Irvine32.inc  ; Irvine Prototypes
    INCLUDE ..\macros\Bailey.inc       ; Bailey Prototypes

.code 

String_length PROC
	push ebp					;preserve base register
	mov ebp,esp					;set new stack frame
	push ebx					;preserve used registers
	push esi
	mov ebx,[ebp+8]				;set ebx pointer to first string
	mov esi,0					;move esi indexes into the string
stLoop:
    cmp byte ptr[ebx+esi],0	    ;denotes reaching the end of the string
    je finished				    ;when yes, string input ends here
    inc esi					    ;otherwise, continue to next character`
    jmp stLoop				    ;until a NULL character is hit
finished:
	mov eax,esi					;returns the length to EAX
	pop esi			            ;restore preserved registers
	pop ebx			            ;restore preserved registers
	pop ebp			            ;restore preserved registers
	RET                         ;returns result from eax
String_length ENDP              ;end String_length function

END