; Playing wit procedures

.486
.model flat, stdcall
.stack 4096
option casemap :none

; Function Prototypes
ExitProcess 	proto, dwExitCode:dword
putstring		proto near32 stdcall, lpStringToPrint:dword 
getstring		proto near32 stdcall, lpStringToGet:dword, dlength:dword
intasc32Comma	proto near32 stdcall, lpStringToHold:dword,dVal:dword


include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data

.code


main PROC

	; 1. Write a sequence of statements that use only PUSH and POP instructions
	; to exchange the values in the EAX and EBX registers.
	mov EAX, 512
	mov EBX, 1024
	push eax
	push ebx
	pop  eax
	pop  ebx
	
	CALL returnPlus3
	
	INVOKE ExitProcess, 0
main ENDP

; 2. Write a sequence of instructions that will return
; 3 address higher than address currently on the stack

;-----------------------------------------------------
; returnPlus3
;
; returns 3 address higher than the address currently
; on the stack.
;-----------------------------------------------------
returnPlus3 PROC
	pop  eax 	; EAX = return address
	add  eax, 3 ; add 3 to return address
	push eax	; push EAX back onto stack before returning
	ret
returnPlus3 ENDP

; 3. Write an instruction that you could put at the
; beginning of an assembly language subroutine that 
;would reserve space for two integer DWORD variables.

;-----------------------------------------------------
; localVariables
;
; reserve space for two local DWORDs
;-----------------------------------------------------

END main


