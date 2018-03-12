;******************************************************
; Program Name: 	main.asm
; Programmer: 		Arman Ashrafian
; Class:					CS 3B
; Date:					3-13-2018
; Purpose:
;		Chapter 6 HW: Conditional Processing
;*****************************************************

.386
.model flat, stdcall
.stack 4096
option casemap :none

INCLUDE    ..\..\Irvine\Irvine32.inc

.data

.code
main PROC
	
	;******************************************
	; 1. Write instructions that sets AL to 8Eh, then
	; clear bits 0 and 1 in AL. Then, if the destination
	; operand is equal to zero, the code should jump to
	; label L3. Otherwise, it should jump to label L4. 
	; Display a message to the console with the
	; appropriate answer i.e. "1. AL = ## is = 0" or
	; "1. AL = ## is != 0" depending on the result.
	;******************************************
	
	;******************************************
	; 2. Implement psuedocode using short-circuit eval
	; and display "2. X = #".
	; (val1 = 15h, ecx = 20h, edx = EFh)
	;
	;if( val1 > ecx ) AND ( ecx > edx )
	;	X = 1
	;else 
	;	X = 2;
	;******************************************
	
	;******************************************
	; 3. Implement psuedocode using short-circuit eval
	; and display "3. X = #".
	;
	; if( ebx > ecx ) OR ( ebx > val1 )
	; 	X = 1
	; else
	; 	X = 2
	;******************************************
	
	;******************************************
	; 4. Implement psuedocode, 
	;
	; int a = 5;
	;int b = 6;
	;int n = 4;
	;cout << "4." << endl;
	;while n > 0 {
	;   if n != 3 AND (n < A OR n > B){
	;		n = n – 2
	;		cout << n << endl;
	;	}
	;	else {
	;   	n = n – 1
	;   	cout << n << endl;
	;	}
	;}
	;******************************************
end while
	
	
	
	
    invoke ExitProcess, 0
main ENDP
end main