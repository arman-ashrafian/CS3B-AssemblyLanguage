;******************************************************
; Program Name: AW-10
; Programmer:   Arman Ashrafian
; Class:        CS 3B
; Date:         3-27-2018
; Purpose:      Chapter 7 concepts
;*****************************************************

.386
.model flat, stdcall
.stack 4096
option casemap :none

INCLUDE    ..\..\Irvine\Irvine32.inc

.data

byteArray   BYTE    81h, 20h, 33h           ; for #7
wordArray   WORD    810Dh, 0C064h, 93ABh    ; for #8
val1        WORD    ?                       ; for #9 & #10

.code
main:
    mov eax, 0      ; EAX = 0
    mov ax, 0A111h  ; AX = A111h

    ; 1. Write a sequence of instructions to sign extend AX into EAX.
    shl eax, 16
    sar eax, 16   

    ; 2. Use SHR and conditional jump to rotate contents of AL register 1 bit
    ; to the right (do not use rotate instruction).
    shr al, 1
    jnc next1 
    or al, 80h
    next1:

    ; 3. Write logical shift instruction that multiplies EAX by 16
    shl eax, 4

    ; 4. Write logical shift instruction that divides EBX by 4
    mov ebx, 20
    shr ebx, 2

    ; 5. Write a single rotate instruction that exchanges the high & low halves
    ; of the DL register
    mov dl, 0ABh
    rol dl, 4

    ; 6. Write a single SHLD instruction that shifts the highest bit of AX
    ; into the lowest bit position of DX and shifts DX one bit to the left. 
    shld dx, ax, 1

    ; 7. Write a sequence of instructions that shift three memory butes to
    ; the right by 1 bit position. 
    shr byteArray+2, 1
    rcr byteArray+1, 1
    rcr byteArray, 1

    ; 8. Write a sequence of instructions that shifts three memory words to 
    ; the left by 1 bit.
    shl wordArray, 1
    rcl wordArray+2, 1
    rcl wordArray+4, 1

    ; 9. Write instructions that multpily -5 by 3 & store the result in val1.
    mov ax, 3
    mov bx, -5
    imul bx
    mov val1, ax

    ; 10. Write instructions that divide -276 by 10 and store in val1
    mov ax, -276
    cwd
    mov bx, 10
    idiv bx
    mov val1, ax

    invoke ExitProcess, 0
end main