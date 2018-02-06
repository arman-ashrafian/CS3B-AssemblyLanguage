set projectName=main
ml /c /Zd /coff /Fl %projectName%.asm
Link /SUBSYSTEM:CONSOLE %projectName%.obj
%projectName%.exe