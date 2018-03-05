;*******************************************************************
; Program Name: 	main.asm
; Programmer: 		Arman Ashrafian
; Class:		    CS 3B
; Date:			    2-6-2018
; Purpose:		    Copy a string in reverse order.
;*******************************************************************

.486
.model flat, stdcall
.stack 1000
option casemap :none

; Function Prototypes
ExitProcess proto, dwExitCode:dword
putstring	proto near32 stdcall, lpStringToPrint:dword 

include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data
source byte "This is the source string",0   ; Source String
target byte (sizeof source - 1) dup('#'),0  ; Target String

.code
    main:
        mov esi,0                           ; starting index to traverse source
        mov edi, LENGTHOF source - 2        ; starting index to traverse target 
        mov ecx, SIZEOF source              ; ECX = size(source)

        L1:                                 ; START L1
            mov al, source[esi]             ; AL = source[esi]
            mov target[edi], al             ; target[edi] = AL
            inc esi                         ; esi++
            dec edi                         ; edi--
        loop L1                             ; END L1

		int 3 ;

        invoke ExitProcess, 0
    end main
