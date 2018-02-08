;******************************************************
; Program Name: 	MASM1.asm
; Programmer: 		Arman Ashrafian
; Class:			CS 3B
; Date:				2-13-2018
; Purpose:	
;	Write program to take input & execute
;	X = (A+B) - (C+D)
;*****************************************************

.486
.model flat, stdcall
.stack 4096
option casemap :none

ExitProcess proto, dwExitCode:dword

putstring	proto near32 stdcall, lpStringToPrint:dword 
getstring	proto near32 stdcall, lpStringToGet:dword, dlength:dword
ascint32	proto near32 stdcall, lpStringToConvert:dword
hexToChar 	proto near32 stdcall, lpDestStr:dword, lpSourceStr:dword, dLen:dword

include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data
	newLine		db		10,0								; ascii new line
	
	strHeader   db "     Name: Arman Ashrafian", 10,
					 "    Class: CS 3B Assembly Language", 10,	; lab heading
					 "      Lab: MASM1", 10,
					 "     Date: 2/13/2018", 10, 0
							
	strEnterNum	db "    Enter a whole number: ",0				; prompt user 
	
	; allocate memory for user input
	strA		dd		?
	strB		dd		?		
	strC		dd		?		
	strD		dd 		?
	
	; allocate memory for calculation
	doubleA		dd		?
	doubleB		dd		?
	doubleC		dd		?
	doubelD		dd		?
	
	; allocate memory for 

	; math characters
	strOParen	db		"(",0
	strCParen	db		")",0
	strAdd		db		"+",0
	strSub		db		"-",0
	strEqual	db		"=>",0
	strSpace	db		" ",0
    

.code
    main:
		
		; output header
		invoke putstring, addr strHeader
		invoke putstring, addr newLine
		
		; prompt # 1
		invoke putstring, addr strEnterNum
		invoke getstring, addr strA, 11
		invoke putstring, addr newLine
		
		; prompt # 2
		invoke putstring, addr strEnterNum
		invoke getstring, addr strB, 11
		invoke putstring, addr newLine
		
		; prompt # 3
		invoke putstring, addr strEnterNum
		invoke getstring, addr strC, 11
		invoke putstring, addr newLine
		
		; prompt # 4
		invoke putstring, addr strEnterNum
		invoke getstring, addr strD, 11
		invoke putstring, addr newLine
		
		; display left-hand signed of calulcation
		invoke putstring, addr strOParen
		invoke putstring, addr strSpace
		invoke putstring, addr strA
		invoke putstring, addr strSpace
		invoke putstring, addr strAdd
		invoke putstring, addr strSpace
		invoke putstring, addr strB
		invoke putstring, addr strSpace
		invoke putstring, addr strCParen
		invoke putstring, addr strSpace
		invoke putstring, addr strSub
		invoke putstring, addr strSpace
		invoke putstring, addr strOParen
		invoke putstring, addr strSpace
		invoke putstring, addr strC
		invoke putstring, addr strSpace
		invoke putstring, addr strAdd
		invoke putstring, addr strSpace
		invoke putstring, addr strD
		invoke putstring, addr strSpace
		invoke putstring, addr strCParen
		invoke putstring, addr strSpace
		invoke putstring, addr strEqual
		invoke putstring, addr strSpace

		
		; conversions
		invoke ascint32, addr strD
		mov doubleD, eax
		
	
        invoke ExitProcess, 0
    end main
	
	
	
	
	
	
	
	
	
	