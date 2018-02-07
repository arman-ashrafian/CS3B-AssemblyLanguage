;************************************************************
; Program Name: 		MASM 0.5
; Programmer: 			Arman Ashrafian
; Class:				CS 3B
; Date:					1-7-2018
; Purpose:				
;	1. Write a program that calculates A = (A+B) - (C+D)
;	and assigns integer values to EAX, EBX, ECX, and EDX.
;	2. Write a program that defines symbolic constants for all
; 	seven days of the week. Create an array that uses the
; 	the symbols as initializers.
;	3. Write a program that contains a def. of each data type
; 	listed in Table 3-2 in section 3.4.
;*************************************************************

.486
.model flat, stdcall
.stack 1000
option casemap :none

ExitProcess PROTO, dwExitCode:dword

include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data
	; Part 2:
	; define days of the week
	strMon 		equ 	"MONDAY"
	strTues		equ		"TUESDAY"
	strWed		equ		"WEDNESDAY"
	strThurs	equ		"THURSDAY"
	strFri		equ		"FRIDAY"
	strSat		equ		"SATURDAY"
	strSun		equ		"SUNDAY"
	
	; create array for days of the week
	arrayWeek 	byte	strMon, strTues, strWed, strThurs, strFri, strSat, strSun, strSun
	
	; Part 3:
	; table 3-2 data types
	
	b			byte		01h
	sb			sbyte		0FFh
	w			word		0001h
	sw			sword		0FFFFh
	double		dword		00000001h
	sDouble		sdword		0FFFFFFFFh
	farPointer	fword		0FFFFFFFFFFFFh
	quadword	qword		0FFFFFFFFFFFFFFFFh
	tenByte		tbyte		0FFFFFFFFFFFFFFFFFFFFh
	realShort	real4		0FFFFFFFFh
	realLong	real8		0FFFFFFFFFFFFFFFFh
	realExtend	real10		0FFFFFFFFFFFFFFFFFFFFh
	
	
	
.code
    main PROC
		; Part 1:
		; A = 4, B = 3, C = 2, D = 1
		; A = (A+B) - (C+D)
	
		mov		eax, 4
		mov		ebx, 3
		mov		ecx, 2
		mov		edx, 1
		
		add		eax, ebx
		add		ecx, edx
		
		sub		eax, ecx
		
	
        invoke ExitProcess, 0
    main endp
	end main