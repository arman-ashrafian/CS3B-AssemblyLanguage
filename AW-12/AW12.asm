;******************************************************
; Program Name: AW12.asm
; Programmer:   Arman Ashrafian
; Class:        CS 3B
; Date:         4-12-2018
; Purpose:      Muti-Module program
;*****************************************************

; Include Irvine Lib
INCLUDE    ..\..\Irvine\Irvine32.inc

EXTERN PromptForIntegers@0:PROC
EXTERN ArraySum@0:PROC, DisplaySum@0:PROC

; Redefine external symbols for convenience
ArraySum			EQU ArraySum@0
PromptForIntegers	EQU PromptForIntegers@0
DisplaySum		    EQU DisplaySum@0

; modify Count to change the size of the array:
Count = 3

.data

prompt1 BYTE  "Enter a signed integer: ",0
prompt2 BYTE  "The sum of the integers is: ",0
array   DWORD  Count DUP(?)
sum     DWORD  ?

.code
main PROC
	call	Clrscr

; PromptForIntegers( addr prompt1, addr array, Count )
	push	Count
	push	OFFSET array
	push	OFFSET prompt1
	call	PromptForIntegers
	add 	esp, 12

; eax = ArraySum( addr array, Count )
	push	Count
	push	OFFSET array
	call	ArraySum
	mov	    sum,eax
	add 	esp, 8

; DisplaySum( addr prompt2, sum )
	push	sum
	push	OFFSET prompt2
	call	DisplaySum
	add 	esp, 8

	call	Crlf

    invoke ExitProcess, 0
main ENDP
end main