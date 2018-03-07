@echo off
set projectName=irvineLib
ml /c /Zd /coff %projectName%.asm
Link /SUBSYSTEM:CONSOLE %projectName%.obj
%projectName%.exe