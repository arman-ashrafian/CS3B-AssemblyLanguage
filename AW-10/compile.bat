@echo off
set projectName=main
ml /c /Zd /coff %projectName%.asm
Link /SUBSYSTEM:CONSOLE /out:%projectName%.exe %projectName%.obj  ..\..\Irvine\User32.Lib  \masm32\lib\kernel32.lib  ..\..\Irvine\Irvine32.lib
del %projectName%.obj
%projectName%.exe