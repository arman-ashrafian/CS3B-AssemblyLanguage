;******************************************************
; Program Name:		hello.asm
; Programmer: 		Arman Ashrafian
; Class:			CS 3B
; Date:				1-30-2018
; Purpose:			Hello world assembly program
;					to practice assembling, linking,
;					and debugging. 
;*****************************************************
.386
.model flat, stdcall
option casemap :none

include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data
message db "Program Finished",0

.code
main:
	mov eax, 0FFFFh
	mov ax, 34h

	invoke StdOut, addr message
	invoke ExitProcess, 0
end main

