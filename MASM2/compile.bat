@echo off

set projectName=MASM2
ml /c /Zd /coff %projectName%.asm
Link /SUBSYSTEM:CONSOLE %projectName%.obj ../macros/convutil201604.obj ../macros/utility201609.obj
del %projectName%.obj
%projectName%.exe