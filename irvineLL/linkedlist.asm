
INCLUDE ..\..\Irvine\Irvine32.inc  ; Irvine Prototypes

STRING_MAX = 512
TRUE = 1
FALSE = 0

STRING_STRUCT_SIZE = 8
STRING STRUCT
	stringPtr	512 dup(0)
	nextNod		DWORD 0
STRING ENDS

.data
strMenuOptions1     BYTE "<1> View All Strings",10,10,
                         "<2> Add String",10,
                         "    <a> from Keyboard",10,
                         "    <b> from File",10,10,
                         "<3> Delete String given index #",10,10,0
strMenuOptions2     BYTE "<4> Edit String given index #",10,10,
                         "<5> String search. Returns all strings matching given substring (ignoring case)",10,10,
                         "<6> Save File",10,10,
                         "<7> Quit",10,0



hHeap   		DWORD ?
dwBytes 		DWORD ?
dwFlags 		DWORD HEAP_ZERO_MEMORY

stringPointer	DWORD   ? 			

head 			DWORD 	?
tail 			DWORD 	?
currNod			DWORD 	?
prevNod			DWORD 	?
nextNod 		DWORD 	?
foundVar		BYTE 	FALSE

thisString STRING {}

.code
main PROC
	INVOKE GetProcessHeap
	mov hHeap,eax
	
	mov dwBytes,SIZEOF STRING

	call createNewNode
	mov head,eax
	
	ENTRYPOINT:
	mov eax,tail
	mov currNod,eax
	call PrintMenu
	call PromptUser

	ENDOFPROGRAM: 
	exit
main ENDP

createNewNode PROC
	INVOKE heapAlloc, hHeap, dwFlags, dwBytes
	mov tail,eax
	
	ret
createNewNode ENDP

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

showContents PROC
	mov edi,head
	mov ebx,00h
	
DISPLAYSTART:
	cmp [edi+4],ebx
	je NOMORE
	mov eax,[edi]
	mov prevNod,eax	
	call displayCustomer
		
	add edi,SIZEOF thisCust.lastNam
	mov edi,[edi]
	mov currNod,edi
			
	JMP DISPLAYSTART

NOMORE:
	ret
showContents ENDP

displayCustomer PROC
	call Crlf
	mov edx,OFFSET custIdInfo
	call writeString
	mov edx,edi
	call writeString
	call Crlf
	
	mov edx,OFFSET custLNameInfo
	call writeString
	add edi,SIZEOF thisCust.IdNum
	mov edx,edi
	call writeString
	call Crlf
	
	mov edx,OFFSET spacer
	call writeString
	call Crlf
	
	ret
displayCustomer ENDP

getData PROC
	call Clrscr
	mov edx,OFFSET newCustTitle
	call writeString
	call Crlf
	call Crlf

	mov edx,OFFSET custIdMsg
	call writeString
	
	mov edx,OFFSET thisCust.idNum
	mov ecx,ID_MAX
	call readString
	
	mov edx,OFFSET custLastMsg
	call writeString
	
	mov edx,OFFSET thisCust.lastNam
	mov ecx,LASTNAME_MAX
	call readString
	
	call createNewNode
	mov eax,tail
	mov thisCust.nextNod,eax
	
	ret
getData ENDP

moveToHeap PROC
	mov esi,OFFSET thisCust
	mov edi,currNod
	
	INVOKE Str_copy, ADDR thisCust.idNum, edi
	
	add edi,SIZEOF thisCust.idNum
	INVOKE Str_copy, ADDR thisCust.lastNam, edi
	
	add edi,SIZEOF thisCust.lastNam
	mov eax,(CUSTOMER PTR [esi]).nextNod
	
	mov [edi],eax

	ret
moveToHeap ENDP

getSearch PROC
	call ClrScr
	mov ebx,00h
	mov edi,head
	cmp [edi+sumOfEntryFields],ebx
	je  NOTHING
	
	mov edx,OFFSET custSearchMsg
	call writestring
	call Crlf

	mov edx,OFFSET getSearchId
	call writeString
	
	mov edx,OFFSET searchId
	mov ecx,ID_MAX
	call readString
	
	call searchList
	jmp endproc
	
NOTHING:
	mov foundVar,FALSE
	mov edx,OFFSET displayNothing
	call writeString
				
ENDPROC:
	call crlf
	ret
getSearch ENDP

searchList PROC
	call ClrScr
	mov edi,head
	mov ebx,00h
	mov prevNod,edi
	
SEARCHLOOP:
	mov eax,[edi]
	INVOKE Str_compare, ADDR searchId, edi
	je  FOUND
	mov prevNod,edi
	add edi,sumOfEntryFields
	mov edi,[edi]
	cmp [edi+sumOfEntryFields],ebx
	je NOTFOUND
	jmp SEARCHLOOP
	
FOUND:
	mov foundVar,TRUE
	mov currNod,edi
	Call Crlf
	mov edx,OFFSET foundMsg
	call writeString
	call displayCustomer	
	jmp AWAYWITHYOU
		
	NOTFOUND:
	mov foundVar,FALSE
	call Crlf
	mov edx,OFFSET notFoundMsg
	call writeString
	call Crlf
	
AWAYWITHYOU: ret
searchList ENDP

update PROC
	mov dl,0
	mov dh,6
	call Gotoxy

	mov edx,OFFSET newInfoMsg
	call WriteString
	call Crlf
	
	mov edx,OFFSET custIdMsg
	call writeString
	
	mov edx,OFFSET thisCust.idNum
	mov ecx,ID_MAX
	call readString
	
	mov edx,OFFSET custLastMsg
	call writeString
	
	mov edx,OFFSET thisCust.lastNam
	call readString
	
	mov edi,currNod
	INVOKE Str_copy, ADDR thisCust.idNum, edi
	
	add edi,SIZEOF thisCust.idNum
	INVOKE Str_copy, ADDR thisCust.lastNam, edi
	
	add edi,SIZEOF thisCust.lastNam
	
	call crlf
	mov edx,OFFSET custUpdtMsg
	call writestring
	call crlf

	ret
update ENDP

deleteNode	PROC
	mov edi,currNod
	add edi,sumOfEntryFields
	mov eax,[edi]
	mov nextNod,eax
	
	mov edi,currNod
	.if(edi == head)
		mov head,eax
	.endif
	
	mov edi,prevNod
	add edi,sumOfEntryFields
	mov eax,nextNod
	mov [edi],eax
	
	mov edi,currNod
	INVOKE heapFree, hHeap, dwFlags, edi
	
	call Crlf
	mov edx,OFFSET deletedMsg
	call writeString
	call Crlf

	ret
deleteNode ENDP
end main