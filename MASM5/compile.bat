@echo off

:: Set Project Name
set projectName=BubbleSort

:: Assemble 
ml /c /Zd /coff %projectName%.asm

:: LINK Irvine
Link /SUBSYSTEM:CONSOLE /out:%projectName%.exe %projectName%.obj ^
..\..\Irvine\Kernel32.lib ^
..\..\Irvine\Irvine32.lib ^
..\..\Irvine\User32.lib

gcc -std=c++11 -c -m32 -o main.obj masm5.cpp
g++ -m32 -o output.exe %projectName%.obj main.obj

:: Delete object files
del %projectName%.obj
del main.obj

:: RUN
output.exe