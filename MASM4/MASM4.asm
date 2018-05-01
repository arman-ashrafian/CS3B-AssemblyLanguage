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
    INCLUDE ..\..\Irvine\Macros.inc    ; Irvine Macros
    INCLUDE ..\macros\Bailey.inc       ; Bailey Prototypes

; ---- DATA ----
.data

strMenuHeading      BYTE "                MASM 4 TEXT EDITOR                ", 10, 13,
                         "	 Data Structure Memory Consumption: ",0
strMenuOptions1     BYTE "<1> View All Strings",10,10,
                         "<2> Add String",10,
                         "    <a> from Keyboard",10,
                         "    <b> from File (input.txt)",10,10,
                         "<3> Delete String given index #",10,10,0
strMenuOptions2     BYTE "<4> Edit String given index #",10,10,
                         "<5> String search. Returns all strings matching given substring (ignoring case)",10,10,
                         "<6> Save File",10,10,
                         "<7> Quit",10,0
strMenuChoicePrompt BYTE  "Choice (1-7): ",0
strMenuChoice       BYTE 3 dup(?)

dMemConsumption     DWORD 0




; ---- CODE ----
.code

;**********************************************
PrintMenu PROC
; Clear screen & display menu
;**********************************************
    call Clrscr
    invoke putstring, addr strMenuHeading
    mov eax, dMemConsumption
    call WriteDec
    mWrite " bytes"
    call Crlf
    invoke putstring, addr strMenuOptions1
    invoke putstring, addr strMenuOptions2
    ret
PrintMenu ENDP

;*************************************************
PromptUser PROC
; - prompt user and store int input in EAX
;*************************************************
    invoke putstring, addr strMenuChoicePrompt
    invoke getstring, addr strMenuChoice, 2
    call Crlf
    invoke ascint32, addr strMenuChoice  ; convert menu choice to int (EAX)
    ret
PromptUser ENDP

;**********************************************
; *********** Program Entry Point ************
;**********************************************
_start:

    mov eax, 0                   ; for OllyDebug

MainLoopWithPrompt:
    call PrintMenu
MainLoopNoPrompt:
    call PromptUser

    cmp eax, 1
    je ViewAllStrings
    cmp eax, 2
    je AddString
    cmp eax, 3
    je DeleteString
    cmp eax, 4
    je EditString
    cmp eax, 5
    je StringSearch
    cmp eax, 6
    je SaveFile
    cmp eax, 7
    je Quit
    ; ELSE
    jmp InvalidInput


ViewAllStrings:
    ; TODO
AddString:
    ; TODO
DeleteString:
    ; TODO
EditString:
    ; TODO
StringSearch:
    ; TODO
SaveFile:
    ; TODO
InvalidInput:
    mWrite "Invalid Input!"
    call Crlf
    jmp MainLoopNoPrompt
Quit:
    invoke ExitProcess, 0

end _start ; end program