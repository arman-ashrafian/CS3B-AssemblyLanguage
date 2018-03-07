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

array 	dword 4 dup(0)

zeros 	byte 50 dup(?)

.code

    main PROC
		mov eax, 10
		mov esi, 0
		call proc_1
		add esi, 4
		add eax, 10
		mov array[esi], eax
	
        INVOKE ExitProcess, 0
	main ENDP
	
	proc_1 PROC
		call proc_2
		add esi, 4
		add eax, 10
		mov array[esi], eax
		ret
	proc_1 ENDP
	
	proc_2 PROC
		call proc_3
		add esi, 4
		add eax, 10
		mov array[esi], eax
		ret
	proc_2 ENDP
	
	proc_3 PROC
		mov array[esi], eax
		ret
	proc_3 ENDP
	
	; recieves eax, ebx, ecx
	; eax = sum
	sumOfThree PROC
		add eax, ebx
		add eax, ecx
		ret
	sumOfThree ENDP
	
	
	END main