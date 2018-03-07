;******************************************************
; Program Name: 	main.asm
; Programmer: 		Arman Ashrafian
; Class:					CS 3B
; Date:					3-6-2018
; Purpose:	
;	AW-7 Questions #1-4
;*****************************************************


.386
.model flat, stdcall
.stack 4096
option casemap :none

INCLUDE    ..\..\Irvine\Irvine32.inc

.data

myArray dword 100h, 200h, 300h, 400h, 500h ; dword array for #4
myName byte "Arman Ashrafian",10,13,0
zeros   dword 50 dup(?) ; make memory look nice in OllyDbg

.code

main PROC

	; 1. Write a sequence of statements that use only PUSH and POP instructions
	; to exchange the values in the EAX and EBX registers.
	mov  eax, 512
	mov  ebx, 1024
	push eax
	push ebx
	pop   eax
	pop   ebx
	
	; 4. Write a sequence of statements using indexed addressing that copies an
	; element in a doubleword array to the previous position in the same array.
	mov esi, 2				; set index of element to copy
	mov edi,esi
	dec edi					
	mov edx,myArray[esi*4]	; mov myArray[element] to edx
	mov myArray[edi*4],edx	; mov edx to previous position

	mov	ax, blue
	call	SetTextColor
	
	mov	edx,OFFSET myName
	call	WriteString
	
	; reset back to green text
	mov ax, green
	call SetTextColor
	
	INVOKE ExitProcess, 0
main ENDP

; 2. Write a sequence of instructions that will return
; 3 address higher than address currently on the stack

;-----------------------------------------------------
; returnPlus3
;
; returns 3 address higher than the address currently
; on the stack.
;-----------------------------------------------------
returnPlus3 PROC
	pop  eax 	; EAX = return address
	add  eax, 3 ; add 3 to return address
	push eax	; push EAX back onto stack before returning
	ret
returnPlus3 ENDP

; 3. Write an instruction that you could put at the
; beginning of an assembly language subroutine that 
; would reserve space for two integer DWORD variables.

;-----------------------------------------------------
; localVariables
;
; reserve space for two local DWORDs
;-----------------------------------------------------
localVariables PROC
	mov  eax, 1000h
	push eax				; move 1000h onto stack
	mov  eax, 2000h
	push eax				; move 2000h onto stack
	
	; remove local variables from stack
	pop eax
	pop eax
	
	ret
localVariables ENDP


END main


