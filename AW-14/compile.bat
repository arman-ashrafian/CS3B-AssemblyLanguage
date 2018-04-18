@echo off

:: Set Project Name
set projectName=main

:: Assemble 
ml /c /Zd /coff stringequal.asm
ml /c /Zd /coff %projectName%.asm

:: LINK Irvine & Bailey
Link /SUBSYSTEM:CONSOLE /out:%projectName%.exe %projectName%.obj ^
stringequal.obj ^
..\macros\kernel32.lib ^
..\macros\convutil201604.obj ^
..\macros\utility201609.obj ^
..\..\Irvine\Kernel32.lib ^
..\..\Irvine\Irvine32.lib ^
..\..\Irvine\User32.lib

:: Delete object files
del stringequal.obj
del %projectName%.obj

:: RUN
%projectName%.exe