;******************************************************************************************
;Name: 		Daniel Crawford
;Program: 	proj3Driver_string1.asm
;Class: 	CSCI 2160-001
;Lab: 		Proj3Driver_String1
;Date: 		October 20, 2016
;Purpose:
;		To test methods a set of given test values for string1.asm and report returned
;			values.
;******************************************************************************************
	.486										;X86 INSTRUCTION SET
	.MODEL flat									;USE ABSOLUTE ADDRESSES
	.STACK 100h									;SET ASIDE 256 BYTES FOR THE STACK 

	ExitProcess PROTO Near32 stdcall, dwExitCode:dword
	intasc32 	PROTO Near32 stdcall, lpStringToHold:dword, dVal:dword
	ascint32 	PROTO Near32 stdcall, lpStringOfNumericChars:dword
	getch	 	PROTO Near32 stdcall
	getche		PROTO Near32 stdcall
	putch 		PROTO Near32 stdcall, bChar:byte
	putstring 	PROTO Near32 stdcall, lpStringToPrint:dword
	getstring 	PROTO Near32 stdcall, lpStringToGet:dword,	dLength:dword
	hexToChar 	PROTO Near32 stdcall, lpDestStr:dword,lpSourceStr:dword,dLen:dword
	memoryallocBailey PROTO Near32 stdcall, dNumBytes:dword  ;returns address ofmemory
; Methods from string1.asm
	EXTERN String_length:PROC
	EXTERN String_equals:PROC
	EXTERN String_equalsIgnoreCase: PROC
	EXTERN String_copy: PROC
	EXTERN String_substring_1: PROC
	EXTERN String_substring_2: PROC
	
	
	.data
; Constant Values
STR_MAX   = 30				;Max string length for entered values
COMMA_KEY = 02Ch			;value for the Comma key
ENTER_KEY = 13				;value for the enter key

; String Constant TESTVALS
strTest1            byte  "Golden", 0
strTest2            byte  "gOlden", 0
strOutput           dword ?
dIndex1             dword 1
dIndex2				dword 1

							;--- Insert test values here seperated with commas --- 
strTestVals			byte	"V@1ues,string,not string,,!@#$%^^,MiXed-Up V@1ues"
							;-----------------------------------------------------
iTestValsLength		dword	($-strTestVals)			;Length of TestVals in bytes
; Operational Storage
strValTemp1			byte	(STR_MAX + 1) dup(?)	;Storage for current test string
strValTemp2			byte	(STR_MAX + 1) dup(?)	;Storage for user entered string
strValTemp3			byte	12 dup(?)				;Storage for user entered string number
numValTemp1			dword	?						;Storage for numeric parameter
numValTemp2			dword	?						;Storage for numeric parameter
dReturnedVal		dword	?						;Storage for returned value
strReturnedVal		byte	9 dup(?)				;Storage for returned value as a string
; String Constant PROMPTS
strPromptExit		byte 	10,13,10,13,10,13,"Thank you for using my program! Hope you f",
								"ound this helpful!",10,13,0
strPromptRepeat		byte	10,13,10,13,"  --- Press <ENTER> to REPEAT test or ANOTHER KE",
								"Y to CONTINUE ---",0
strNewline 	        byte 10,0 ;newline constant
; String Constant REPORTS
strReportAuthorInfo	byte	10,13,32,32,32," Name: Daniel Crawford",10,13
strReportClass		byte 	32,32,32,"Class: CSCI 2160",10,13
strReportLab		byte	32,32,32,"  Lab: Proj3Driver_String1",10,13
strReportDate		byte	32,32,32," Date: 10/20/2016",10,13,0
strReportStr1		byte	10,13,10,13,9,"string1       = ",0
strReportStr2		byte	10,13,9,"string2       = ",0
strReportnum		byte	10,13,9,"Passed number = ",0
strReportEAX		byte	10,13,9,"Return in EAX = ",0
strReportStrEAX		byte	10,13,9,"Return string = ",0
strReportRtrnChar	byte	10,13,9,"Return string = ",0

strReportInt		byte	10,13,9,"int           = ",0
strReportChar		byte	10,13,9,"char          = ",0
; String Constant INFO
strInfoTestStrLength byte	10,13,10,13,32,32,32,"Now testing the String_Length Method",10,
								13
strInfoStrLengthUML	 byte	"String_length(string1:String):int",0
strInfoTestStrEquals byte	10,13,10,13,32,32,32,"Now testing the String_Equals Method",10,
								13
strInfoStrEqualsUML	 byte	"String_equals(string1:String,string2:String):boolean (byte)",0
strInfoTestEqualsIC	 byte	10,13,10,13,32,32,32,"Now testing the String_EqualsIgnoreCase",
								" Method",10,13
strInfoEqualsICUML	 byte	"String_equalsIgnoreCase(string1:String,string2:String):boole",
								"an (byte)",0
strInfoTestStrCopy	 byte	10,13,10,13,32,32,32,"Now testing the String_Copy Method",10,13
strInfoStrCopyUML	 byte	"String_copy(string1:String):String => String_copy",
							"(lpStringToCopy:dword):dword",0
strInfoSubstr1		 byte	10,13,10,13,32,32,32,"Now testing the String_substring_1 Meth",
								"od",10,13
strInfoSubstr1UML	 byte	"String_substring_1(string1:String,beginIndex:int,endIndex:in",
								"t):String",0							
strInfoSubstr2		 byte	10,13,10,13,32,32,32,"Now testing the String_substring_2 Meth",
							"od",10,13
strInfoSubstr2UML	 byte	"String_substring_2(string1:String,beginIndex:int):String",0							
strInfoTestStrCharAt byte	10,13,10,13,32,32,32,"Now testing the String_CharAt Method",10,
								13
