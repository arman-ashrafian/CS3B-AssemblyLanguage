; Playing wit procedures

.386
.model flat, stdcall
.stack 4096
option casemap :none

INCLUDE ..\..\Irvine\Irvine32.inc
INCLUDE ..\..\Irvine\macros.inc

.data
str1 BYTE "Sample string, in color",0dh,0ah,0

.code
main PROC

	mov	ax,yellow + (blue * 16)
	call	SetTextColor
	
	mov	edx,OFFSET str1
	call	WriteString
	
	call	GetTextColor
	call	DumpRegs

	exit
main ENDP

END main