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
	
	; 2. Suppose you wanted a subroutine to return to an address that was
	; 3 bytes higher in memory than the return address currently on the 
	; stack. Write a sequence of instructions that would be inserted just
	; before the subroutine’s RET instruction that accomplish this task.


	INVOKE ExitProcess, 0
main ENDP

END main