strInfoStrCharAtUML	 byte	"String_charAt(string1:String,position:int):char (byte)",0
strInfoStrStartsWith1 	 byte	10,13,10,13,32,32,32,"Now testing the String_StartsWith_1",
									"Method",10,13
strInfoStrStartsWith1UML byte "String_startsWith_1(string1:String,strPrefix:String,pos:in",
								"t):boolean",0							
strInfoStrStartsWith2 	 byte 10,13,10,13,32,32,32,"Now testing the String_StartsWith_2 M",
								"ethod",10,13
strInfoStrStartsWith2UML byte "String_startsWith_2(string1:String, strPrefix:String):bool",
								"ean",0
strInfoStrEndsWith 	 	 byte 10,13,10,13,32,32,32,"Now testing the String_EndsWith Metho",
								"d",10,13
strInfoStrEndsWithUML 	 byte "String_endsWith(string1:String, suffix:String):boolean",0
strRandomSHit byte 10, 13, "teset adf", 0


	.code
_start:								 ;Entry point in program
; Introduction
	mov EAX,0  						 ;Ensures first instruction can be executed
	INVOKE 	putstring, ADDR strReportAuthorInfo	;Display author and file information
	
; Run Tests and Report
	call TestString_length			 ;Tests and Reports for String_Length method
	call TestString_equals
	call TestString_equalsIgnoreCase
	call TestString_copy
	call TestString_substring_1
	call TestString_substring_2

	
; Exit Program
	call ExitProgram				 ;Displays exit message and invokes ExitProcess,0

PUBLIC _start								;END METHOD

COMMENT %
*******************************************************************************************
* Name:	TestString_length                                                                 *
* Purpose:			                                                                      *
*				Tests String_Length procedure with various values and report results      *
*                                                                                         *
* Date Created:			October 20, 2016                                                  *
* Date Last Modified:	October 22, 2016                                                  *
******************************************************************************************%

TestString_length PROC USES EAX ECX ESI EDI
	
	INVOKE putstring, ADDR strInfoTestStrLength	;Display Test INFO
; Initialize Test
	;lea ESI, strTestVals					;ESI = strTestVals address
	;mov ECX, iTestValsLength				;ECX = length of strTestVals


; Call method
	push OFFSET strTest1				;Pass Param1
	call String_length						;Call method
	add ESP,4								;Repair stack
	mov [dReturnedVal],EAX					;Store returned Values
	
	Invoke intasc32, ADDR strOutput, dReturnedVal
	Invoke putString, ADDR strNewline
	Invoke putstring, ADDR strOutput
	


	ret										;return

TestString_length ENDP


TestString_equals PROC USES EAX ECX ESI EDI

	Invoke putString , ADDR strInfoTestStrEquals
	push OFFSET strTest2   ;push last parameter first 
	push OFFSET strTest1
	call String_equals
	add ESP, 8
	mov [dReturnedVal],EAX	
	
	;Invoke putString, EAX
	Invoke putString, ADDR strNewline
	Invoke putString, ADDR strNewline
	Invoke intasc32, ADDR strOutput, dReturnedVal
	Invoke putstring, ADDR strOutput
	ret

TestString_equals ENDP




TestString_equalsIgnoreCase PROC USES EAX ECX ESI EDI



Invoke putString , ADDR strInfoTestEqualsIC
	push OFFSET strTest2   ;push last parameter first 
	push OFFSET strTest1
	call String_equalsIgnoreCase
	add ESP, 8
	mov [dReturnedVal],EAX	
	
	Invoke putString, ADDR strNewline
	Invoke putString, ADDR strNewline
	Invoke intasc32, ADDR strOutput, dReturnedVal
	Invoke putstring, ADDR strOutput
	ret




TestString_equalsIgnoreCase ENDP




TestString_copy PROC USES EAX ECX ESI EDI

	Invoke putString, ADDR strInfoTestStrCopy
	push OFFSET strTest1
	call String_copy
	add esp, 4
	mov [dReturnedVal],EAX	
	
	Invoke putString, ADDR strNewline
	Invoke putString, ADDR strNewline
	Invoke putString, EAX


	
	ret
TestString_copy ENDP




TestString_substring_1 PROC USES EAX ECX ESI EDI


	Invoke putString, ADDR strInfoSubstr1
	push  dIndex2
	push  dIndex1
	push OFFSET strTest1
	call String_subString_1
	add esp, 12
	
	mov [dReturnedVal],EAX	
	
	Invoke putString, ADDR strNewline
	Invoke putString, ADDR strNewline
	Invoke putString, EAX
	


	ret
TestString_substring_1 ENDP





TestString_substring_2 PROC USES EAX ECX ESI EDI


Invoke putString, ADDR strInfoSubstr2
	push dIndex1
	push OFFSET strTest1
	call String_subString_2
	add esp, 8
	
	mov [dReturnedVal],EAX	
	
	Invoke putString, ADDR strNewline
	Invoke putString, ADDR strNewline
	Invoke putString, EAX


TestString_substring_2 ENDP

COMMENT %
*******************************************************************************************
* Name:	ExitProgram                                                                       *
* Purpose:			                                                                      *
*				Displays message and then invokes ExitProcess                             *                                                               *
*                                                                                         *
* Date Created:			October 22, 2016                                                  *
* Date Last Modified:	October 22, 2016                                                  *
******************************************************************************************%

ExitProgram PROC							;To exit the program...
	INVOKE putstring, ADDR strPromptExit	;Display exit message to user
	INVOKE getch							;Hold screen until user hits enter
	INVOKE ExitProcess, 0					;Exit the program
ExitProgram ENDP							;END ExitProgram

END											;END CODE