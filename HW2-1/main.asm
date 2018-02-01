;******************************************************
; Program Name:		main.asm
; Programmer: 		Arman Ashrafian
; Class:			CS 3B
; Date:				1-30-2018
; Purpose:			Test out code for HW 2-1 
;*****************************************************
.386
.model flat, stdcall
option casemap :none

include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data

.code
main:

	mov EAX, 10A0FFFFh
	ADD AL,  0Ah
	
	mov EAX, 10A0FFFFh
	SUB AL,  0Fh
	
	mov EAX, 10A0FFFFh
	ADD AX,  1h
	
	mov EAX, 10A0FFFFh
	ADD EAX, 0FFFFFFFFh
	
	mov EAX, 10A0FFFFh
	ADD AH,  1h
	

	
	invoke ExitProcess, 0
end main
