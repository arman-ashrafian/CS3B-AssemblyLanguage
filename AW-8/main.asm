;******************************************************
; Program Name: 	main.asm
; Programmer: 		Arman Ashrafian
; Class:				CS 3B
; Date:				3-13-2018
; Purpose:
;		Chapter 6 HW: Conditional Processing
;*****************************************************

.386
.model flat, stdcall
.stack 4096
option casemap :none

INCLUDE    ..\..\Irvine\Irvine32.inc

.data

value dword ?
strALequals byte "AL = ",0

.code
main PROC

	;1. Write a single instruction that converts an ASCII 
	; digit in AL ('A') to its corresponding binary value.
	; If AL already contains a binary value (00h to 09h),
	; leave it unchanged. Display message to console
	; "1. AL = ##" with ## being the actual value.
	and al, 0Fh
	
	mov ebx, type byte		; bits to display	
	mov edx, offset strALequals	; string to print
	call WriteString		; print "AL = "
	call WriteBinB		; print AL bits
	mov al, 10
	call WriteChar		; print newline
	
	
	;2. Write instructions that calculate the parity of a
	; 32-bit memory operand. 
	
	mov al, byte ptr value
	xor al, byte ptr value+1
	xor al, byte ptr value+2
	xor al, byte ptr value+3
	
    invoke ExitProcess, 0
main ENDP
end main