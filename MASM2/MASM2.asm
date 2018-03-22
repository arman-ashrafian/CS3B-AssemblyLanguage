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
    newLine   byte      10,0                                                 ; ascii new line
    strHeader byte      "     Name: Arman Ashrafian", 10,
                      "    Class: CS 3B Assembly Language", 10,            ; lab heading
                      "      Lab: MASM2", 10,
                      "     Date: 3/27/2018", 10, 0
    strTab    byte      "    ",0                                             ; 4 spaces
    strSpace  byte      " ",0                                                ; 1 space
    strFinish byte      "Thanks for using my program... Have a nice life",10,10,0

    ; Prompts/Output
    strEnterFirstNum  byte "Enter your first number:  ",0   ; Prompt for first number
    strEnterSecondNum byte "Etner your second number: ",0   ; Prompt for second number
    strSumIs          byte "The sum is: ",0                 ; Display sum
    strDifferenceIs   byte "The difference is: ",0          ; Display difference
    strProductIs      byte "The product is: ",0             ; Display product
    strQuotientIs     byte "The quotient is: ",0            ; Display quotient
    strRemainderIs    byte "The remainder is: ",0           ; Display remainder
    
    ; Error Messages
    strDivideByZero   byte "You cannot divide by 0. Thus, there is no quotient or remainder",10,0
    strInvalidInput   byte "INVALID NUMERIC STRING. RE-ENTER VALUE",10,0
    strOverflow       byte "OVERFLOW OCCURED. RE-ENTER VALUE",10,0
    strOverflowAdd    byte "OVERFLOW OCCURED WHEN ADDING",10,0
    strOverflowSub    byte "OVERFLOW OCCURED WHEN SUBTRACTING",10,0
    strOverflowMul    byte "OVERFLOW OCCURED WHEN MULTIPLYING",10,0
    strOverflowConv   byte "OVERFLOW OCCURED WHEN CONVERTING",10,0

    ; Input Data
    dLimitNum         dword 11          ; limit for inputting numeric string
    dLimitAlpha       dword 79          ; limit for inputting alpha-numeric string
    dCharCount        dword 0           ; number of character in the bBuffer input buffer
    bBuffer           byte  11 dup(0)   ; buffer for numeric input (length = 11 bytes)
    bBackspaceChar    byte  8           ; ASCII backspace
    bDeleteChar       byte  20          ; ASCII delete
    bCurrentInput     byte  0           ; current input field (0 for 1st num, 1 for 2nd num)
    dNum1             dword ?           ; store num1
    dNum2             dword ?           ; store num2
    strResult         byte  11 dup(?)   ; result of arithmetic

.code
;**********************************************
; GetInput
; - gets user input and stores it in bBuffer
;**********************************************
GetInput PROC
    mov dCharCount, 0       ; set count to 0
    mov ecx, 11             ; set loop counter to size of buffer + 1
    mov ebx, 0              ; clear ebx

clearBuffer:
    mov ebx, ecx            ; move loop counter to ebx
    dec ebx                 ; ebx - 1 
    mov bBuffer[bx], 0      ; clear buffer starting from the end
    loop clearBuffer        ; loop if ecx > 0
    
getChar:    
    mov eax, 0              ; clear eax for getch
    call getch              ; get character and store in AL

    cmp al, 13              ; AL == 'ENTER' ?
    je endInput             ; jump to end if true

    cmp al, 8               ; AL == 'BACKSPACE' ?
    je backspace            ; jump if true

    mov edx, dCharCount     ; EDX = number of character in buffer
    cmp edx, 10             ; EDX == buffer limit - 1 (10 bytes) ?
    jl stillSpace           ; jump if buffer still has room 
    jmp getChar             ; jump back to beginning if no more room

stillSpace:
    mov ebx, dCharCount     ; EBX = buffer character count
    mov bBuffer[bx], al     ; mov character into buffer
    invoke putch, al        ; echo character to console
    inc dCharCount          ; increment character counter
    jmp getChar             ; jump back to beginning

