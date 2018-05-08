;***************************************************************************
; Program Name: MASM4.asm
; Programmer:   Arman Ashrafian
; Class:        CS 3B
; Date:         5-10-2018
; Purpose:      Text Editor, store strings in linked list
;**************************************************************************

; Dot Directives
.486
.model flat, STDCALL
.stack 4096
option casemap :none

; Prototypes
GetFileSize         PROTO STDCALL :DWORD, :DWORD
OpenClipboard       PROTO STDCALL :DWORD
GetClipboardData    PROTO STDCALL :DWORD
GlobalSize          PROTO STDCALL :DWORD
CloseClipboard      PROTO STDCALL
GetProcessHeap      PROTO STDCALL

; Include Libraries
INCLUDE ..\..\Irvine\Irvine32.inc  ; Irvine Prototypes
INCLUDE ..\..\Irvine\Macros.inc    ; Irvine Macros
INCLUDE ..\macros\Bailey.inc       ; Bailey Macros

; External Procedures
extern String_copy@0:Near32
extern String_length@0:Near32
String_copy equ String_copy@0
String_length equ String_length@0

; HEAP SIZE
HEAP_START = 2000000     ; 2MB
HEAP_MAX  = 400000000   ; 400MB


; Linked List Node
NODE_SIZE = 8 ; 8 bytes
Node Struct 
    strPtr DWORD ?
    next   DWORD ?
Node Ends

; ---------------------------------------- DATA -----------------------------------------
.data

hHeap               HANDLE ?    ; Heap Handle
hDefaultHeap        HANDLE ?    ; Defulat Heap Handle

head 			    DWORD  ?    ; Linked List pointer

hClipboard          DWORD ?    ; clipboard handle

strMenuHeading      BYTE "                MASM 4 TEXT EDITOR                ", 10, 13,
                         "	 Data Structure Memory Consumption: ",0
strMenuOptions1     BYTE "<1> View All Strings",10,10,
                         "<2> Add String",10,
                         "    <a> from Keyboard",10,
                         "    <b> from File",10,
                         "    <c> from Clipboard",10,10,
                         "<3> Delete String given index #",10,10,0
strMenuOptions2     BYTE "<4> Edit String given index #",10,10,
                         "<5> String search. Returns all strings matching given substring (ignoring case)",10,10,
                         "<6> Save File",10,10,
                         "<7> Quit",10,0
strMenuChoicePrompt BYTE  "Choice (1-7): ",0
strMenuChoice       BYTE 3 dup(?)

strStringInputBuff  BYTE 512 dup(?)

; File Stuff
strFilename         BYTE  20 dup(?)
fileHandle          DWORD ?
fileSize            DWORD ?
fileBuffPtr         DWORD ?

linkedListCount     DWORD 0
dMemConsumption     DWORD 0

; -------------------------------------- CODE -------------------------------------------
.code
;*****************************************************************************************
; ******************************** Program Entry Point ***********************************
;*****************************************************************************************
_start:

    mov eax, 0                                  ; for OllyDebug
    INVOKE HeapCreate, 0, HEAP_START, HEAP_MAX  ; create heap
    mov hHeap, eax
    mov head, 0                                 ; linked list head points to null

    invoke GetProcessHeap                       ; default heap handle
    mov hDefaultHeap, eax

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
    call DisplayStrings
    jmp MainLoopWithMenu
AddString:
    mWrite "From keyboard <a>, file <b>, or clipboard <c>: "
    mReadString strMenuChoice
    ; Input From Keyboard
    .IF(strMenuChoice == 'a')
        call GetInputFromKeyboard
    ; Input From File
    .ELSEIF(strMenuChoice == 'b')
        call Crlf
        mWrite "Filename: "
        mReadString strFilename
        call GetInputFromFile
    ; Input From Clipboard
    .ELSEIF(strMenuChoice == 'c')
        call GetInputFromClipboard
    .ELSE
        mWrite "Invalid Input!"
        call Crlf
        jmp AddString
    .ENDIF
    jmp MainLoopWithMenu
DeleteString:
    mWrite "Index: "
    call ReadDec
    push eax
    call DeleteStringFromLinkedList
    jmp MainLoopWithMenu
EditString:
    mWrite "Index: "
    call ReadDec
    mov ebx, eax
    call Crlf
    mWrite "New String: "
    mReadString strStringInputBuff
    push ebx
    call EditStringByIndex
    jmp MainLoopWithMenu
StringSearch:
    mWrite "Search: "
    mReadString strStringInputBuff
    call SearchForString
    jmp MainLoopWithMenu
SaveFile:
    mWrite "Filename: "
    mReadString strFilename
    call SaveStringsToFile
    jmp MainLoopWithMenu
