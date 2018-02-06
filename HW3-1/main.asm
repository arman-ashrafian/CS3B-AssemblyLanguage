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
iX	dword 	27, -30
sY word 4 dup(5,22)
bVal byte 'GEORGE'
qVal qword -55
iY dword 2 dup(25,67)


.code
main:
	
	
	invoke ExitProcess, 0
end main
