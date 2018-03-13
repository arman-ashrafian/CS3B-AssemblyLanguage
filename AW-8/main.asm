;******************************************************
; Program Name: main.asm
; Programmer:   Arman Ashrafian
; Class:        CS 3B
; Date:         3-13-2018
; Purpose:
;     Chapter 6 HW: Conditional Processing
;*****************************************************

.386
.model flat, stdcall
.stack 4096
option casemap :none

INCLUDE    ..\..\Irvine\Irvine32.inc

.data
strMyName     byte "Arman Ashrafian", 0
strAssign     byte "Assignment AW-8",0

value          dword    5
strALequals    byte     "1. AL = ",0
strParity      byte     "2. Parity = ",0
strSetX        byte     "SetX = ",0
strSetY        byte     "SetY = ",0
strNum3        byte     "3. ",10,0
strNum4        byte     "4. ",0
strNum5        byte     "5. ",0
strEAX         byte     "EAX  = ",0

setX           dword    111122AAh
setY           dword    00110011h

strLessThan    byte     "LESS THAN",0
strGreaterThan byte     "GREATER THAN",0


.code
main PROC

	call Clrscr               ; clear screen

	mov ax, lightCyan         ; set font color to Cyan
	call SetTextColor
	
	mov edx, offset strMyName ; Display Name
	call WriteString
	call WriteNewLine

	mov edx, offset strAssign ; Display Assignment
	call WriteString

	call WriteNewLine         ; print two newlines
	call WriteNewLine

	; 1. Write a single instruction that converts an ASCII 
	; digit in AL ('A') to its corresponding binary value.
	; If AL already contains a binary value (00h to 09h),
	; leave it unchanged.

	mov eax, 65
	and al,  0Fh
	
	mov ebx, type byte              ; bits to display	
	mov edx, offset strALequals     ; string to print
	call WriteString                ; print "1. AL = "
	call WriteDec                   ; print AL bits
	mov al, 10
	call WriteChar                  ; print newline
	
	;2. Write instructions that calculate the parity of a
	; 32-bit memory operand. 
	
	mov al, byte ptr value
	xor al, byte ptr value+1
	xor al, byte ptr value+2
	xor al, byte ptr value+3

	jp parity_set    ; jump if parity = 1
	jnp parity_unset ; jump if parity = 0

	parity_set:
	mov eax, 1
	jmp done
	parity_unset:
	mov eax, 0

	done:
	mov edx, offset strParity
	call WriteString    ; display "2. Parity = "
	call WriteDec       ; display parity value 
	call WriteNewLine

	; 3. Given two bit-mapped sets named SetX and SetY
	; write a sequence of instructions that generate a 
	; bit string in EAX that represents members in SetX 
	; that are not members of SetY.

	mov edx, offset strNum3    ; display "3. "
	call WriteString

	mov edx, offset strSetX
	call WriteString           ; display "SetX = "
	mov eax, setX
	call WriteBin              ; display setX
	call WriteNewLine

	mov edx, offset strSetY
	call WriteString           ; display "SetY = "
	mov eax, setY
	call WriteBin              ; display setY
	call WriteNewLine

	mov edx, offset strEAX
	call WriteString           ; display "EAX = "

	mov eax, setX
	mov edx, eax
	and edx, setY
	sub eax, edx

	call WriteBin              ; display EAX
	call WriteNewLine

	; 4. Write instructions that jump to label L1 when the 
	; unsigned integer in DX = (4) is less than or equal to 
	; the integer in CX = (5).

	mov edx, offset strNum4
	call WriteString           ; display "4. "

	mov dx, 4
	mov cx, 5

	cmp dx, cx
	jbe L1
	mov edx, offset strGreaterThan
	jmp next
	L1:
	mov edx, offset strLessThan
	next:
	call WriteString
	call WriteNewLine

	; 5. Write instructions that jump to label L2 when the 
	; signed integer in AX = (10) is greater than the integer 
	; in CX = (5).

	mov edx, offset strNum5
	call WriteString           ; display "5. "

	mov ax, 10
	mov cx, 5

	cmp ax, cx
	ja L2
	mov edx, offset strLessThan
	jmp next2
	L2:
	mov edx, offset strGreaterThan
	next2:
	call WriteString
	call WriteNewLine

	mov ax, green         ; set font color back to green
	call SetTextColor
	
    invoke ExitProcess, 0
main ENDP

; Write New Line
WriteNewLine PROC
	mov eax, 10
	call WriteChar    ; write new line
	ret
WriteNewLine ENDP

end main
