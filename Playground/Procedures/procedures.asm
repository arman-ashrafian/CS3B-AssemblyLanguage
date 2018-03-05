; Playing wit procedures

.386
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

strVal 	byte ?

.code
	; recieves eax, ebx, ecx
	; eax = sum
	sumOfThree PROC
		add eax, ebx
		add eax, ecx
		ret
	sumOfThree ENDP

    main PROC
		mov eax, 4
		mov ebx, 5
		mov ecx, 6
		
		; get sum
		CALL sumOfThree
		
		; output sum of three result
		INVOKE intasc32Comma, addr strVal, eax
		INVOKE putstring, addr strVal
	
        INVOKE ExitProcess, 0
	main ENDP
	END main