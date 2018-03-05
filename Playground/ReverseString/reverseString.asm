; Reverse a string

.386
.model flat, stdcall
.stack 4096
option casemap :none

; Function Prototypes
ExitProcess 	proto, dwExitCode:dword
putstring		proto near32 stdcall, lpStringToPrint:dword 
getstring		proto near32 stdcall, lpStringToGet:dword, dlength:dword

include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data

	myName 		byte "Arman Ashrafian", 0
	nameLength	equ	 (LENGTHOF myName) - 1
    

.code
    main PROC
		; push name on stack
		mov ecx, nameLength
		mov esi, 0
		L1:
			movzx eax, myName[esi]
			push  eax
			inc   esi
			loop L1
		
		; pop off stack in reverse order
		mov ecx, nameLength
		mov esi, 0
		L2: 
			pop eax
			mov myName[esi], al
			inc esi
			loop L2
		
		; output string
		INVOKE putstring, addr myName
		
	
        INVOKE ExitProcess, 0
	main ENDP
	END main