InvalidInput:
    mWrite "Invalid Input!"
    call Crlf
    jmp MainLoopNoMenu
Quit:
    invoke ExitProcess, 0

; ----------------------------------- PROCEDURES ----------------------------------------

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
; - prompts user for input, appends to linked list
;*************************************************
    mov al, 10
    call WriteChar
    mWrite "Input: "
    mReadString strStringInputBuff
    push offset strStringInputBuff
    call String_copy
    push eax
    call AppendStringToLinkedList

    ret
GetInputFromKeyboard ENDP

;*************************************************
AppendStringToLinkedList PROC
; - add string to end of list & add string length
;   and node size to total memory consumption
;*************************************************
    push ebp                    ; create stack frame
    mov ebp, esp

    push ebx                    ; preserve 
    push edx

    inc linkedListCount         ; increment linked list count

    ; args
    string equ [ebp + 8]        ; address of string to append

    push string
    call String_length          ; get string length
    inc eax                     ; +1 for null
    add eax, NODE_SIZE          ; add size of node 
    add dMemConsumption, eax    ; add to total memory consumption

    mov ebx, head       ; EBX = head
    mov edx, string     ; EDX = pointer to string
    .IF(ebx == 0)       ; EMPTY LIST ?
        push ebx
        push edx
        INVOKE HeapAlloc, hHeap, HEAP_ZERO_MEMORY, NODE_SIZE
        pop edx
        pop ebx
        mov head, eax
        mov (Node PTR [eax]).strPtr, edx
        mov (Node PTR [eax]).next, 0
    .ELSE
        push ebx    ; save registers because HeapAlloc will overwrite
        push edx
        INVOKE HeapAlloc, hHeap, HEAP_ZERO_MEMORY, NODE_SIZE
        pop edx     ; restore registers
        pop ebx
    traversalLoop:  ; traverse to end of linked list
        cmp (Node PTR [ebx]).next, 0
        je reachedEnd
        mov ebx, (Node PTR [ebx]).next
        jmp traversalLoop
    reachedEnd:
        mov (Node PTR [ebx]).next, eax      ; last node points to new node
        mov (Node PTR [eax]).strPtr, edx    ; new node stores the string
        mov (Node PTR [eax]).next, 0      ; new node points to NULL
    .ENDIF

    pop edx
    pop ebx
    pop ebp
    ret 4
AppendStringToLinkedList ENDP

;*************************************************
DeleteStringFromLinkedList PROC
; - delete by index
;*************************************************
    push ebp                                ; new stack frame
    mov ebp, esp

    push eax                                ; preserve registers
    push ebx
    push ecx
    push edx

    index equ [ebp+8]                       ; param

    mov eax, index
    mov ebx, linkedListCount
    .IF(eax < 0 || eax >= ebx || ebx == 0)  ; check if index is negative,
        jmp quit                            ; index is bigger than size of list,
    .ENDIF                                  ; and list is empty

    ; EAX = index, EBX = *head, ECX = counter
    mov ebx, head
    mov ecx, 1      ; start at 1 because checking index 0 below
    .IF(eax == 0)                                                   ; delete first node
        mov edx, (Node PTR [ebx]).next
        mov head, edx

        push (Node PTR [ebx]).strPtr                                ; calculate memory consumption of node
        call String_length
        inc eax
        sub dMemConsumption, eax
        sub dMemConsumption, NODE_SIZE

        invoke HeapFree, hDefaultHeap, 0, (Node PTR [ebx]).strPtr   ; delete string ptr
        invoke HeapFree, hHeap, 0, ebx                              ; delete node
        dec linkedListCount
        jmp quit
    .ENDIF
traversalLoop:
    mov edx, ebx                                                    ; EDX = previous node
    mov ebx, (Node PTR [ebx]).next                                  ; EBX = next node
    .IF(eax == ecx)                                                 ; reached node to delete ?
        mov ecx, (Node PTR [ebx]).next                              ; ECX = node after node to be deleted
        mov (Node PTR [edx]).next, ecx                              ; point previous node to ECX

        push (Node PTR [ebx]).strPtr                                ; calculate memory consumption
        call String_length
        inc eax
        sub dMemConsumption, eax
        sub dMemConsumption, NODE_SIZE

        invoke HeapFree, hDefaultHeap, 0, (Node PTR [ebx]).strPtr   ; delete string
        invoke HeapFree, hHeap, 0, ebx                              ; delete node
        dec linkedListCount
        jmp quit
    .ENDIF
    inc ecx
    jmp traversalLoop

quit:
    pop edx
    pop ecx
    pop ebx
    pop eax
    pop ebp
    ret 4
DeleteStringFromLinkedList ENDP

