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
    extern String_length@0:Near32
    extern String_equals@0:Near32
    extern String_equalsIgnoreCase@0:Near32
    extern String_copy@0:Near32

; Symplify External Procedure Names
    String_length equ String_length@0
    String_equals equ String_equals@0
    String_equalsIgnoreCase equ String_equalsIgnoreCase@0
    String_copy equ String_copy@0

; Data Segment
    .data

    color     byte      ?

    newLine   byte      10,0        ; ascii new line
    strTab    byte      "    ",0    ; 4 spaces
    strSpace  byte      " ",0       ; 1 space

    ; menu
    strStars          byte    "***********************************",
                              "***********************************",10,0

    strMASMHead       byte    "**********************************",
                              "**********************************",10,
                              "                            MASM 3",10,
                              "**********************************",
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
    strQuit             byte    "<13> QUIT                      ",0
    strMenuChoicePrompt byte    "Choice (1-13): ",0
    strPromptString1    byte    "String 1: ",0
    strPromptString2    byte    "String 2: ",0
    strCurrently        byte    "currently: ",0
    strNull             byte    "NULL",0
    strHoldInt          byte    10 dup(?)
    strTrue             byte    "TRUE",0
    strFalse            byte    "FALSE",0
    strLengthOfS1       byte    "Length of string 1: ",0
    strLengthOfS2       byte    "Length of string 2: ",0
    strIsEqual          byte    "Strings are equal",0
    strNotEqual         byte    "Strings are not equal",0
    strInvalidInput     byte    "Invalid Option!",0
    strCopied           byte    "String 1 has been copied!",10,
                                "Address: ",0
    strChooseString     byte    "String 1 or string 2? ",0
    strProgramDone      byte    "Program Finished.",10,10,0

    ; user input (bufffer size - 50 bytes)
    strString1          byte   50 dup(?)
    strString2          byte   50 dup(?)
    strMenuChoice       byte   10 dup(?)

    ; current values to display on menu
    strCurrentLength    byte   '0',0,0   ; 3 bytes, initial length 0
    bCurrentEqual       byte    1 ; initially null strings are equal
    bCurrentEqualIC     byte    1 ; initially null strings are equal (ignore case)

    ; testing data
    strMyName byte "Arman",0

.code
;**********************************************
; PrintMenu
; - display menu options
;**********************************************
PrintMenu PROC
    invoke putstring, addr strMASMHead
    
    ; <1> Set String 1
    invoke putstring, addr strSetString1
    invoke putstring, addr strCurrently
    invoke putstring, addr strString1
    call NewLine

    ; <2> Set String 2
    invoke putstring, addr strSetString2
    invoke putstring, addr strCurrently
    invoke putstring, addr strString2
    call NewLine

    ; <3> String Length
    invoke putstring, addr strStringLength
    invoke putstring, addr strCurrently
    invoke putstring, addr strCurrentLength
    call NewLine

    ; <4> String Equal
    invoke putstring, addr strStringEquals
    invoke putstring, addr strCurrently
    .IF bCurrentEqual == 1
        invoke putstring, addr strTrue
    .ELSE
        invoke putstring, addr strFalse
    .ENDIF
    call NewLine

    ; <5> String Equal Ignore Case
    invoke putstring, addr strStringEqualsIC
    invoke putstring, addr strCurrently
    .IF bCurrentEqualIC == 1
        invoke putstring, addr strTrue
    .ELSE
        invoke putstring, addr strFalse
    .ENDIF
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
    invoke putstring, addr strQuit
    call NewLine
    invoke putstring, addr strStars
    call NewLine
    ret
PrintMenu ENDP

;*************************************************
; PromptUser
; - prompt user and store input in strMenuChoice
;*************************************************
PromptUser PROC
    invoke putstring, addr strMenuChoicePrompt
    invoke getstring, addr strMenuChoice, 10
    call NewLine
    ret
PromptUser ENDP

;*************************************************
; NewLine
; - print new line
;*************************************************
NewLine PROC
    invoke putstring, addr newLine
    invoke ascint32, addr strMenuChoice  ; convert menu choice to int (EAX)
    ret 
NewLine ENDP

;**********************************************
; *********** Program Entry Point ************
;**********************************************
_start:

    mov eax, 0                                      ; for OllyDebug
    call GetTextColor
    mov color, al                                   ; store console font color

menuLoop:
    mov eax, cyan
    call SetTextColor

    call Clrscr                                     ; clear screen
    call PrintMenu
loopWithoutMenu:
    mov eax, lightBlue
    call SetTextColor

    call PromptUser

    cmp eax, 1
    je setString1
    cmp eax, 2
    je setString2
    cmp eax, 3
    je stringLength
    cmp eax, 4
    je stringEqual
    cmp eax, 5
    je stringEqualIgnoreCase
    cmp eax, 6
    je stringCopy

    cmp eax, 13
    je quit
    jmp invalidMenuOption

; <1> Set String 1
setString1:
    invoke putstring, addr strPromptString1
    invoke getstring, addr strString1, 50
    jmp done

; <2> Set String 2
setString2:
    invoke putstring, addr strPromptString2
    invoke getstring, addr strString2, 50
    jmp done

; <3> String Length
stringLength:
    invoke putstring, addr strChooseString      ; string 1 or string 2
    invoke getstring, addr strMenuChoice, 10    ; get option
    invoke ascint32, addr strMenuChoice         ; convert menu choice to int
    call NewLine

    cmp eax, 1
    je string1length
    cmp eax, 2
    je string2length
    invoke putstring, addr strInvalidInput
    call NewLine
    jmp stringLength

    string1length:
    push offset strString1
    jmp getLength
    string2length:
    push offset strString2
    getLength:
    call String_length
    invoke intasc32, addr strCurrentLength, eax
    jmp menuLoop

; <4> String Equal
stringEqual:
    push offset strString2                  ; pass string 2 address
    push offset strString1                  ; pass string 1 address
    call String_equals                      ; returns boolean in al
    mov  bCurrentEqual, al
    jmp  menuLoop

; <5> String Equal Ignore Case
stringEqualIgnoreCase:
    push offset strString2                  ; pass string 2 address
    push offset strString1                  ; pass string 1 address
    call String_equalsIgnoreCase            ; returns boolean in al
    mov  bCurrentEqualIC, al                ; mov result to bCurrentEqualIC
    jmp menuLoop
    
stringCopy:
    invoke putstring, addr strCopied
    push offset strString1
    call String_copy
    call WriteHex
    call NewLine
    call NewLine

    jmp loopWithoutMenu


invalidMenuOption:
    invoke putstring, addr strInvalidInput
    call NewLine
    call NewLine
    jmp loopWithoutMenu
done:
    jmp menuLoop

quit:
    invoke putstring, addr strProgramDone

    mov eax, 0
    mov al, color
    call SetTextColor

    invoke ExitProcess, 0

end _start                                          ; end program