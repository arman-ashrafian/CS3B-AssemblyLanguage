@echo off

:: Set Project Name
set projectName=AW12

:: Assemble 
ml /c /Zd /coff _prompt.asm
ml /c /Zd /coff _arrysum.asm
ml /c /Zd /coff _display.asm
ml /c /Zd /coff %projectName%.asm

:: LINK Irvine & Bailey
Link /SUBSYSTEM:CONSOLE /out:%projectName%.exe %projectName%.obj ^
_prompt.obj ^
_arrysum.obj ^
_display.obj ^
..\macros\kernel32.lib ^
..\macros\convutil201604.obj ^
..\macros\utility201609.obj ^
..\..\Irvine\Kernel32.lib ^
..\..\Irvine\Irvine32.lib ^
..\..\Irvine\User32.lib

:: Delete object files
del %projectName%.obj
del _prompt.obj
del _arrysum.obj
del _display.obj


:: RUN
%projectName%.exe