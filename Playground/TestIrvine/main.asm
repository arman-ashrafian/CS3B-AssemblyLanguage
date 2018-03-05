; Playing wit procedures

.386
.model flat, stdcall
.stack 4096
option casemap :none

; Function Prototypes
ExitProcess 	proto, dwExitCode:dword

include 	\masm32\include\kernel32.inc
include 	\masm32\include\masm32.inc
includelib 	\masm32\lib\kernel32.lib
includelib 	\masm32\lib\masm32.lib

.data
str1 BYTE "Sample string, in color",0dh,0ah,0

.code

main PROC
	
	mov	ax,yellow + (blue * 16)
	call	SetTextColor
	
	mov	edx,OFFSET str1
	call	WriteString
	
	call	GetTextColor
	call	DumpRegs
	
	INVOKE ExitProcess, 0
main ENDP
	
END main