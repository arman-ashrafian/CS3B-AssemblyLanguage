;*******************************************************************
; Program Name: 	main.asm
; Programmer: 		Arman Ashrafian
; Class:			CS 3B
; Date:				2-6-2018
; Purpose:			Use Chapter 4 Instructions
;*******************************************************************

.486
.model flat, stdcall
.stack 4096
option casemap :none

include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data

three   DWORD 11112222h   ; dword for question #1

iArray  DWORD 10000h,20000h,30000h,40000h   ; dword array for question #7

.code
    main:

;*************************************************************************
;1. Write a sequence of MOV instructions that will exchange the upper and
;   lower 
;*************************************************************************
        
        mov ax, word ptr three      ; mov lower word into ax
        mov bx, word ptr three+2    ; mov upper word into bx
        mov word ptr three, bx      ; mov bx to lower word of three
        mov word ptr three+2, ax    ; mov ax to upper word of three

;**************************************************************************
;2. Using the XCHG instruction no more than three times, reorder the
;   values in four 8-bit registers
;**************************************************************************
       
        xchg ah, bh     ; exhange ah & bh
        xchg ah, ch     ; exhange ah & ch
        xchg ah, dh     ; exhange ah & dh

;**************************************************************************
;3. Transmitted messages often include a parity bit whose value is combined
;   with a data byte to produce an even number of 1 bits. Suppose a message
;   byte in the AL register contains 01110101. Show how you could use the
;   Parity flag combined with an arithmetic instruction
;   to determine if this message byte has even or odd parity.
;**************************************************************************

        mov al, 01110101b   ; AL = 01110101
        add al, 0           ; this sets the parity flag,
                            ; PF = 0 (odd) in this case

;**************************************************************************
;4. Write code using byte operands that adds two negative integers and
;causes the Overflow flag to be set.
;**************************************************************************
        
        mov al, -120
        add al, -10     ; causes overflow (AL min value is -128)
                        ; OF = 1

;**************************************************************************
;5. Write a sequence of two instructions that use addition to set
;   the Zero and Carry flags at the same time.
;**************************************************************************

        mov al, 255
        add al, 1       ; sets carry flag since AL is already at max value,
                        ; also sets zero flag since AL will be zeroed out 

;**************************************************************************
;6. Write a sequence of two instructions that set the Carry flag
;   using subtraction.
;**************************************************************************
        
        mov al, 1
        sub al, 2

;**************************************************************************
;7. Write a loop that iterates through a doubleword array and calculates
;   the sum of its elements using a scale factor with indexed addressing.
;**************************************************************************

        mov edi, offset iArray
        mov ecx, lengthof iArray
        mov eax, 0

        loop1:
            add eax, edi
            add edi, TYPE iArray
        loop loop1

        invoke ExitProcess, 0
    end main