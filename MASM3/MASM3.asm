;***************************************************************************
; Program Name: MASM3.asm
; Programmer:   Arman Ashrafian
; Class:        CS 3B
; Date:         4-12-2018
; Purpose:      String Library Driver
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
    extern String_substring_1@0:Near32
    extern String_substring_2@0:Near32
    extern String_charAt@0:Near32
    extern String_startsWith_1@0:Near32
    extern String_startsWith_2@0:Near32
    extern String_endsWith@0:Near32

; Symplify External Procedure Names
    String_length           equ String_length@0
    String_equals           equ String_equals@0
    String_equalsIgnoreCase equ String_equalsIgnoreCase@0
    String_copy             equ String_copy@0
    String_substring_1      equ String_substring_1@0
    String_substring_2      equ String_substring_2@0
    String_charAt           equ String_charAt@0
    String_startsWith_1     equ String_startsWith_1@0
    String_startsWith_2     equ String_startsWith_2@0
    String_endsWith         equ String_endsWith@0

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
    strStringCharAt     byte    "<9>  String_charAt             ",0
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
    strIndexBeginPrompt byte    "Begin: ",0
    strIndexEndPrompt   byte    "End: ",0
    strIndex            byte    "Index: ",0
    strOffset           byte    "Offset: ",0
    strProgramDone      byte    "Program Finished.",10,10,0

    ; user input (bufffer size - 50 bytes)
    strString1          byte   "NULL", 46 dup(?)
    strString2          byte   "NULL", 46 dup(?)
    strMenuChoice       byte   10 dup(?)

    ; current values to display on menu
    strCurrentLength    byte   '0',0,0     ; 3 bytes, initial length 0
    bCurrentEqual       byte    0          ; initially null strings are not equal
    bCurrentEqualIC     byte    0          ; initially null strings are not equal (ignore case)
    strCopiedString     byte    50 dup(?)  ; copied string
    dCopiedHex          dword   ?          ; copied string address (hex)
    dSub1Hex            dword   ?          ; substring 1 address (hex)
    dSub2Hex            dword   ?          ; substring 2 address (hex)
    bCharAt             byte    ?          ; current CharAt value
    bStartsWith1        byte    ?          ; bool value for startsWith1 procedure
    bStartsWith2        byte    ?          ; bool value for startsWith2 procedure
    bEndsWith           byte    ?          ; bool value for endsWith procedure
    strEmptyString      byte    ?          ; empty string

    ; last menu option
    dLastMenuOption     dword   ?

.code
;**********************************************
; DisplayChange(String:dword,MenuOp:dword)
; - display current value in menu
;**********************************************
DisplayChange PROC
    push ebp
    mov ebp, esp

    ; preserve registers
    push ebx
    push ecx

    ; arguments
    string equ [ebp+12]
    menuOp equ [ebp+8]

    mov ebx, menuOp
    mov ecx, dLastMenuOption

    .IF ebx == ecx
        mov eax, lightRed
        call SetTextColor
        invoke putstring, string
        mov eax, cyan
        call SetTextColor
    .ELSE
        invoke putstring, string
    .ENDIF

    pop ecx
    pop ebx
    pop ebp
    ret 8
DisplayChange ENDP


