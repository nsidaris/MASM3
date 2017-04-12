set projectName=MASM3
\masm32\bin\ml /c /Zi /Fl /coff String1.asm
\masm32\bin\ml /c /Zi /Fl /coff %projectName%.asm

\masm32\bin\Link /debug /SUBSYSTEM:CONSOLE /ENTRY:start  /out:%projectName%.exe %projectName%.obj  String1.obj  \masm32\lib\kernel32.lib ..\macros\convutil201604.obj ..\macros\utility201609.obj  
%projectName%.exe
pause