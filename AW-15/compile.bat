@echo off

:: Set Project Name
set projectName=main

:: Assemble 
ml /c /Zd /coff %projectName%.asm

:: LINK Irvine
Link /SUBSYSTEM:CONSOLE /out:%projectName%.exe %projectName%.obj ^
..\..\Irvine\Kernel32.lib ^
..\..\Irvine\Irvine32.lib ^
..\..\Irvine\User32.lib

:: Delete object file
del %projectName%.obj

:: RUN
%projectName%.exe