backspace:                  ; Handle Backspace
    cmp dCharCount, 0       ; buffer empty ?
    je getChar              ; jump back to beginning if true (prevents deleting prompt)
    call Backspace
    dec dCharCount
    jmp getChar

endInput:
    cmp bBuffer, 0          ; check if buffer is empty
    je endProgram           ; end program if true
    mov bBuffer[10], 0      ; else: add null terminator to end of buffer
    
    ret
GetInput ENDP

;*********************************************************************
; Backspace
; - prints ASCII codes 8, 34, 8 to do delete a char and correctly
;   position cursor
;*********************************************************************
Backspace PROC
    invoke putch, 8
    invoke putch, 32
    invoke putch, 8
    ret
Backspace ENDP

;*********************************************************************
; NewLine
; - prints new line
;*********************************************************************
NewLine PROC
    invoke putstring, addr newLine
    ret
NewLine ENDP

;*********************************************************************
; CheckInput
; - ensures the ascint32 function properly converts string -> int.
; - options:
;            succesful: result in EAX
;    invalid character: carry flag set
;             overflow: overflow flag set
;*********************************************************************
CheckInput PROC
    jc invalidChar                          ; invalid character in string
    jo convOverflow                         ; conversion results in overflow
    jmp convOk                              ; okay, leave procedure
invalidChar:
    invoke putstring, addr strInvalidInput  ; print invalid input
    jmp decideJmp
convOverflow:
    invoke putstring, addr strOverflow      ; print overflow 
decideJmp:
    cmp bCurrentInput, 0                    ; currentInput == 1st ?
    je firstInput                           ; jmp back to first if true
    jmp secondInput                         ; jmp to second otherwise
convOk:
    ret
CheckInput ENDP

;*********************************************************************
; PrintResult
; - converts EAX to string and prints with newline
;*********************************************************************
PrintResult PROC
    invoke intasc32, addr strResult, eax
    invoke putstring, addr strResult
    call NewLine
    ret
PrintResult ENDP

_start:
    mov eax, 0                                      ; for OllyDebug
    invoke putstring, addr strHeader                ; print header
    invoke putstring, addr newLine                  ; print new line

; Top of the input loop
inputTop:
firstInput:
    ; Enter First Number
    mov bCurrentInput, 0
    invoke putstring, addr strEnterFirstNum
    call GetInput
    call NewLine
    invoke ascint32, addr bBuffer
    call CheckInput
    mov dNum1, eax
secondInput:
    ; Enter Second Number
    mov bCurrentInput, 1
    invoke putstring, addr strEnterSecondNum
    call GetInput
    call NewLine
    invoke ascint32, addr bBuffer
    call CheckInput
    mov dNum2, eax

    ; Addition
    add eax, dNum1
    jo additionOverflow
    invoke putstring, addr strSumIs
    call PrintResult
    jmp subtraction
additionOverflow:
    invoke putstring, addr strOverflowAdd

subtraction:
    ; Subtraction
    mov eax, dNum1
    sub eax, dNum2
    jo subtractionOverflow
    invoke putstring, addr strDifferenceIs
    call PrintResult
    jmp multiplication
subtractionOverflow:
    invoke putstring, addr strOverflowSub

multiplication:
    ; Multiplication
    mov eax, dNum1
    imul dNum2
    jo multiplicationOverflow
    invoke putstring, addr strProductIs
    call PrintResult
    jmp division
multiplicationOverflow:
    invoke putstring, addr strOverflowMul

division:
    ; Division
    mov eax, dNum1
    cdq
    cmp dNum2, 0
    je divideByZero
    idiv dNum2

    invoke putstring, addr strQuotientIs
    call PrintResult
    invoke putstring, addr strRemainderIs
    mov eax, edx
    call PrintResult
    jmp after
divideByZero:
    invoke putstring, addr strDivideByZero
    jmp after

after:
    call NewLine
    jmp inputTop


endProgram:
    call NewLine                                    ; print newline x2
    call NewLine
    invoke putstring, addr strFinish                ; print program finished
    call NewLine                                    ; print new line

    invoke ExitProcess, 0
end _start                                          ; end program
