; DisplaySum Procedure		(_display.asm)

INCLUDE ..\..\Irvine\Irvine32.inc

.code
;-----------------------------------------------------
DisplaySum PROC

; Displays the sum on the console.
; Receives:
;	ptrPrompt		; offset of prompt string
;	theSum		; the array sum (DWORD)
; Returns: nothing
;-----------------------------------------------------

theSum		EQU [ebp+12]
ptrPrompt	EQU [ebp+8]

    push 	ebp
    mov 	ebp, esp
    push	eax
    push	edx

    mov	edx,ptrPrompt	; pointer to prompt
    call	WriteString
    mov	eax,theSum
    call	WriteInt		; display EAX
    call	Crlf

    pop	edx
    pop	eax
    pop ebp

    ret		; restore the stack
DisplaySum ENDP
END