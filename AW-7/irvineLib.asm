;******************************************************
; Program Name: 	main.asm
; Programmer: 		Arman Ashrafian
; Class:					CS 3B
; Date:					3-6-2018
; Purpose:	
;	AW-7 Question 5
;*****************************************************


.386
.model flat, stdcall
.stack 4096
option casemap :none

; IRVINE Libraries
INCLUDELIB ..\Irvine\Kernel32.Lib
INCLUDELIB ..\Irvine\User32.Lib
INCLUDELIB ..\Irvine\Irvine32.lib
INCLUDE    ..\Irvine\Irvine32.inc

.data

zeros   dword 50 dup(?) ; make memory look nice in OllyDbg

.code

main PROC
	
	INVOKE ExitProcess, 0
main ENDP



END main


