;***************************************************************
; Program Name: 	main.asm
; Programmer: 		Arman Ashrafian
; Class:			CS 3B
; Date:				2-6-2018
; Purpose:			
; 1. Define four symbolic constants that represent 25
; 	 (decimal, binary, octal, hex) 
; 2. Find out if a program can have multiple code/data segments.
; 	 Attach screenshot 2.png.
; 3. Create data def for a DWORD that stores data in Big Endian.
; 4. Find out if you can declare a DWORD and assign it a (-)
;    value. What does this say about assemblers type checking? 
;    Attach screenshot 4.png.
; 5. Declare an array of byte & init. it to A,B,C,D,E.
; 6. Declare and uninit. array of 50 signed DWORDs named dArray.
; 7. Declare string variable to contain "TEST" repeated 500x.
; 8. Declare array of 20 unisigned bytes named bArray & init. 
;    all elements to 0.
;****************************************************************

.386
.model flat, stdcall
.stack 4096
option casemap :none

include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data
    

.code
    main:

	
        invoke ExitProcess, 0
    end main