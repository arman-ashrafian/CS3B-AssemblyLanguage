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

; Function Prototypes
ExitProcess             proto, dwExitCode:dword
putstring               proto near32 stdcall, lpStringToPrint:dword 
getstring               proto near32 stdcall, lpStringToGet:dword, dlength:dword
ascint32                proto near32 stdcall, lpStringToConvert:dword
intasc32Comma           proto near32 stdcall, lpStringToHold:dword,dVal:dword
hexToChar               proto near32 stdcall, lpDestStr:dword, lpSourceStr:dword, dLen:dword

include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data
	newLine         db      10,0           ; ascii new line
	
	strHeader       db      "     Name: Arman Ashrafian", 10,
                                "    Class: CS 3B Assembly Language", 10,       ; lab heading
                                "      Lab: MASM1", 10,
			        "     Date: 2/13/2018", 10, 0
							
	strEnterNum     db      "    Enter a whole number: ",0                  ; prompt user 
	
	strAddress	db "The addresses of the 4 ints:",10,0			; "The address of the four ints:"
	
	strTab		db "    ",0                                             ; 4 spaces
	
	; allocate memory for user input
	strA		db		12 dup(?)                               ; 12 bytes for user input
	strB		db		12 dup(?)                               ; 12 bytes for user input
	strC		db		12 dup(?)                               ; 12 bytes for user input
	strD		db 		12 dup(?)                               ; 12 bytes for user input
	
	; allocate memory for calculation
	doubleA		dd		?                                       ; 2 bytes for integer value of user input
	doubleB		dd		?                                       ; 2 bytes for integer value of user input
	doubleC		dd		?                                       ; 2 bytes for integer value of user input
	doubleD		dd		?                                       ; 2 bytes for integer value of user input

	; math characters
	strOParen	db		"(",0				; open paranthesis
	strCParen	db		")",0				; closed paranthesis
	strAdd		db		"+",0				; addition sign
	strSub		db		"-",0				; subtraction sign
	strEqual	db		"=>",0				; equal arrow
	strSpace	db		" ",0				; space
    
.code
    main:
		; output header
		invoke putstring, addr strHeader		; print header
		invoke putstring, addr newLine			; print newline
		
		; prompt # 1
		invoke putstring, addr strEnterNum		; print prompt
		invoke getstring, addr strA, 11			; get user input
		invoke putstring, addr newLine			; print newline
		
		; prompt # 2
		invoke putstring, addr strEnterNum		; print prompts
		invoke getstring, addr strB, 11			; get user input
		invoke putstring, addr newLine			; print newline
		
		; prompt # 3
		invoke putstring, addr strEnterNum		; print prompts
		invoke getstring, addr strC, 11			; get user input
		invoke putstring, addr newLine			; print newline
		
		; prompt # 4
		invoke putstring, addr strEnterNum		; print prompt
		invoke getstring, addr strD, 11			; get user input
		invoke putstring, addr newLine			; print newline
		invoke putstring, addr newLine			; print newline
		
		; display left-hand signed of calulcation
		invoke putstring, addr strOParen		; print '('
		invoke putstring, addr strSpace			; print ' '
		invoke putstring, addr strA				; print A
		invoke putstring, addr strSpace			; print ' '
		invoke putstring, addr strAdd			; print '+'
		invoke putstring, addr strSpace			; print ' '
		invoke putstring, addr strB				; print B
		invoke putstring, addr strSpace			; print ' '
		invoke putstring, addr strCParen		; print ')'
		invoke putstring, addr strSpace			; print ' '
		invoke putstring, addr strSub			; print '-'
		invoke putstring, addr strSpace			; print ' '
		invoke putstring, addr strOParen		; print '('
		invoke putstring, addr strSpace			; print ' '
		invoke putstring, addr strC				; print C
		invoke putstring, addr strSpace			; print ' '
		invoke putstring, addr strAdd			; print '+'
		invoke putstring, addr strSpace			; print ' '
		invoke putstring, addr strD				; print D
		invoke putstring, addr strSpace			; print ' '
		invoke putstring, addr strCParen		; print ')'
		invoke putstring, addr strSpace			; print ' '
		invoke putstring, addr strEqual			; print	'=>'
		invoke putstring, addr strSpace			; print ' '
		
		; conversions
		; acint32 take in string and puts integer value
		; in eax register
		invoke ascint32, addr strA	; convert
		mov doubleA, eax                ; mov conversion into doubleA
		
		invoke ascint32, addr strB	; convert
		mov doubleB, eax                ; mov conversion into doubleB
		
		invoke ascint32, addr strC	; convert
		mov doubleC, eax                ; mov conversion into doubleC
		
		invoke ascint32, addr strD	; convert
		mov doubleD, eax                ; mov conversion into doubleD
		
		; calculation
		mov		eax, doubleA    ; mov A into EAX
		add		eax, doubleB    ; add B to EAX
		mov		ebx, doubleC    ; mov C into EBX
		add		ebx, doubleD    ; add D to EBX
		sub		eax, ebx        ; EAX - EBX
		
		; display answer
		invoke intasc32Comma, addr strA, eax            ; convert answer to string and mov into strA
		invoke putstring, addr strA                     ; display answer
		invoke putstring, addr newLine                  ; print newline
		invoke putstring, addr newLine                  ; print newline
		
		; display addresses
		invoke putstring, addr strAddress               ; print "The addresses of the 4 ints:\n"
		invoke hexToChar, addr strA, addr doubleA, 0    ; convert address of double A to string and store in strA
		invoke putstring, addr strA                     ; print address of A
		invoke putstring, addr strTab                   ; print '\t'
		invoke hexToChar, addr strB, addr doubleB, 0    ; convert address of double B to string and store in strB
		invoke putstring, addr strB                     ; print address of B
		invoke putstring, addr strTab                   ; print \t'
		invoke hexToChar, addr strC, addr doubleC, 0    ; convert address of double C to string and store in strC
		invoke putstring, addr strC                     ; print address of C
		invoke putstring, addr strTab                   ; print \t'
		invoke hexToChar, addr strD, addr doubleD, 0    ; convert address of double D to string and store in strD
		invoke putstring, addr strD                     ; print address of D
		invoke putstring, addr newLine                  ; print newline
		invoke putstring, addr newLine                  ; print newline
	
        invoke ExitProcess, 0                                   ; return 0
    end main
	
