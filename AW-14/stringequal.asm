;***************************************************************************
; Program Name: StringLibrary.asm
; Programmer:   Arman Ashrafian
; Class:        CS 3B
; Date:         4-24-2018
; Purpose:      String Equal Procedure
;**************************************************************************

; Include Libraries
    INCLUDE ..\..\Irvine\Irvine32.inc  ; Irvine Prototypes
    INCLUDE ..\macros\Bailey.inc       ; Bailey Prototypes

extern String_length@0:Near32
String_length EQU String_length@0

.code 
;***********************************************************************
; String_equals(string1:String,string2:String):boolean
; - compares string 1 & string 2 byte-by-byte
;***********************************************************************
String_equals PROC Near32
    push ebp              ; preserve base pointer
    mov ebp, esp          ; new stack frame
    sub esp, 8            ; make room for two dwords (8 bytes)
    len1 equ [ebp - 4]    ; location on stack to store string 1 length
    len2 equ [ebp - 8]    ; location on stack to store string 2 length
    push ebx              ; preserve base pointer
    push edi              ; preserve edi
    push esi              ; preserve esi
    mov ebx, [ebp + 12]   ; ebx = first string
    mov esi, [ebp + 8]    ; esi = second string

    ; determine length of strings
    push ebx            ; string 1 address
    call String_length
    mov len1, eax       ; len1 = string 1 length
    push esi            ; esi = second string
    call String_length
    mov len2, eax       ; len2 = string 2 length

    ; compare string lengths
    mov eax, len1
    cmp eax, len2
    jne notEqual

    ; compare string byte-by-byte
    mov edi, 0
cmpLoop:
    mov al, [ebx + edi]     ; char at current pos in string 1
    cmp al, [esi + edi]     ; string1[pos] == string2[pos] ?
    jne notEqual
    cmp al, 0               ; check if end of string
    je isEqual
    inc edi                 ; no so increment string index
    jmp cmpLoop

notEqual:
    mov al, 0   ; return false
    jmp return
isEqual:
    mov al, 1
return:
    add esp, 8      ; restore stack used by local variables
    pop esi         ; restore preserved registers
    pop edi
    pop ebx
    pop ebp
    ret             ; return
String_equals ENDP

END