;**********************************************
; PrintMenu
; - display menu options
;**********************************************
PrintMenu PROC
    invoke putstring, addr strMASMHead
    mov ebx, dLastMenuOption

    ; <1> Set String 1
    invoke putstring, addr strSetString1
    invoke putstring, addr strCurrently
    push offset strString1
    push 1
    call DisplayChange
    call NewLine

    ; <2> Set String 2
    invoke putstring, addr strSetString2
    invoke putstring, addr strCurrently
    push offset strString2
    push 2
    call DisplayChange
    call NewLine

    ; <3> String Length
    invoke putstring, addr strStringLength
    invoke putstring, addr strCurrently
    push offset strCurrentLength
    push 3
    call DisplayChange
    call NewLine

    ; <4> String Equal
    invoke putstring, addr strStringEquals
    invoke putstring, addr strCurrently
    .IF bCurrentEqual == 1
        push offset strTrue
    .ELSE
        push offset strFalse
    .ENDIF
    push 4
    call DisplayChange
    call NewLine

    ; <5> String Equal Ignore Case
    invoke putstring, addr strStringEqualsIC
    invoke putstring, addr strCurrently
    .IF bCurrentEqualIC == 1
        push offset strTrue
    .ELSE
        push offset strFalse
    .ENDIF
    push 5
    call DisplayChange
    call NewLine

    ; <6> Copy String
    invoke putstring, addr strStringCopy
    .IF ebx == 6 
        mov eax, lightRed
        call SetTextColor
        invoke putch, '&'
        mov eax, dCopiedHex
        call WriteHex
        mov eax, cyan
        call SetTextColor
        mov eax, dCopiedHex
    .ELSE
        invoke putch, '&'
        mov eax, dCopiedHex
        call WriteHex
    .ENDIF
    invoke putch, ' '
    invoke putch, ' '
    invoke putstring, addr strCurrently
    .IF eax != 0
        push eax
    .ELSE
        push offset strEmptyString
    .ENDIF
    push 6
    call DisplayChange
    call NewLine

    ; <7> Substring 1
    invoke putstring, addr strStringSub1
    .IF ebx == 7
        mov eax, lightRed
        call SetTextColor
        invoke putch, '&'
        mov eax, dSub1Hex
        call WriteHex
        mov eax, cyan
        call SetTextColor
        mov eax, dSub1Hex
    .ELSE
        invoke putch, '&'
        mov eax, dSub1Hex
        call WriteHex
    .ENDIF
    invoke putch, ' '
    invoke putch, ' '
    invoke putstring, addr strCurrently
    .IF eax != 0
        push eax
    .ELSE
        push offset strEmptyString
    .ENDIF
    push 7
    call DisplayChange
    call NewLine

    ; <8> Substring 2
    invoke putstring, addr strStringSub2
    .IF ebx == 8
        mov eax, lightRed
        call SetTextColor
        invoke putch, '&'
        mov eax, dSub2Hex
        call WriteHex
        mov eax, cyan
        call SetTextColor
        mov eax, dSub2Hex
    .ELSE
        invoke putch, '&'
        mov eax, dSub2Hex
        call WriteHex
    .ENDIF
    invoke putch, ' '
    invoke putch, ' '
    invoke putstring, addr strCurrently
    .IF eax != 0
        push eax
    .ELSE
        push offset strEmptyString
    .ENDIF
    push 8
    call DisplayChange
    call NewLine

    ; <9> Char at
    invoke putstring, addr strStringCharAt
    invoke putstring, addr strCurrently
    .IF bCharAt == 0
        invoke putstring, addr strNull
    .ELSE
        .IF ebx == 9
            mov eax, lightRed
            call SetTextColor
            invoke putch, bCharAt
            mov eax, cyan
            call SetTextColor
        .ELSE
            invoke putch, bCharAt
        .ENDIF
    .ENDIF
    call NewLine

    ; <10> String starts 1
    invoke putstring, addr strStringStarts1
    invoke putstring, addr strCurrently
    .IF bStartsWith1 == 0
        push offset strFalse
    .ELSE
        push offset strTrue
    .ENDIF
    push 10
    call DisplayChange
    call NewLine

    ; <11> String starts 2
    invoke putstring, addr strStringStarts2
    invoke putstring, addr strCurrently
    .IF bStartsWith2 == 0
        push offset strFalse
    .ELSE
        push offset strTrue
    .ENDIF
    push 11
    call DisplayChange
    call NewLine

    ; <12> String ends with
    invoke putstring, addr strStringEndWith
    invoke putstring, addr strCurrently 
    .IF bEndsWith == 0
        push offset strFalse
    .ELSE
        push offset strTrue
    .ENDIF
    push 12
    call DisplayChange
    call NewLine

    ; <13> QUIT
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
    invoke ascint32, addr strMenuChoice  ; convert menu choice to int (EAX)
    ret
PromptUser ENDP

;*************************************************
; NewLine
; - print new line
;*************************************************
NewLine PROC
    invoke putstring, addr newLine
    ret 
NewLine ENDP

;**********************************************
; *********** Program Entry Point ************
;**********************************************
_start:

    mov eax, 0                   ; for OllyDebug
    call GetTextColor
    mov color, al                ; store console font color

menuLoop:
    mov eax, cyan
    call SetTextColor

    call Clrscr                  ; clear screen
    call PrintMenu
loopWithoutMenu:
    mov eax, lightBlue
    call SetTextColor

    call PromptUser
    mov dLastMenuOption, eax

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
    cmp eax, 7
    je stringSub1
    cmp eax, 8
    je stringSub2
    cmp eax, 9
    je charAt
    cmp eax, 10
    je startsWith1
    cmp eax, 11
    je startsWith2
    cmp eax, 12
    je endsWith

    cmp eax, 13
    je quit
    jmp invalidMenuOption

; <1> Set String 1
setString1:
    invoke putstring, addr strPromptString1
    invoke getstring, addr strString1, 50
    jmp menuLoop

; <2> Set String 2
setString2:
    invoke putstring, addr strPromptString2
    invoke getstring, addr strString2, 50
    jmp menuLoop

