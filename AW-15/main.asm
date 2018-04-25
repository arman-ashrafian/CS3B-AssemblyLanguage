;***************************************************************************
; Program Name: main.asm
; Programmer:   Arman Ashrafian
; Class:        CS 3B
; Date:         4-24-2018
; Purpose:      AW-15
;**************************************************************************

; Include Irvine Lib
INCLUDE    ..\..\Irvine\Irvine32.inc  ; Irvine Macros
INCLUDE    ..\macros\Bailey.inc       ; Bailey Macros

SampleStruct STRUCT
    dArray dword 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20
    align word
    field1 word ?
SampleStruct ENDS

.data
align dword
sample SampleStruct <>

strField1 byte "Field 1: ",0
strArray  byte "Array:",10,0
.code

_start:	
    call	Clrscr

    mov sample.field1, 100 ; field1 = 100

    mov edx, offset strField1
    call WriteString
    call Crlf

    mov eax, 0
    mov ax, sample.field1
    call WriteDec
    call Crlf

    mov edx, offset strArray
    call WriteString
    mov ebx, 0
printLoop:
    mov eax, [sample.dArray+ebx]
    call WriteDec
    call Crlf
    add ebx, 4
    cmp ebx, 80
    jne printLoop

    invoke ExitProcess, 0
end _start