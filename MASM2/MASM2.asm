;***************************************************************************
; Program Name: MASM2.asm
; Programmer: Arman Ashrafian
; Class: CS 3B
; Date: 3-27-2018
; Purpose:	
;  Write program to input numeric information from the keyboard, add,
;  subtract, multiply and divide, as well as check for overflow and/or
;  invalid numeric information
;**************************************************************************

; Dot Directives
    .486
    .model flat, stdcall
    .stack 4096
    option casemap :none

; Function Prototypes
    ExitProcess             proto, dwExitCode:dword
    putstring               proto near32 stdcall, lpStringToPrint:dword 
    ascint32                proto near32 stdcall, lpStringToConvert:dword
    intasc32                proto near32 stdcall, lpStringToHold:dword, dVal:dword
    getche                  proto near32 stdcall  ;returns character in the AL register
     getch                   proto near32 stdcall  ;returns character in the AL register
    putch                   proto near32 stdcall, bChar:byte

; Include Libraries
    include \masm32\include\kernel32.inc
    include \masm32\include\masm32.inc
    includelib \masm32\lib\kernel32.lib
    includelib \masm32\lib\masm32.lib

; Data Segment
    .data
    newLine   db      10,0                                                 ; ascii new line
    strHeader db      "     Name: Arman Ashrafian", 10,
                      "    Class: CS 3B Assembly Language", 10,            ; lab heading
                      "      Lab: MASM2", 10,
                      "     Date: 3/27/2018", 10, 0
    strTab    db      "    ",0                                             ; 4 spaces
    strSpace  db      " ",0                                                ; 1 space
    strFinish db      "Thanks for using my program... Have a nice life",10,10,0

    ; Prompts/Output
    strEnterFirstNum  db "Enter your first number:  ",0   ; Prompt for first number
    strEnterSecondNum db "Etner your second number: ",0   ; Prompt for second number
    strSumIs          db "The sum is: ",0                 ; Display sum
    strDifferenceIs   db "The difference is: ",0          ; Display difference
    strProductIs      db "The product is: ",0             ; Display product
    strQuotientIs     db "The quotient is: ",0            ; Display quotient
    strRemainderIs    db "The remainder is: ",0           ; Display remainder
    
    ; Error Messages
    strDivideByZero   db "You cannot divide by 0. Thus, there is no quotient or remainder",10,0
    strInvalidInput   db "INVALID NUMERIC STRING. RE-ENTER VALUE",10,0
    strOverflow       db "OVERFLOW OCCURED. RE-ENTER VALUE",10,0
    strOverflowAdd    db "OVERFLOW OCCURED WHEN ADDING",10,0
    strOverflowSub    db "OVERFLOW OCCURED WHEN SUBTRACTING",10,0
    strOverflowMul    db "OVERFLOW OCCURED WHEN MULTIPLYING",10,0
    strOverflowConv   db "OVERFLOW OCCURED WHEN CONVERTING",10,0

    ; Input Data
    dLimitNum         dw 11             ; limit for inputting numeric string
    dLimitAlpha       dw 79             ; limit for inputting alpha-numeric string
    dCharCount        dw 0              ; number of character in the dBuffer input buffer
    fake              db 11 dup("B")    
    dBuffer           db 11 dup("A")    ; buffer for numeric input (length = 11 bytes)

.code
;**********************************************
; GetInput
; - gets user input and stores it in dBuffer
;**********************************************
GetInput PROC
    mov dCharCount, 0 ; set count to 0
    mov ecx, 11       ; set loop counter to size of buffer + 1
    mov ebx, 0        ; clear ebx

clearBuffer:
    mov ebx, ecx        ; move loop counter to ebx
    dec ebx             ; ebx - 1 
    mov dBuffer[bx], 0  ; clear buffer starting from the end
    loop clearBuffer    ; loop if ecx > 0

getChar:
    mov eax, 0          ; clear eax for getch
    call getch          ; get character and store in AL

    cmp al, 13          ; AL == 'ENTER' ?
    je endInput         ; jump to end if true

    cmp al, 8           ; AL == 'BACKSPACE' ?
    je backspace

    mov edx, dCharCount ; EDX = number of character in buffer
    cmp edx, dLimitNum  ; EDX == buffer limit (11 bytes) ?
    jl stillSpace       ; jump if buffer still has room 
    jmp getChar         ; jump back to beginning if no more room



backspace:
    ; TODO

endInput:
    ; TODO
    
    ret
GetInput ENDP


_start:
    mov eax, 0                                      ; for OllyDebug

    call GetInput

    invoke putstring, addr strHeader                ; print header
    invoke putstring, addr newLine                  ; print new line

; Top of the input loop
inputTop:
    invoke putstring, addr strEnterFirstNum

    invoke ExitProcess, 0
end _start                                          ; end program
