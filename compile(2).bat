set projectName=masm3
\masm32\bin\ml /c /Zi /Fl /coff string1.asm
\masm32\bin\ml /c /Zi /Fl /coff string2.asm
\masm32\bin\ml /c /Zi /Fl /coff %projectName%.asm

\masm32\bin\Link /debug /SUBSYSTEM:CONSOLE /ENTRY:start  /out:%projectName%.exe %projectName%.obj string1.obj string2.obj  \masm32\lib\kernel32.lib ..\..\macros\convutil201604.obj ..\..\macros\utility201609.obj  
%projectName%.exe