;*************************************************
DisplayStrings PROC
; - loops through linked list and displays index 
;   and string
;*************************************************
    mov ebx, head   ; EBX = head
    cmp ebx, 0      ; check if list is empty
    je done
    mov eax, 0      ; index counter
traversalLoop:
    call WriteDec
    mWrite " - "
    inc eax
    mov edx, (Node PTR [ebx]).strPtr
    call WriteString
    push eax
    mov al, 10
    call WriteChar
    pop eax
    mov ebx, (Node PTR [ebx]).next
    .IF(ebx == 0)
        jmp done
    .ENDIF
    jmp traversalLoop
done:
    call WaitMsg
    ret
DisplayStrings ENDP

;*************************************************
GetInputFromFile PROC
; - opens file, gets file size, allocates memory
;   for the buffer, reads file into buffer,
;   appends to linked list then deletes the buffer.
;*************************************************
    ; open (or create) file
    invoke CreateFile,ADDR strFilename,GENERIC_READ,0,0,\
        OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0

    ; check if file does not exist
    .IF(eax == -1)
        mWrite "File doe not exist!"
        call Crlf
        jmp quit
    .ENDIF

    ; get filesize into EAX
    mov fileHandle, eax 
    invoke GetFileSize, eax, 0
    inc eax ; make room for null
    mov fileSize,eax

    ; allocate memory on heap for file buffer
    INVOKE HeapAlloc, hHeap, HEAP_ZERO_MEMORY, eax
    mov fileBuffPtr, eax

    mov edx, eax        ; EDX = offset of file buffer
    mov eax, fileHandle
    mov ecx, fileSize
    call ReadFromFile   ; Read file into buffer

    ; add null terminator
    mov edx, fileBuffPtr
    mov ecx, fileSize
    mov byte ptr [edx+ecx], 0 

    push fileBuffPtr
    call AddBufferContentsToList
    invoke HeapFree, hHeap, 0, fileBuffPtr  ; FREE the buffer
quit:
    call WaitMsg
    invoke CloseHandle,fileHandle           ; close file
    ret
GetInputFromFile ENDP

;*************************************************
AddBufferContentsToList PROC
; - add contents of buffer to linked list
; - create new string on every new line
;*************************************************
    push ebp                ; new stack frame
    mov ebp, esp

    push ecx                ; preserve registers
    push edx
    push ebx

    mov edx, [ebp+8]        ; EDX = *buffer

outerLoop:
    mov ecx, 0                          ; count = 0
innerLoop:
    mov al, [edx+ecx]                   ; AL = *buffer[ecx]
    mov strStringInputBuff[ecx], al     ; buffer[count] = AL
    inc ecx                             ; count++
    .IF(al == 13)                       ; reached end of line ?
        add edx, ecx
        inc edx
        mov strStringInputBuff[ecx],0   ; add null terminator
        push offset strStringInputBuff  
        call String_copy                ; copy string into 
        push eax
        call AppendStringToLinkedList   ; append buffer to list
        jmp outerLoop                   ; start over
    .ELSEIF(al == 0)
        add edx, ecx
        inc edx
        mov strStringInputBuff[ecx],0   ; add null terminator
        push offset strStringInputBuff  
        call String_copy                ; copy string into 
        push eax
        call AppendStringToLinkedList   ; append buffer to list
        jmp done
    .ELSE
        jmp innerLoop
    .ENDIF
done:
    pop ebx
    pop edx
    pop ecx
    pop ebp
    ret 4
AddBufferContentsToList ENDP

;*************************************************
GetInputFromClipboard PROC
; - get data in clipboard and append buffer to 
;   to list
;*************************************************
    push ebp                    ; new stack frame
    mov ebp, esp

    invoke OpenClipboard, NULL  ; returns clipboard handle in EAX
    invoke GetClipboardData, 1  ; get data as text
    mov hClipboard, eax         ; save handle
    mov edx, hClipboard
    call Crlf
    call WriteString            ; display contents of clipboard buffer
    call Crlf

    push hClipboard
    call AddBufferContentsToList; append clipboard buffer to list

    invoke CloseClipboard       ; close clipboard buffer

    call WaitMsg                ; display wait msg
    pop ebp
    ret
GetInputFromClipboard ENDP

;*************************************************
EditStringByIndex PROC
; - edit string given index #, replace with string
;   in strStringInputBuff
;*************************************************
    push ebp                        ; new stack frame
    mov ebp, esp

    index equ [ebp+8]               ; param

    push eax                        ; preserve registers
    push ebx
    push ecx
    push edx

    ; - traverse through list until reached the given node
    ; - delete the string strPtr points to
    ; - copy string in strStringInputBuffer
    ; - set nodes strPtr to the new string

    mov ecx, 0          ; ECX (counter) = 0
    mov ebx, head       ; EBX = head
    mov edx, index      ; EDX = index of node to edit
