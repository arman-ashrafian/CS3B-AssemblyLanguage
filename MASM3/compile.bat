@echo off

:: Set Project Name
set projectName=MASM3

:: Assemble 
ml /c /Zd /coff StringLibrary.asm
ml /c /Zd /coff %projectName%.asm

:: LINK Irvine & Bailey
Link /SUBSYSTEM:CONSOLE /out:%projectName%.exe %projectName%.obj ^
StringLibrary.obj ^
..\macros\kernel32.lib ^
..\macros\convutil201604.obj ^
..\macros\utility201609.obj ^
..\..\Irvine\Kernel32.lib ^
..\..\Irvine\Irvine32.lib ^
..\..\Irvine\User32.lib

:: Delete object files
del %projectName%.obj
del StringLibrary.obj

:: RUN
%projectName%.exe