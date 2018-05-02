@echo off

:: Set Project Name
set projectName=MASM4

:: Assemble 
ml /c /Zd /coff StringLibrary.asm
ml /c /Zd /coff %projectName%.asm

:: LINK Irvine & Bailey
Link /SUBSYSTEM:CONSOLE /out:%projectName%.exe %projectName%.obj ^
StringLibrary.obj ^
..\..\Irvine\Kernel32.lib ^
..\..\Irvine\Irvine32.lib ^
..\..\Irvine\User32.lib

:: Delete object files
del %projectName%.obj
del StringLibrary.obj

:: RUN
%projectName%.exe