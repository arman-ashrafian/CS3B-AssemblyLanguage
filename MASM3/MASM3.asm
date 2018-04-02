;***************************************************************************
; Program Name: MASM3.asm
; Programmer:   Arman Ashrafian
; Class:        CS 3B
; Date:         4-12-2018
; Purpose:      String Library
;**************************************************************************

; Dot Directives
    .486
    .model flat, STDCALL
    .stack 4096
    option casemap :none

; Include Libraries
    INCLUDE ..\..\Irvine\Irvine32.inc  ; Irvine Prototypes
    INCLUDE ..\macros\Bailey.inc       ; Bailey Prototypes

; External Procedures
    extern String_length@0:PROC
    extern String_equals@0:PROC
    extern String_equalsIgnoreCase@0:PROC

; Symplify External Procedure Names
    String_length equ String_length@0
    String_equals equ String_equals@0
    String_equalsIgnoreCase equ String_equalsIgnoreCase@0

; Data Segment
    .data

    newLine   byte      10,0                                                 ; ascii new line
    strTab    byte      "    ",0                                             ; 4 spaces
    strSpace  byte      " ",0                                                ; 1 space

    ; menu
    strStars          byte   "***********************************",10,0
    strMASMHead       byte    "**********************************",10,
                              "              MASM 3              ",10,
                              "**********************************",10,0
    strSetString1       byte    "<1>  Set String 1              ",0
    strSetString2       byte    "<2>  Set String 2              ",0
    strStringLength     byte    "<3>  String_length             ",0
    strStringEquals     byte    "<4>  String_equals             ",0
    strStringEqualsIC   byte    "<5>  String_equalsIgnoreCase   ",0
    strStringCopy       byte    "<6>  String_copy               ",0
    strStringSub1       byte    "<7>  String_substring_1        ",0
    strStringSub2       byte    "<8>  String_substring_2        ",0
    strStringCharAt     byte    "<9>  String_chartAt            ",0
    strStringStarts1    byte    "<10> String_startsWith_1       ",0
    strStringStarts2    byte    "<11> String_startsWith_2       ",0
    strStringEndWith    byte    "<12> String_endWith            ",0
    strMenuChoicePrompt byte    "Choice (1-12): ",0
    strPromptString1    byte    "String 1: ",0
    strPromptString2    byte    "String 2: ",0
    strCurrently        byte    "currently: ",0
    strNull             byte    "NULL",0
    strHoldInt          byte    10 dup(?)
    strTrue             byte    "True",0
    strFalse            byte    "False",0

    ; user input (bufffer size - 50 bytes)
    strString1          byte   50 dup(?)
    strString2          byte   50 dup(?)
    strMenuChoice       byte   10 dup(?)

    ; testing data
    strMyName byte "Arman",0

.code
;**********************************************
; PrintMenu
; - display menu options
;**********************************************
PrintMenu PROC
    invoke putstring, addr strMASMHead
    invoke putstring, addr strSetString1
    call NewLine
    invoke putstring, addr strSetString2
    call NewLine
    invoke putstring, addr strStringLength
    call NewLine
    invoke putstring, addr strStringEquals
    call NewLine
    invoke putstring, addr strStringEqualsIC
    call NewLine
    invoke putstring, addr strStringCopy
    call NewLine
    invoke putstring, addr strStringSub1
    call NewLine
    invoke putstring, addr strStringSub2
    call NewLine
    invoke putstring, addr strStringCharAt
    call NewLine
    invoke putstring, addr strStringStarts1
    call NewLine
    invoke putstring, addr strStringStarts2
    call NewLine
    invoke putstring, addr strStringEndWith 
    call NewLine
    invoke putstring, addr strStars
    call NewLine
    invoke putstring, addr strMenuChoicePrompt
    invoke getstring, addr strMenuChoice, 10
    call NewLine
    ret
PrintMenu ENDP

NewLine PROC
    invoke putstring, addr newLine
    ret 
NewLine ENDP

;**********************************************
; *********** Program Entry Point ************
;**********************************************
_start:

    mov eax, 0                                      ; for OllyDebug

menuLoop:
    call Clrscr                                     ; clear screen
    call PrintMenu
    invoke ascint32, addr strMenuChoice             ; convert menu choice to int

    cmp eax, 1
    je setString1
    cmp eax, 2
    je setString2

setString1:
    invoke putstring, addr strPromptString1
    invoke getstring, addr strString1, 50
    jmp done
setString2:
    invoke putstring, addr strPromptString2
    invoke getstring, addr strString2, 50
    jmp done
done:
    jmp menuLoop


    invoke ExitProcess, 0

end _start                                          ; end program
