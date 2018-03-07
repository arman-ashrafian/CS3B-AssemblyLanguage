; Testing Irvine Library

includelib ..\..\Irvine\Kernel32.Lib
includelib ..\..\Irvine\User32.Lib
includelib ..\..\Irvine\Irvine32.lib

INCLUDE ..\..\Irvine\Irvine32.inc

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