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
INCLUDE ..\macros\Bailey.inc

; External Procedures
extern String_copy@0:Near32
extern String_length@0:Near32
String_copy equ String_copy@0
String_length equ String_length@0

; HEAP SIZE
HEAP_START = 2000000     ; 2MB
HEAP_MAX  = 400000000   ; 4MB


; Linked List Node
NODE_SIZE = 8 ; 8 bytes
Node Struct 
    strPtr DWORD ?
    next   DWORD ?
Node Ends

; ---- DATA ----
.data

hHeap               HANDLE ?    ; Heap Handle

head 			    DWORD  ?    ; Linked List pointer

strMenuHeading      BYTE "                MASM 4 TEXT EDITOR                ", 10, 13,
                         "	 Data Structure Memory Consumption: ",0
strMenuOptions1     BYTE "<1> View All Strings",10,10,
                         "<2> Add String",10,
                         "    <a> from Keyboard",10,
                         "    <b> from File",10,10,
                         "<3> Delete String given index #",10,10,0
strMenuOptions2     BYTE "<4> Edit String given index #",10,10,
                         "<5> String search. Returns all strings matching given substring (ignoring case)",10,10,
                         "<6> Save File",10,10,
                         "<7> Quit",10,0
strMenuChoicePrompt BYTE  "Choice (1-7): ",0
strMenuChoice       BYTE 3 dup(?)
strStringInputBuff  BYTE 512 dup(?)
strFilename         BYTE 20 dup(?)
fileHandle          HANDLE ?

linkedListCount     DWORD 0
dMemConsumption     DWORD 0

; ---- CODE ----
.code
;**********************************************
; *********** Program Entry Point ************
;**********************************************
_start:

    mov eax, 0   ; for OllyDebug
    INVOKE HeapCreate, 0, HEAP_START, HEAP_MAX  ; create heap
    mov hHeap, eax
    mov head, 0     ; head points to null

MainLoopWithMenu:
    call PrintMenu
MainLoopNoMenu:
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
    mWrite "From keyboard <a> or file <b>: "
    mReadString strMenuChoice
    ; Input From Keyboard
    .IF(strMenuChoice == 'a')
        call GetInputFromKeyboard
    ; Input From File
    .ELSEIF(strMenuChoice == 'b')
        call Crlf
        mWrite "Filename: "
        mReadString strFilename
    .ELSE
        mWrite "Invalid Input!"
        call Crlf
        jmp AddString
    .ENDIF
    jmp MainLoopWithMenu

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
    jmp MainLoopNoMenu
Quit:
    invoke ExitProcess, 0

; --------- Procedures ----------

;**********************************************
PrintMenu PROC
; Clear screen & display menu
;**********************************************
    call Clrscr
    mWriteString strMenuHeading
    mov eax, dMemConsumption
    call WriteDec
    mWrite " bytes"
    call Crlf
    mWriteString strMenuOptions1
    mWriteString strMenuOptions2
    ret
PrintMenu ENDP

;*************************************************
PromptUser PROC
; - prompt user and store int input in EAX
;*************************************************
    mWriteString strMenuChoicePrompt
    call ReadInt
    call Crlf
    ret
PromptUser ENDP

;*************************************************
GetInputFromKeyboard PROC
;*************************************************
    mov al, 10
    call WriteChar
    mReadString strStringInputBuff

    push offset strStringInputBuff
    call String_length
    inc eax

    add dMemConsumption, eax
    push offset strStringInputBuff
    call String_copy
    push eax
    call AppendStringToLinkedList

    ret
GetInputFromKeyboard ENDP

;*************************************************
AppendStringToLinkedList PROC
; - add string to end of list
;*************************************************
    push ebp        ; create stack frame
    mov ebp, esp

    push ebx        ; preserve 
    push edx

    ; args
    string equ [ebp + 8]   ; string to append

    mov ebx, head       ; EBX = head
    mov edx, string     ; EDX = pointer to string
    .IF(ebx == 0) ; EMPTY LIST
        INVOKE HeapAlloc, hHeap, HEAP_ZERO_MEMORY, NODE_SIZE
        mov head, eax
        mov (Node PTR [eax]).strPtr, edx
        mov (Node PTR [eax]).next, 0
        inc linkedListCount
    .ELSE
        INVOKE HeapAlloc, hHeap, HEAP_ZERO_MEMORY, NODE_SIZE
        mov (Node PTR [eax]).strPtr, edx
        mov (Node PTR [eax]).next, ebx
        mov head, eax
        inc linkedListCount
    .ENDIF

    pop edx
    pop ebx
    pop ebp
    ret 4
AppendStringToLinkedList ENDP


;*************************************************
ReadLine PROC
; - read byte-by-byte until reach end of line
;*************************************************
    mov ecx, 0      ; counter
readLoop:
    call ReadChar   ; reads char into AL
    call WriteChar
    .IF(al == 13)   ; end of line
        jmp done
    .ELSE
        mov strStringInputBuff[ecx],al
    .ENDIF
    jmp readLoop 
done:
    ret
ReadLine ENDP

end _start ; end program