; <3> String Length
stringLength:
    invoke putstring, addr strChooseString      ; string 1 or string 2
    invoke getstring, addr strMenuChoice, 10    ; get option
    invoke ascint32, addr strMenuChoice         ; convert menu choice to int
    call NewLine

    .IF eax == 1
        push offset strString1
    .ELSEIF eax == 2
        push offset strString2
    .ELSE
        invoke putstring, addr strInvalidInput
        call NewLine
        jmp stringLength
    .ENDIF

    call String_length
    invoke intasc32, addr strCurrentLength, eax
    jmp menuLoop

; <4> String Equal
stringEqual:
    push offset strString1                  ; pass string 1 address
    push offset strString2                  ; pass string 2 address
    call String_equals                      ; returns boolean in al
    mov  bCurrentEqual, al
    jmp  menuLoop

; <5> String Equal Ignore Case
stringEqualIgnoreCase:
    push offset strString1                  ; pass string 1 address
    push offset strString2                  ; pass string 2 address
    call String_equalsIgnoreCase            ; returns boolean in al
    mov  bCurrentEqualIC, al                ; mov result to bCurrentEqualIC
    jmp menuLoop

; <6> Copy String
stringCopy:
    invoke putstring, addr strCopied
    push offset strString1
    call String_copy
    mov  dCopiedHex, eax
    jmp menuLoop

; <7> String Sub 1
stringSub1:
    invoke putstring, addr strChooseString      ; string 1 or string 2
    invoke getstring, addr strMenuChoice, 10    ; get option
    invoke ascint32, addr strMenuChoice         ; convert menu choice to int
    call NewLine

    .IF eax == 1
        push offset strString1
    .ELSEIF eax == 2
        push offset strString2
    .ELSE
        invoke putstring, addr strInvalidInput
        call NewLine
        jmp stringSub1
    .ENDIF

    invoke putstring, addr strIndexBeginPrompt
    invoke getstring, addr strHoldInt, 10
    invoke ascint32, addr strHoldInt
    mov ebx, eax
    call NewLine
    invoke putstring, addr strIndexEndPrompt
    invoke getstring, addr strHoldInt, 10
    invoke ascint32, addr strHoldInt
    
    push ebx
    push eax
    call String_substring_1
    .IF eax == 0                                ; check EAX == 0 (error)
        call NewLine
        call NewLine
        invoke putstring, addr strInvalidInput
        call NewLine
        call NewLine
        jmp loopWithoutMenu
    .ENDIF
    mov dSub1Hex, eax                          ; if no error save addr of substring
    jmp menuLoop

; <8> Substring 2
stringSub2:
    invoke putstring, addr strChooseString      ; string 1 or string 2
    invoke getstring, addr strMenuChoice, 10    ; get option
    invoke ascint32, addr strMenuChoice         ; convert menu choice to int
    call NewLine

    .IF eax == 1
        push offset strString1
    .ELSEIF eax == 2
        push offset strString2
    .ELSE
        invoke putstring, addr strInvalidInput
        call NewLine
        jmp stringSub2
    .ENDIF

    invoke putstring, addr strIndexBeginPrompt
    invoke getstring, addr strHoldInt, 10
    invoke ascint32, addr strHoldInt

    push eax
    call String_substring_2
    .IF eax == 0                                ; check EAX == 0 (error)
        call NewLine
        call NewLine
        invoke putstring, addr strInvalidInput
        call NewLine
        call NewLine
        jmp loopWithoutMenu
    .ENDIF
    mov dSub2Hex, eax                          ; if no error save addr of substring
    jmp menuLoop

; <9> CharAt
charAt:
    invoke putstring, addr strIndex
    invoke getstring, addr strHoldInt, 10
    invoke ascint32, addr strHoldInt

    push offset strString1
    push eax
    call String_charAt
    mov  bCharAt, al
    jmp menuLoop

; <10> Starts With 1
startsWith1:
    invoke putstring, addr strOffset
    invoke getstring, addr strHoldInt, 10
    invoke ascint32, addr strHoldInt

    push offset strString1
    push offset strString2
    push eax
    call String_startsWith_1
    mov bStartsWith1, al
    jmp menuLoop

; <11> Starts With 2
startsWith2:
    push offset strString1
    push offset strString2
    call String_startsWith_2
    mov bStartsWith2, al
    jmp menuLoop

; <12> Ends With
endsWith:
    push offset strString1
    push offset strString2
    call String_endsWith
    mov bEndsWith, al
    jmp menuLoop

invalidMenuOption:
    invoke putstring, addr strInvalidInput
    call NewLine
    call NewLine
    jmp loopWithoutMenu

quit:
    invoke putstring, addr strProgramDone

    mov eax, 0
    mov al, color
    call SetTextColor

    invoke ExitProcess, 0

end _start ; end program