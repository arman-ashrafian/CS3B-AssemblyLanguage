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
    ret 8           ; return & clear local stack
String_equals ENDP

;***********************************************************************
; String_equalsIgnoreCase(string1:String,string2:String):boolean
; - compares string 1 & string 2 byte-by-byte ignoring case 
;***********************************************************************
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

;***********************************************************************
; String_copy(string1:String):String   
; - return address of a newly allocated string of bytes 
;***********************************************************************
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

;***********************************************************************
; String_substring_1(string1:String,beginIndex:int,endIndex:int):String   
; - return address of a newly allocated string of bytes 
;***********************************************************************
String_substring_1 PROC Near32
    ;int 3
    push ebp
    mov ebp, esp    ; new stack frame

    ; local variables
    sub esp, 4              ; allocate 4 bytes
    strLen equ [ebp - 4]    ; store string length

    ; preserve registers
    push ebx    ; EBX - string address
    push ecx    ; ECX - beginning index
    push edx    ; EDX - ending index
    push esi    ; ESI - length of substring
    push edi    ; EDI - addr ptr of for substring 

    ; arguments
    string equ [ebp + 16]   ; string1   
    mov ebx, string         ; EBX = string address
    begin  equ [ebp + 12]   ; beginning index
    mov ecx, begin          ; ECX = beginning index
    endIn  equ [ebp + 8]    ; ending index
    mov edx, endIn          ; EDX = ending index
    
    ; check if end > begin
    .IF ecx > edx
        mov eax, 0
        jmp backToDriver
    .ENDIF

    ; get length of string
    push string
    call String_length
    mov  strLen, eax

    cmp eax, 0           ; check if string is empty
    je backToDriver
    .IF endIn > eax      ; check if end > length
        mov eax, 0
        jmp backToDriver
    .ENDIF

    mov esi, endIn
    sub esi, begin                  ; ESI now stores length of substring
    inc esi                         ; add room for null terminator
    invoke memoryallocBailey, esi   ; allocate room for substring (EAX)
    mov edi, eax                    ; edi = ptr to new string
    mov esi, 0                      ; esi = string index

copyLoop:
    add esi, begin                   ; add begin index to OG string pointer
    mov al, [ebx+esi]                ; al = string[ebx]
    cmp esi, endIn                   ; check string index = end index
    je loopdone                      ; TRUE
    sub esi, begin                   ; sub begin index from substring pointer
    mov [edi+esi], al                ; copy byte in al into new stirng
    inc esi                          ; string index +1
    jmp copyLoop                     ; loop    
loopdone:
    mov byte ptr[edi+esi], 0         ; add null terminator
    mov eax, edi                     ; eax = substring address
backToDriver:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop ebp
    add esp, 4
    ret 4                            ; clean stack

String_substring_1 ENDP

;***********************************************************************
; String_substring_2(string1:String,beginIndex:int):String  
; - return address of a newly allocated string of bytes 
;***********************************************************************
String_substring_2 PROC Near32
    push ebp
    mov ebp, esp    ; new stack frame

    ; local variables
    sub esp, 4              ; allocate 4 bytes
    strLen equ [ebp - 4]    ; store string length

    ; preserve registers
    push ebx    ; EBX - string address
    push ecx    ; ECX - beginning index
    push esi    ; ESI - length of substring
    push edi    ; EDI - addr ptr of for substring 

    ; arguments
    string equ [ebp + 12]   ; string1   
    mov ebx, string         ; EBX = string address
    begin  equ [ebp + 8]    ; beginning index
    mov ecx, begin          ; ECX = beginning index

    ; get length of string
    push string
    call String_length
    mov  strLen, eax

    cmp eax, 0           ; check if string is empty
    je backToDriver
    .IF begin > eax      ; check if begin > length
        mov eax, 0
        jmp backToDriver
    .ENDIF

    mov esi, strLen
    sub esi, begin                  ; ESI now stores length of substring
    inc esi                         ; add room for null terminator
    invoke memoryallocBailey, esi   ; allocate room for substring (EAX)
    mov edi, eax                    ; edi = ptr to new string
    mov esi, 0                      ; esi = string index

copyLoop:
    add esi, begin                   ; add begin index to OG string pointer
    mov al, [ebx+esi]                ; al = string[ebx]
    cmp esi, strLen                  ; check string index = end index
    je loopdone                      ; TRUE
    sub esi, begin                   ; sub begin index from substring pointer
    mov [edi+esi], al                ; copy byte in al into new stirng
    inc esi                          ; string index +1
    jmp copyLoop                     ; loop    
loopdone:
    mov byte ptr[edi+esi], 0         ; add null terminator
    mov eax, edi                     ; eax = substring address
backToDriver:
    pop edi
    pop esi
    pop ecx
    pop ebx
    pop ebp
    add esp, 4
    ret 4                            ; clean stack

String_substring_2 ENDP

;***********************************************************************
; String_charAt(string1:String,position:int):char (byte)
; - returns char in AL
;***********************************************************************
String_charAt PROC Near32
    push ebp
    mov ebp, esp

    ; arguments
    string  equ [ebp+12]
    pos     equ [ebp+8]

    ; preserver register
    push ebx

    push string
    call String_length

    cmp eax, 0
    jmp backToDriver
    .IF pos > eax
        mov eax, 0
        jmp backToDriver
    .ENDIF

    mov eax, 0
    mov ebx, string
    mov al, [ebx+pos]

backToDriver:
    pop ebx
    pop ebp
    ret 8
String_charAt ENDP

;***********************************************************************
; String_startsWith_1(string1:String,strPrefix:String, pos:int):boolean
; - return true if string1 contains strPrefix starting at offset pos
;***********************************************************************
END