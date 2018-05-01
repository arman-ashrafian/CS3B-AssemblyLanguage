;***************************************************************************
; Program Name: main.asm
; Programmer:   Arman Ashrafian
; Class:        CS 3B
; Date:         4-26-2018
; Purpose:      AW-16
;**************************************************************************

; Include Irvine Lib
INCLUDE    ..\..\Irvine\Irvine32.inc  ; Irvine Macros
INCLUDE    ..\..\Irvine\Macros.inc
INCLUDE    ..\macros\Bailey.inc       ; Bailey Macros

mWriteAt MACRO X,Y,literal
	mGotoxy X,Y
	mWrite literal
ENDM

.data

.code

_start:	
    call Clrscr
    mWriteAt 20,20,"Location (20,20)"
    call Crlf

    invoke ExitProcess, 0
end _start