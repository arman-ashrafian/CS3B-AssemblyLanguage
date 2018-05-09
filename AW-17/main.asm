;***************************************************************************
; Program Name: main.asm
; Programmer:   Arman Ashrafian
; Class:        CS 3B
; Date:         5-8-2018
; Purpose:      AW-17
;**************************************************************************

; Include Irvine Lib
INCLUDE    ..\..\Irvine\Irvine32.inc  ; Irvine Macros
INCLUDE    ..\..\Irvine\Macros.inc
INCLUDE    ..\macros\Bailey.inc       ; Bailey Macros

.data

B real8 7.8
M real8 3.6
N real8 7.1
P real8 ?

.code

_start:	
    call Clrscr

    fld M
    fchs

    fld N
    fld B
    fadd
    fmul
    fst P
    call WriteFloat

    invoke ExitProcess, 0
end _start