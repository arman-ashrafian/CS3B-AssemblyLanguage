;***************************************************************************
; Program Name: StringLibrary.asm
; Programmer:   Arman Ashrafian
; Class:        CS 3B
; Date:         4-12-2018
; Purpose:      String Library
;**************************************************************************

; Include Libraries
    INCLUDE ..\..\Irvine\Irvine32.inc  ; Irvine Prototypes
    INCLUDE ..\macros\Bailey.inc       ; Bailey Prototypes

.code 

String_length PROC Near32
    push ebp					; preserve base register
    mov ebp,esp					; set new stack frame
    push ebx					; preserve used registers
    push esi 
    mov ebx,[ebp+8]				; set ebx pointer to string
    mov esi,0					; esi = 0
stLoop: 
    cmp byte ptr[ebx+esi],0	    ; reached the end of the string
    je finished				    ; when yes, string input ends here
    inc esi					    ; otherwise, continue to next character`
    jmp stLoop				    ; until a NULL character is hit
finished: 
    mov eax,esi					; returns the length to EAX
    pop esi			            ; restore preserved registers
    pop ebx			            ; restore preserved registers
    pop ebp			            ; restore preserved registers
    ret 4                       ; returns result from eax & clears local stack frame
String_length ENDP              ; end String_length function

;*******************************************************
; String_equals(string1:String,string2:String):boolean
; - compares string 1 & string 2 byte-by-byte
;*******************************************************
String_equals PROC Near32
    push ebp              ; preserve base pointer
    mov ebp, esp          ; new stack frame
    sub esp, 8            ; make room for two dwords (8 bytes)
    len1 equ [ebp - 4]    ; location on stack to store string 1 length
    len2 equ [ebp - 8]    ; location on stack to store string 2 length
    push ebx              ; preserve base pointer
    push edi              ; preserve edi
    push esi              ; preserve esi
    mov ebx, [ebp + 8]    ; ebx = first string
    mov esi, [ebp + 12]   ; esi = second string

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
    ret 8           ; return & clear local stack
String_equals ENDP

;***************************************************************
; String_equalsIgnoreCase(string1:String,string2:String):boolean
; - compares string 1 & string 2 byte-by-byte ignoring case 
;***************************************************************
String_equalsIgnoreCase PROC Near32
    push ebp              ; preserve base pointer
    mov ebp, esp          ; new stack frame
    sub esp, 8            ; make room for two dwords (8 bytes)
    len1 equ [ebp - 4]    ; location on stack to store string 1 length
    len2 equ [ebp - 8]    ; location on stack to store string 2 length
    push ebx              ; preserve base pointer
    push edi              ; preserve edi
    push esi              ; preserve esi
    push ecx              ; preserve ecx
    mov ebx, [ebp + 8]    ; ebx = first string
    mov esi, [ebp + 12]   ; esi = second string

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
    or al, 00100000b        ; convert char to lowercase

    mov cl, [esi + edi]     ; string1[pos] == string2[pos] ?
    or cl, 00100000b        ; convert char to lowercase

    cmp al, cl
    jne notEqual
    cmp len1, edi           ; check if end of string
    je isEqual              ; jump if at end of string
    inc edi                 ; no so increment string index
    jmp cmpLoop             ; loop

notEqual:
    mov al, 0       ; return FALSE
    jmp return
isEqual:
    mov al, 1       ; return TRUE
return:
    add esp, 8      ; restore stack used by local variables
    pop ecx         ; restore preserved registers
    pop esi
    pop edi
    pop ebx
    pop ebp
    ret 8           ; return & clear local stack
String_equalsIgnoreCase ENDP

;***************************************************************
; String_copy(string1:String):String   
; - return address of a newly allocated string of bytes 
;***************************************************************
String_copy PROC Near32
    push ebp					     ; preserve base register
    mov  ebp,esp				     ; set new stack frame
    sub  esp, 4                      ; make room for len1
    len1 equ dword ptr[ebp-4]        ; len1 is local variable on stack
    push ebx					     ; preserve used registers
    push esi     
    push edi     
     
    mov esi, [ebp + 8]               ; esi = string1
    push esi     
    call String_length               ; eax = length of string1
    mov len1, eax                    ; store length in len1
    inc len1                         ; + 1 for null terminator

    invoke memoryallocBailey, len1   ; allocate len1 bytes 
    mov edi, eax                     ; edi = address of new string
    mov ebx, 0                       ; ebx = string index

copyLoop:
    mov al, [esi+ebx]                ; al = string[ebx]
    cmp al, 0                        ; check if at end of string
    je done                          ; TRUE
    mov [edi+ebx], al                ; copy byte in al into new stirng
    inc ebx                          ; string index +1
    jmp copyLoop                     ; loop
done:
    mov byte ptr[edi+ebx], 0         ; add null terminator

    mov eax, edi                     ; eax = address of new string
    add esp, 4                       ; remove local variable
    pop edi                          ; restore registers
    pop esi
    pop ebx
    pop ebp
    ret 4                            ; return & clear stack
String_copy ENDP

END