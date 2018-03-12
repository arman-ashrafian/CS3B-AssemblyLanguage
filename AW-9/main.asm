;******************************************************
; Program Name: main.asm
; Programmer: Arman Ashrafian
; Class: CS 3B
; Date: 3-13-2018
; Purpose: Chapter 6 HW: Conditional Processing
;*****************************************************

.386
.model flat, stdcall
.stack 4096
option casemap :none

INCLUDE    ..\..\Irvine\Irvine32.inc

.data
strNum1		  byte "1. ",0
strNum2		  byte "2. ",0
strNum3		  byte "3. ",0	
strNum4		  byte "4. ",0
strALequals   byte "AL = ",0
strIs         byte " is ",0
strIsEqual    byte "= 0",10,0
strNotEqual   byte "!= 0",10,0
strXEquals	  byte "X = ",0

val1		  dword 15h
valX		  dword ?

; #4 vars
valA dword ?
valB dword ?
valN dword ?


.code
main PROC

	call Clrscr	; clear screen
	
	;******************************************************
	; 1. Write instructions that sets AL to 8Eh, then
	; clear bits 0 and 1 in AL. Then, if the destination
	; operand is equal to zero, the code should jump to
	; label L3. Otherwise, it should jump to label L4. 
	; Display a message to the console with the
	; appropriate answer i.e. "1. AL = ## is = 0" or
	; "1. AL = ## is != 0" depending on the result.
	;******************************************************

	mov al, 8Eh				; AL = 1000 1110
	and al, 11111100b		; clear bits 0 & 1
	
	mov edx, offset strNum1
	call WriteString			; write "1. "
	mov edx, offset strALequals	; write "AL = "
	call WriteString
	mov ebx, type byte
	call WriteHexB				; display AL contents in hex
	mov edx, offset strIs
	call WriteString			; write " is "
	
	jz	L3		; AL == 0
	jnz	L4		; AL != 0

	L3:
	mov edx, offset strIsEqual
	call WriteString
	L4:
	mov edx, offset strNotEqual
	call WriteString
	call WriteNewLine

	;******************************************************
	; 2. Implement psuedocode using short-circuit eval
	; and display "2. X = #".
	; (val1 = 15h, ecx = 20h, edx = EFh)
	;
	;if( val1 > ecx ) AND ( ecx > edx )
	;	X = 1
	;else 
	;	X = 2;
	;******************************************************

	mov ecx, 20h	; set initial conditions
	mov edx, 0EFh

	cmp val1, ecx
	jna L1			; val1 < ecx
	cmp ecx, edx
	jna L1			; ecx < edx

	mov valX, 1		; valX = 1
	jmp next

	L1: mov valX, 2	; valX = 2
	next:
	mov edx, offset strNum2
	call WriteString		; write "2. "
	mov edx, offset strXEquals
	call WriteString		; write "X = "
	mov ebx, type byte
	mov eax, valX
	call WriteHexB			; write value of X
	call WriteNewLine

	;******************************************************
	; 3. Implement psuedocode using short-circuit eval
	; and display "3. X = #".
	;
	; if( ebx > ecx ) OR ( ebx > val1 )
	; 	X = 1
	; else
	; 	X = 2
	;******************************************************
	mov ecx, 20h	; set initial conditions
	mov ebx, 0EFh

	cmp ebx, ecx
	ja true			; ebx > ecx
	cmp ebx, val1
	ja true			; ebx > val1

	mov valX, 2
	jmp next2

	true: mov valX, 1
	next2:
	mov edx, offset strNum3
	call WriteString
	mov edx, offset strXEquals
	call WriteString
	mov ebx, type byte
	mov eax, valX
	call WriteHexB
	call WriteNewLine

	;******************************************************
	; 4. Implement psuedocode, 
	;
	;int a = 5;
	;int b = 6;
	;int n = 4;
	;cout << "4." << endl;
	;while n > 0 {
	;   if n != 3 AND (n < A OR n > B){
	;		n = n – 2
	;		cout << n << endl;
	;	}
	;	else {
	;   	n = n – 1
	;   	cout << n << endl;
	;	}
	;}
	;******************************************************
	mov valA, 5
	mov valB, 6
	mov valN, 4

	mov edx, offset strNum4
	call WriteString
	call WriteNewLine

	whileloop:
		cmp valN, 0
		jbe loopdone

		cmp valN, 3
		je else_block

		mov eax, val1
		cmp eax, valA
		jb true_if
		cmp eax, valB
		ja true_if

		true_if:
		dec valN
		dec valN
		mov eax, valN
		call WriteInt
		call WriteNewLine
		jmp nextloop
		else_block:
		dec valN
		mov eax, valN
		call WriteInt
		call WriteNewLine

		nextloop:
		jmp whileloop
	loopdone:
    invoke ExitProcess, 0
main ENDP

; Write New Line
WriteNewLine PROC
	mov eax, 10
	call WriteChar	; write newline
	ret
WriteNewLine ENDP

end main