traversalLoop:
    .IF(ecx == edx)     ; counter == index ?
        ; subtract o.g string length from memory consumption
        push (Node PTR [ebx]).strPtr
        call String_length
        inc eax
        sub dMemConsumption, eax
        invoke HeapFree, hDefaultHeap, 0, (Node PTR [ebx]).strPtr   ; delete string

        push ebx                                                    ; save EBX (pointer to node to edit)
        ; add new string length to memory consumption
        push offset strStringInputBuff
        call String_length
        inc eax
        add dMemConsumption, eax

        push offset strStringInputBuff
        call String_copy                                            ; EAX = address of new string
        pop ebx                                                     ; restore EBX
        mov (Node PTR [ebx]).strPtr, eax
        jmp quit
    .ENDIF
    mov ebx, (Node PTR [ebx]).next
    inc ecx
    jmp traversalLoop
quit:
    call WaitMsg
    pop edx
    pop ecx
    pop ebx
    pop eax
    pop ebp
    ret 4
EditStringByIndex ENDP

;*************************************************
SaveStringsToFile PROC
; - traverse linked list and write each string
;   to file on a new line
;*************************************************
    mov edx, offset strFilename
    call CreateOutputFile

    .IF(eax == INVALID_HANDLE_VALUE)
        mWrite "Could not create output file"
        jmp quit
    .ENDIF
    mov fileHandle, eax

    mov ecx, 0
    mov ebx, head
    mov edx, linkedListCount
traversalLoop:
    .IF(ecx == linkedListCount)
        jmp quit
    .ENDIF

    push (Node PTR [ebx]).strPtr        ; get buffer size w/o null
    call String_length

    push ecx                            ; save counter

    mov ecx, eax                        ; write to file
    mov edx, (Node PTR [ebx]).strPtr
    mov eax, fileHandle
    call WriteToFile

    mov ebx, (Node PTR [ebx]).next
    pop ecx                             ; restore counter
    inc ecx
    jmp traversalLoop

quit:
    ret
SaveStringsToFile ENDP

;*************************************************
SearchForString PROC
; - traverses linked list and keeps checking if 
;   string contains the substring in 
;   strStringInputBuff.
;*************************************************
    ;int 3
    mov eax, 0
    mov ecx, 0         ; ECX (counter) = 0
    mov ebx, head      ; EBX = head
traversalLoop:
    .IF(ebx == 0)
        jmp quit
    .ENDIF
    push ebx
    push (Node PTR [ebx]).strPtr
    push offset strStringInputBuff
    call StringContains
    pop ebx
    .IF(al == 1)
        mov edx, (Node PTR [ebx]).strPtr
        call WriteString
        call Crlf
    .ENDIF
    mov ebx, (Node PTR [ebx]).next
    inc ecx
    jmp traversalLoop
quit:
    call WaitMsg
    ret
SearchForString ENDP

;*************************************************
StringContains PROC
; - StringContains(string1, string2)
; - returns bool in AL if string 1 contains 
;   string 2.
;*************************************************
    push ebp                    ; new stack frame
    mov ebp, esp

    push ebx                    ; preserve registers
    push ecx
    push edx
    push esi

    sub esp, 12                 ; local variables
    string1Len equ [ebp-4]
    string2Len equ [ebp-8]
    lengthDiff equ [ebp-12]

    string1 equ [ebp+12]        ; params
    string2 equ [ebp+8]

    push string1                ; get string lengths
    call String_length
    mov string1Len, eax
    push string2
    call String_length
    mov string2Len, eax

    .IF(string1Len < eax)
        mov al, 0
        jmp quit
    .ENDIF

    mov eax, string1Len
    sub eax, string2Len
    mov lengthDiff, eax         ; calc string length difference
    
    mov eax, string2Len
    dec eax
    mov string2Len, eax         ; substract 1 from string2Len to use as loop stopper

    mov esi, 0                  ; string 1 index
    mov ecx, 0                  ; string 2 index
    mov ebx, string1
    mov edx, string2
L1:
    .IF(esi == lengthDiff)
        mov al, 0
        jmp quit
    .ENDIF
    mov al, [ebx+esi]
    or al, 00100000b            ; convert to lowercase
    mov ah, [edx+ecx]
    or ah, 00100000b            ; convert to lowercase
    .IF(al != ah)
        inc esi
        mov ecx, 0
    .ELSEIF(ecx == string2Len)
        mov al, 1
        jmp quit
    .ELSE
        inc esi
        inc ecx
    .ENDIF
    jmp L1
quit:
    add esp, 12
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop ebp
    ret 8
StringContains ENDP

end _start ; end program
