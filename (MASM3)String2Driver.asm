;*************************************************************************************
; Program Name:  MASM3.asm
; Programmer:    Brenden Kentera, Nick Sidaris
; Class:         CS 3B
; Date:          April 16, 2017
; Purpose:
;        driver file for MASM3's String2.asm (tests String2 procedures)
;	and String1.asm
;*************************************************************************************
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
	
;Methods from string2.asm
	EXTERN String_indexOf1:PROC
	EXTERN String_indexOf2:PROC
	EXTERN String_indexOf3:PROC	
	EXTERN String_toLowerCase:PROC
	EXTERN String_toUpperCase:PROC
	EXTERN String_concat:PROC		
	EXTERN String_replace:PROC
	EXTERN String_lastIndexOf1:PROC
	EXTERN String_lastIndexOf2:PROC
	EXTERN String_lastIndexOf3:PROC
;Methods from string1.asm
	EXTERN String_length:PROC
	Extern String_equals:PROC
	EXTERN String_equalsIgnoreCase:PROC
	EXTERN String_copy:PROC
	EXTERN String_substring_1:PROC
	EXTERN String_substring_2:PROC
	EXTERN String_charAt:PROC
	EXTERN String_startsWith_1:PROC
	EXTERN String_startsWith_2:PROC
	EXTERN String_endsWith:PROC
		
	.data
;Constant Value(s)
STR_MAX   = 79		;Max string length
;Header messages
strHeader1 byte 10,9," Name: Brenden Kentera", 10, 13, 9, 0 ;ASCII characters for newline, carriage return, and tab
strHeader2 byte      "Class: CS3B", 10, 13, 9, 0			;10 -> newline. 13 -> carriage return. 9 -> tab.
strHeader3 byte      "  Lab: MASM3", 10, 13, 9, 0					
strHeader4 byte      " Date: 4/10/2017", 10, 13, 0					
strVal1 byte "asdfghjkl",0	;initalizes strings
strVal2 byte "qwertyuiop",0
strVal3 byte "AsDfghJKl",0
strVal4 byte "xcvbnmnbvcxz",0
strVal5 byte (STR_MAX + 1) dup(?)	;initalizes space for strings (copy strings) 
strVal6 byte (STR_MAX + 1) dup(?)
dResult dword ?	;used for integer results from external methods(gotten from eax)
strResult byte 12 dup(?)	;used for outputing dResult as a string
strRandChars byte "!@#$%^&*()sdkjSEF?><:}{",0
;values for testing exrernal procedures
cSearchVal1 byte 'a'	;used to test indexOf1/2, lastIndexOf1/2 and replace procedures
cSearchVal2 byte 'u'
cSearchVal3 byte 'x'
strSearchVal1 byte "xcv",0	;test indexOf3, lastIndexOf3, and concat procedures
strSearchVal2 byte "vcxz",0
strSearchVal3 byte "Dfgh",0
strSearchVal4 byte "dfgh",0
strLastIndexTest1 byte "wasd sawdwasdcxztwasd",0	;used for testing lastIndexOf3
strSubTest1 byte "wasd",0
strPromptExit byte 10,13,10,13,"Thank you for using my program!",10,13,0	;exit message for the program
strLength byte 10,13,"Length of string: ",0
strPosition byte 10,13,"Position of char in string: ",0
strPosOfStr byte 10,13,"Position of the string: ",0
strNewLine byte 10,13,0
strMemFail byte 10,13,"couldn't allocate memory for string",0
strBeforeReplace byte 10,13,"string before replace: ",0
strAfterReplace byte 10,13,"string after replace: ",0
strTestingStrLength byte 10,13, "String_lengh tests:",0
strTestingStrIndex1 byte 10,13, "String_indexOf1 tests:",0
strTestingStrIndex2 byte 10,13, "String_indexOf2 tests:",0
strTestingStrIndex3 byte 10,13, "String_indexOf3 tests:",0
strTestingStrToLower byte 10,13, "String_toLowerCase tests:",0
strTestingStrToUpper byte 10,13, "String_toUppercase tests:",0
strTestingStrReplace byte 10,13, "String_replace tests:",0
strTestingStrConcat byte 10,13, "String_concat tests:",0
strTestingStrLastIndex1 byte 10,13, "String_lastIndexOf1 tests:",0
strTestingStrLastIndex2 byte 10,13, "String_lastIndexOf2 tests:",0
strTestingStrLastIndex3 byte 10,13, "String_lastIndexOf3 tests:",0

; String Constant TESTVALS
strTest1            byte  "Golden", 0
strTest2            byte  "gOlden", 0
strTest3			byte "ens", 0
strOutput           dword ?
dIndex1             dword 1
dIndex2				dword 1
strInfoTestStrEquals 	byte	10,13,10,13,32,32,32,"Now testing the String_Equals Method",10,13
strInfoTestEqualsIC	 	byte	10,13,10,13,32,32,32,"Now testing the String_EqualsIgnoreCase Method",10,13
strInfoTestStrCopy	 	byte	10,13,10,13,32,32,32,"Now testing the String_Copy Method",10,13
strInfoSubstr1		 	byte	10,13,10,13,32,32,32,"Now testing the String_substring_1 Method",10,13
strInfoSubstr2		 	byte	10,13,10,13,32,32,32,"Now testing the String_substring_2 Method",10,13						
strInfoTestStrCharAt 	byte	10,13,10,13,32,32,32,"Now testing the String_CharAt Method",10,13
strInfoStrStartsWith1	byte	10,13,10,13,32,32,32,"Now testing the String_StartsWith_1Method",10,13
strInfoStrStartsWith2 	byte 10,13,10,13,32,32,32,"Now testing the String_StartsWith_2 Method",10,13
strInfoStrEndsWith 		byte 10,13,10,13,32,32,32,"Now testing the String_EndsWith Method",10,13
dReturnedVal	dword	?						;Storage for returned value

strCat byte "cat",0
strCat2 byte "CAT",0
cVal1 byte 'c'
cVal2 byte 'a'
cVal3 byte 't'
strMissi byte "Mississippi",0
cVal4 byte 'i'
cVal5 byte 'M'
cVal6 byte 'e'
strLastPos byte 10,13,"Last poisition of char in string: ",0
strTestConcat byte 10,13,"String_concat: ",10,13,0
strTestIndex byte 10,13,"String_indexOf1: ",10,13,0
strTestLastIndex byte 10,13,"String_lastIndexOf1: ",10,13,0
strTestReplace byte 10,13,"String_replace: ",10,13,0
strTestToLower byte 10,13,"String_toLowerCase: ",10,13,0

strEmpty byte " ",0

	.code
_start:								 ;Entry point in program

	mov EAX,0  						 ;Ensures first instruction can be executed
	INVOKE putstring, ADDR strHeader1	;output header messages
	INVOKE putstring, ADDR strHeader2
	INVOKE putstring, ADDR strHeader3
	INVOKE putstring, ADDR strHeader4
	
;Test String2.asm procedures
	call TestString_length
	call TestString_indexOf1
	call TestString_indexOf2
	call TestString_indexOf3	
	call TestString_toLowerCase
	call TestString_toUpperCase
	call TestString_replace
	call TestString_lastIndexOf1
	call TestString_lastIndexOf2
	call TestString_lastIndexOf3
	call TestString_concat
;Test String1.asm procedures
	call TestString_equals
	call TestString_equalsIgnoreCase
	call TestString_copy
	call TestString_substring_1
	call TestString_substring_2
	call TestString_charAt
	call TestString_startsWith_1
	call TestString_startsWith_2
	call TestString_endsWith	
	
	call ExitProgram				 ;Displays exit message and invokes ExitProcess,0

PUBLIC _start								;END METHOD

COMMENT %
*******************************************************************************************
* Name:	TestString_length                                                                 *
* Purpose:			                                                                      *
*		Tests String_Length procedure, pass in various strings and show their result	  *
* passes the address of the string using the stack (lpstringAddress:dword)			  	  *
* returns the length of the string into eax												  *
*	store result into variable dResult, then output dResult using intasci32 and strResult *
******************************************************************************************%
;Call method
TestString_length PROC USES EAX ECX ESI EDI
	invoke putstring, addr strTestingStrLength
;tests first string(asdfghjkl)
	push OFFSET strVal1						;Pass Param1 (string)
	call String_length						;Call method
	add ESP,4								;Repair stack
	mov dResult,EAX							;Store returned Values	
	invoke intasc32, addr strResult, dResult	;stores number result as a string
	invoke putstring, addr strLength			;outputs message
	invoke putstring, addr strResult			;outputs number(length of string) as a string
;test second string(qwertyuiop)
	push OFFSET strVal2						
	call String_length						
	add ESP,4								
	mov dResult,EAX							
	invoke intasc32, addr strResult, dResult	
	invoke putstring, addr strLength			
	invoke putstring, addr strResult			
;test third string(AsDfghJKl)
	push OFFSET strVal3						
	call String_length						
	add ESP,4							
	mov dResult,EAX							
	invoke intasc32, addr strResult, dResult	
	invoke putstring, addr strLength			
	invoke putstring, addr strResult			
;test fourth string(xcvbnmnbvcxz)
	push OFFSET strVal4			
	call String_length						
	add ESP,4								
	mov dResult,EAX						
	invoke intasc32, addr strResult, dResult
	invoke putstring, addr strLength		
	invoke putstring, addr strResult	
	
	invoke putstring, addr strNewLine
	ret									
TestString_length ENDP

COMMENT %
*******************************************************************************************
* Name:	TestString_indexOf1                                                               *
* Purpose:			                                                                      *
*		Tests String_indexof1 procedure 												  *
* passes the address of the string using the stack (lpstringAddress:dword) 				  *
*	and a character (char:byte) 														  *
* returns the location of the character in the string, -1 if it is not found in the string*
******************************************************************************************%
TestString_indexOf1 proc USES EAX ECX ESI EDI
	invoke putstring, addr strTestingStrIndex1
	
	movsx ax, cSearchVal1
	push ax
	push offset strVal5
	call String_indexOf1
	add esp,6
	cmp eax,-1
	je skip1
	mov dResult,EAX	
	invoke intasc32, addr strResult, dResult	
	invoke putstring, addr strPosition
	invoke putstring, addr strResult
skip1:
	movsx ax, cVal1
	push ax
	push offset strCat
	call String_indexOf1
	add esp,6
	cmp eax,-1
	je skip2
	mov dResult,EAX	
	invoke intasc32, addr strResult, dResult	
	invoke putstring, addr strPosition
	invoke putstring, addr strResult
skip2:
	movsx ax, cVal2
	push ax
	push offset strCat
	call String_indexOf1
	add esp,6
	cmp eax,-1
	je skip3
	mov dResult,EAX	
	invoke intasc32, addr strResult, dResult	
	invoke putstring, addr strPosition
	invoke putstring, addr strResult
skip3:
	movsx ax, cVal3
	push ax
	push offset strCat
	call String_indexOf1
	add esp,6
	cmp eax,-1
	je skip4
	mov dResult,EAX	
	invoke intasc32, addr strResult, dResult	
	invoke putstring, addr strPosition
	invoke putstring, addr strResult
skip4:
;string(asdfghjkl),char(a)
	movsx ax, cSearchVal1	;makes byte a word, to push into stack
	push ax					;pass param2 (char)
	push offset strVal1		;pass param1 (string)
	call String_indexOf1	;call method
	add esp,6				;repair stack
	mov dResult,EAX			;take result(stored in eax) and stores into variable dResult
	invoke intasc32, addr strResult, dResult	;outputs result
	invoke putstring, addr strPosition
	invoke putstring, addr strResult
;string(qwertyuiop), char(u)	
	movsx ax, cSearchVal2	
	push ax					
	push offset strVal2		
	call String_indexOf1
	add esp,6
	mov dResult,EAX		
	invoke intasc32, addr strResult, dResult
	invoke putstring, addr strPosition
	invoke putstring, addr strResult
;string(xcvbnmnbvcxz), char(x)	
	movsx ax, cSearchVal3	
	push ax					
	push offset strVal4		
	call String_indexOf1
	add esp,6
	mov dResult,EAX		
	invoke intasc32, addr strResult, dResult
	invoke putstring, addr strPosition
	invoke putstring, addr strResult
	
	invoke putstring, addr strNewLine
	ret
TestString_indexOf1 endp

COMMENT %
*******************************************************************************************
* Name:	TestString_indexOf2                                                               *
* Purpose:			                                                                      *
*		Tests String_indexof2 procedure 												  *
* passes the address of the string using the stack (lpstringAddress:dword) 				  *
*	a character (char:byte) and a number (num:dword)									  *
* returns the location of the character in the string, -1 if either it is not found 	  *
*	in the string or if the given position is out of bounds of the string				  *
******************************************************************************************%
TestString_indexOf2 proc USES EAX ECX ESI EDI
	invoke putstring, addr strTestingStrIndex2
;string(xcvbnmnbvcxz), char(x), index(5)
	mov eax, 5				;set index(in eax)
	push eax				;pass param3 (start position of search)
	movsx ax, cSearchVal3	;get char to search for(turns byte into word to push to stack)
	push ax					;pass param2 (char)
	push offset strVal4		;pass param1 (string)
	call String_indexOf2	
	cmp eax,-1
	je skip1
	add esp,10				;repairs the stack
	mov dResult,EAX								;outputs results
	invoke intasc32, addr strResult, dResult
	invoke putstring, addr strPosition
	invoke putstring, addr strResult
skip1:
;string(qwertyuiop), char(u), index(5)	
	mov eax, 4
	push eax
	movsx ax, cSearchVal2	
	push ax					
	push offset strVal2		
	call String_indexOf2
	add esp,10
	cmp eax,-1
	je skip2
	mov dResult,EAX		
	invoke intasc32, addr strResult, dResult
	invoke putstring, addr strPosition
	invoke putstring, addr strResult
	cmp eax,-1
skip2:
;tests with string1
;string(asdfghjkl), char(a), index(13)
	mov eax, 13
	push eax
	movsx ax, cSearchVal1	
	push ax					
	push offset strVal1		
	call String_indexOf2
	add esp,10
	cmp eax,-1
	je skip3
	mov dResult,EAX		
	invoke intasc32, addr strResult, dResult
	invoke putstring, addr strPosition
	invoke putstring, addr strResult
skip3:
;string(asdfghjkl), char(a), index(0)
	mov eax, 0
	push eax
	movsx ax, cSearchVal1	
	push ax					
	push offset strVal1		
	call String_indexOf2
	add esp,10
	cmp eax,-1
	je skip4
	mov dResult,EAX		
	invoke intasc32, addr strResult, dResult
	invoke putstring, addr strPosition
	invoke putstring, addr strResult
skip4:
;string(asdfghjkl), char(a), index(1)	
	mov eax, 1
	push eax
	movsx ax, cSearchVal1	
	push ax					
	push offset strVal1		
	call String_indexOf2
	add esp,10
	cmp eax,-1
	je skip5
	mov dResult,EAX		
	invoke intasc32, addr strResult, dResult
	invoke putstring, addr strPosition
	invoke putstring, addr strResult
skip5:
;string(asdfghjkl), char(a), index(-1)	
	mov eax, 1
	push eax
	movsx ax, cSearchVal1	
	push ax					
	push offset strVal1		
	call String_indexOf2
	add esp,10
	cmp eax,-1
	je skip6
	mov dResult,EAX		
	invoke intasc32, addr strResult, dResult
	invoke putstring, addr strPosition
	invoke putstring, addr strResult
skip6:
;string(asdfghjkl), char(a), index(-100)	
	mov eax, -100
	push eax
	movsx ax, cSearchVal1	
	push ax					
	push offset strVal1		
	call String_indexOf2
	add esp,10
	cmp eax,-1
	je skip7
	mov dResult,EAX		
	invoke intasc32, addr strResult, dResult
	invoke putstring, addr strPosition
	invoke putstring, addr strResult
skip7:
;string(asdfghjkl), char(a), index(0)	
	mov eax, 0
	push eax
	movsx ax, cSearchVal1	
	push ax					
	push offset strVal1		
	call String_indexOf2
	add esp,10
	cmp eax,-1
	je skip8
	mov dResult,EAX		
	invoke intasc32, addr strResult, dResult
	invoke putstring, addr strPosition
	invoke putstring, addr strResult
skip8:
	invoke putstring, addr strNewLine
	ret
TestString_indexOf2 endp

COMMENT %
*******************************************************************************************
* Name:	TestString_indexOf3                                                               *
* Purpose:			                                                                      *
*		Tests String_indexof3 procedure 												  *
* passes the address of two strings using the stack (lpstringAddress:dword) 			  *
* returns the location of the second/substring                                            *
******************************************************************************************%
TestString_indexOf3 proc USES EAX ECX EDX ESI EDI 
	invoke putstring, addr strTestingStrIndex3
;string(xcvbnmnbvcxz), substring(xcv)
	push offset strSearchVal1	;pass param2 (substring)
	push offset strVal4			;pass param1 (string)
	call String_indexOf3
	add esp,8
	cmp eax,-1
	je skip1
	mov dResult,EAX		
	invoke intasc32, addr strResult, dResult
	invoke putstring, addr strPosOfStr
	invoke putstring, addr strResult
skip1:
;string(xcvbnmnbvcxz), substring(vcxz)	
	push offset strSearchVal2
	push offset strVal4
	call String_indexOf3
	add esp,8 
	cmp eax,-1
	je skip2
	mov dResult,EAX		
	invoke intasc32, addr strResult, dResult
	invoke putstring, addr strPosOfStr
	invoke putstring, addr strResult	
skip2:
;string(vcxz). substring(xcvbnmnbvcxz	
	push offset strVal4
	push offset strSearchVal2
	call String_indexOf3
	add esp,8 
	cmp eax,-1
	je skip3
	mov dResult,EAX		
	invoke intasc32, addr strResult, dResult
	invoke putstring, addr strPosOfStr
	invoke putstring, addr strResult
skip3:
	invoke putstring, addr strNewLine
	ret
TestString_indexOf3 endp

COMMENT %
*******************************************************************************************
* Name:	TestString_toLowerCase                                                            *
* Purpose:			                                                                      *
*		Tests String_toLowerCase procedure 												  *
* passes the address of a strings using the stack (lpstringAddress:dword) 			  	  *
* returns the string with all lowercase chars											  *
******************************************************************************************%
TestString_toLowerCase proc USES EAX ECX EDX ESI EDI 
	invoke putstring, addr strTestingStrToLower
	
	push offset strVal5
	call String_toLowerCase
	add esp,4		
	;invoke putstring, addr strNewLine
	invoke putstring, addr strVal3
	push offset strVal3			;pass param1 (string)
	call String_toLowerCase
	add esp,4		
	invoke putstring, addr strNewLine
	invoke putstring, addr strCat
	push offset strVal3			;pass param1 (string)
	call String_toLowerCase
	add esp,4		
	invoke putstring, addr strNewLine
	invoke putstring, addr strCat2
	
;string(AsDfghJKl)
	push offset strVal3			;pass param1 (string)
	call String_toLowerCase
	add esp,4		
	invoke putstring, addr strNewLine
	invoke putstring, addr strVal3
;string(!@#$%^&*()sdkjSEF?><":}{)
	push offset strRandChars			;pass param1 (string)
	call String_toLowerCase
	add esp,4		
	invoke putstring, addr strNewLine
	invoke putstring, addr strRandChars
	
	invoke putstring, addr strNewLine
	ret
TestString_toLowerCase endp

COMMENT %
*******************************************************************************************
* Name:	TestString_toUpperCase                                                            *
* Purpose:			                                                                      *
*		Tests String_toUpperCase procedure 												  *
* passes the address of a strings using the stack (lpstringAddress:dword) 			  	  *
* returns the string with all uppercase chars											  *
******************************************************************************************%
TestString_toUpperCase proc USES EAX ECX EDX ESI EDI 
	invoke putstring, addr strTestingStrToUpper
;string(AsDfghJKl) [string(asdfghjkl) if called after toLowerCase]
	push offset strVal3			;pass param1 (string)
	call String_toUpperCase
	add esp,4	
;string(ASDFGHJKL)	
	invoke putstring, addr strNewLine
	invoke putstring, addr strVal3		
;string(!@#$%^&*()sdkjSEF?><":}{)
	push offset strRandChars			;pass param1 (string)
	call String_toUpperCase
	add esp,4		
	invoke putstring, addr strNewLine
	invoke putstring, addr strRandChars
	
	invoke putstring, addr strNewLine
	ret
TestString_toUpperCase endp

COMMENT %
*******************************************************************************************
* Name:	TestString_replace                                                            	  *
* Purpose:			                                                                      *
*		Tests replace procedure 												  		  *
* passes the address of a string using the stack (lpstringAddress:dword) 			  	  *
* and two characters (oldChar:byte, newChar:byte)									  	  *
* Replaces all instances of the oldChar with newChar									  *
******************************************************************************************%
TestString_replace proc USES EAX ECX EDX ESI EDI 
	
	invoke putstring, addr strNewLine
	invoke putstring, addr strBeforeReplace
	invoke putstring, addr strVal4			
;string(xcvbnmnbvcxz), char(x), char(a)
	movsx ax, cSearchVal1	;pass param3 (char), new character	
	push ax
	movsx ax, cSearchVal3	;pass param2 (char) ,old character
	push ax
	push offset strVal4		;pass param1 (string)
	call String_replace
	add esp,8
	invoke putstring, addr strAfterReplace
	invoke putstring, addr strVal4		
	
	invoke putstring, addr strNewLine
	invoke putstring, addr strBeforeReplace
	invoke putstring, addr strVal4
;string(xcvbnmnbvcxz), char(a), char(x)	
;undo changes to string
	movsx ax, cSearchVal3	
	push ax
	movsx ax, cSearchVal1	
	push ax
	push offset strVal4		
	call String_replace
	add esp,8
	invoke putstring, addr strAfterReplace
	invoke putstring, addr strVal4	

	invoke putstring, addr strNewLine
	ret
TestString_replace endp

COMMENT %
*******************************************************************************************
* Name:	TestString_lastIndexOf1                                                           *
* Purpose:			                                                                      *
*		Tests String_lastindexof1 procedure 										      *
* passes the address of the string using the stack (lpstringAddress:dword) 				  *
*	and a character (char:byte) 														  *
* returns the location of the character in the string, -1 if it is not found in the string*
******************************************************************************************%
TestString_lastIndexOf1 proc USES EAX ECX ESI EDI
	invoke putstring, addr strTestingStrLastIndex1

	movsx ax, cVal4	
	push ax					
	push offset strMissi		
	call String_lastIndexOf1	
	add esp,6	
	cmp eax,-1
	je skip1
	mov dResult,EAX			
	invoke intasc32, addr strResult, dResult	
	invoke putstring, addr strLastPos
	invoke putstring, addr strResult
skip1:
	movsx ax, cVal5	
	push ax					
	push offset strMissi		
	call String_lastIndexOf1	
	add esp,6	
	cmp eax,-1
	je skip2
	mov dResult,EAX			
	invoke intasc32, addr strResult, dResult	
	invoke putstring, addr strLastPos
	invoke putstring, addr strResult
skip2:	
	movsx ax, cVal6	
	push ax					
	push offset strMissi		
	call String_lastIndexOf1	
	add esp,6	
	cmp eax,-1
	je skip3
	mov dResult,EAX			
	invoke intasc32, addr strResult, dResult	
	invoke putstring, addr strLastPos
	invoke putstring, addr strResult
skip3:
;string(xcvbnmnbvcxz), char(x)
	movsx ax, cSearchVal3	;makes byte a word for pushing to stack
	push ax					;pass param2 (char)
	push offset strVal4		;pass param1 (string
	call String_lastIndexOf1	;call method
	add esp,6				;repair stack	
	cmp eax, -1
	je skip4
	mov dResult,EAX			;take result(stored in eax) and stores into var dResult
	invoke intasc32, addr strResult, dResult	;outputs result
	invoke putstring, addr strPosition
	invoke putstring, addr strResult
skip4:	
	invoke putstring, addr strNewLine
	ret
TestString_lastIndexOf1 endp 

COMMENT %
*******************************************************************************************
* Name:	TestString_lastIndexOf2                                                           *
* Purpose:			                                                                      *
*		Tests String_lastIndexof2 procedure 											  *
* passes the address of the string using the stack (lpstringAddress:dword) 				  *
*	a character (char:byte) and a number (num:dword)									  *
* returns the location of the last character in the string, -1 if either it is not found  *
*	in the string or if the given position is out of bounds of the string				  *
******************************************************************************************%
TestString_lastIndexOf2 proc USES EAX ECX ESI EDI
	invoke putstring, addr strTestingStrLastIndex2	
;string(xcvbnmnbvcxz), char(x), index(5)
	mov eax, 5
	push eax				;pushes starting place for the search
	movsx ax, cSearchVal3	
	push ax					;pushes the character
	push offset strVal4		;pushes the string
	call String_lastIndexOf2	
	add esp,10				;repairs the stack
	cmp eax,-1
	je skip1
	mov dResult,EAX		
	invoke intasc32, addr strResult, dResult
	invoke putstring, addr strPosition
	invoke putstring, addr strResult
skip1:
;string(xcvbnmnbvcxz), char(x), index(11)
	mov eax, 11
	push eax				
	movsx ax, cSearchVal3	
	push ax					
	push offset strVal4		
	call String_lastIndexOf2	
	add esp,10				
	mov dResult,EAX		
	invoke intasc32, addr strResult, dResult
	invoke putstring, addr strPosition
	invoke putstring, addr strResult
;string(xcvbnmnbvcxz), char(x), index(21)	
	mov eax, 21
	push eax				
	movsx ax, cSearchVal3	
	push ax					
	push offset strVal4		
	call String_lastIndexOf2	
	add esp,10		
	cmp eax,-1
	je skip2	
	mov dResult,EAX		
	invoke intasc32, addr strResult, dResult
	invoke putstring, addr strPosition
	invoke putstring, addr strResult
skip2:
;string(qwertyuiop), char(u), index(9)	
	mov eax, 9
	push eax				
	movsx ax, cSearchVal2	
	push ax					
	push offset strVal2		
	call String_lastIndexOf2	
	add esp,10				
	mov dResult,EAX		
	invoke intasc32, addr strResult, dResult
	invoke putstring, addr strPosition
	invoke putstring, addr strResult
;string(xcvbnmnbvcxz), char(x), index(0)	
	mov eax, 0
	push eax				
	movsx ax, cSearchVal3	
	push ax					
	push offset strVal4		
	call String_lastIndexOf2	
	add esp,10				
	mov dResult,EAX		
	invoke intasc32, addr strResult, dResult
	invoke putstring, addr strPosition
	invoke putstring, addr strResult
;string(xcvbnmnbvcxz), char(x), index(-1)	
	mov eax, -1
	push eax				
	movsx ax, cSearchVal3	
	push ax					
	push offset strVal4		
	call String_lastIndexOf2	
	add esp,10				
	mov dResult,EAX		
	invoke intasc32, addr strResult, dResult
	invoke putstring, addr strPosition
	invoke putstring, addr strResult
;string(xcvbnmnbvcxz), char(x), index(-100)	
	mov eax, -100
	push eax				
	movsx ax, cSearchVal3	
	push ax					
	push offset strVal4		
	call String_lastIndexOf2	
	add esp,10				
	mov dResult,EAX		
	invoke intasc32, addr strResult, dResult
	invoke putstring, addr strPosition
	invoke putstring, addr strResult
	
	invoke putstring, addr strNewLine
	ret
TestString_lastIndexOf2 endp

COMMENT %
*******************************************************************************************
* Name:	TestString_lastIndexOf3                                                           *
* Purpose:			                                                                      *
*		Tests String_lastIndexOf3 procedure 											  *
* passes the address of two strings using the stack (lpstringAddress:dword) 			  *
*	(lpstringAddress1:dword, lpstringAddress2:dword)								  	  *
* returns the location of the last substring in the string, -1 if is not found 			  *
******************************************************************************************%
TestString_lastIndexOf3 proc USES EAX EBX ECX EDX ESI EDI
	invoke putstring, addr strTestingStrLastIndex3
;string(sawdwasdcxztwasd), substring(wasd)
	push offset strSubTest1		;pass param2 (string), substring
	push offset strLastIndexTest1		;pass param1 (string)
	call String_lastIndexOf3
	add esp,8
	mov dResult,EAX		
	invoke intasc32, addr strResult, dResult
	invoke putstring, addr strPosOfStr
	invoke putstring, addr strResult
;string(wasd), substring(sawdwasdcxztwasd)
	push offset strLastIndexTest1		;pass param2 (string), substring
	push offset strSubTest1		;pass param1 (string), string
	call String_lastIndexOf3
	add esp,8
	mov dResult,EAX		
	invoke intasc32, addr strResult, dResult
	invoke putstring, addr strPosOfStr
	invoke putstring, addr strResult
	
	invoke putstring, addr strNewLine
	ret
TestString_lastIndexOf3 endp

COMMENT %
*******************************************************************************************
* Name:	TestString_concat                                                                 *
* Purpose:			                                                                      *
*	Tests the String_concat procedure, passes two strings and adds the second to the	  *
* end of the first string																  *
******************************************************************************************%
;Call method
TestString_concat PROC USES EAX EBX ECX EDX ESI EDI
	invoke putstring, addr strTestingStrConcat
	
	push offset strVal5		
	push offset strVal6		
	call String_concat
	add esp,8
	cmp eax,-1	
	je skip1
	invoke putstring, addr strNewLine	
	invoke putstring, eax
skip1:
	push offset strVal5		
	push offset strCat		
	call String_concat
	add esp,8
	cmp eax,-1	
	je skip2
	invoke putstring, addr strNewLine	
	invoke putstring, eax
skip2:
	push offset strCat
	push offset strVal5				
	call String_concat
	add esp,8
	cmp eax,-1	
	je skip3
	invoke putstring, addr strNewLine	
	invoke putstring, eax
skip3:
	push offset strCat
	push offset strCat				
	call String_concat
	add esp,8
	cmp eax,-1	
	je skip4
	invoke putstring, addr strNewLine	
	invoke putstring, eax
skip4:
;string1(asdfghjkl), string2(qwertyuiop)	
	push offset strVal2		;pass param2 (string)
	push offset strVal1		;pass param1 (string)
	call String_concat
	add esp,8
	cmp eax,-1	;check if it couldn't allocate memory for new string
	je skip5
	invoke putstring, addr strNewLine	
	invoke putstring, eax			;outputs new string
skip5:
;2 empty strings	
	push offset strVal5		;pass param2 (string)
	push offset strVal6		;pass param1 (string)
	call String_concat
	add esp,8
	cmp eax,-1	;check if it couldn't allocate memory for new string
	je skip6
	invoke putstring, addr strNewLine	
	invoke putstring, eax			;outputs new string
skip6:
;empty string as 1st parameter
	push offset strVal2		;pass param2 (string)
	push offset strVal5		;pass param1 (string)
	call String_concat
	add esp,8
	cmp eax,-1	;check if it couldn't allocate memory for new string
	je skip7
	invoke putstring, addr strNewLine	
	invoke putstring, eax			;outputs new string
skip7:
;empty string as 2nd parameter
	push offset strVal6		;pass param2 (string)
	push offset strVal1		;pass param1 (string)
	call String_concat
	add esp,8
	cmp eax,-1	;check if it couldn't allocate memory for new string
	je skip8
	invoke putstring, addr strNewLine	
	invoke putstring, eax			;outputs new string
skip8:
	
	ret
TestString_concat endp

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

	ret 
TestString_substring_2 ENDP

TestString_charAt PROC USES EAX ECX ESI EDI
	Invoke putString, ADDR strInfoTestStrCharAt
	push dIndex2
	push OFFSET strTest1
	call String_charAt
	add esp, 8
		Invoke putString, ADDR strNewline
	Invoke putString, ADDR strNewline
	Invoke putString, EAX

	ret
TestString_charAt endp

TestString_startsWith_1  PROC USES EAX ECX ESI EDI
	Invoke putString, ADDR strInfoStrStartsWith1
	
	push dIndex1
	push OFFSET strTest3
	push OFFSET strTest1
	call String_startsWith_1
	add esp, 12
	mov [dReturnedVal],EAX	
	
	Invoke putString, ADDR strNewline
	Invoke putString, ADDR strNewline
	Invoke intasc32, ADDR strOutput, dReturnedVal
	Invoke putstring, ADDR strOutput
	
	ret 
TestString_startsWith_1 endp

TestString_startsWith_2 PROC USES EAX ECX ESI EDI
	Invoke putString, ADDR strInfoStrStartsWith2

	push OFFSET strTest3
	push OFFSET strTest1
	call String_startsWith_2
	add esp, 8
	mov [dReturnedVal],EAX	
	
	Invoke putString, ADDR strNewline
	Invoke putString, ADDR strNewline
	Invoke intasc32, ADDR strOutput, dReturnedVal
	Invoke putstring, ADDR strOutput

	ret
TestString_startsWith_2 endp

TestString_endsWith PROC USES EAX ECX ESI EDI
	Invoke putString, ADDR strInfoStrEndsWith 	

	push OFFSET strTest3
	push OFFSET strTest1
	call String_endsWith
	add esp, 8

	mov [dReturnedVal],EAX		
	Invoke putString, ADDR strNewline
	Invoke putString, ADDR strNewline
	Invoke intasc32, ADDR strOutput, dReturnedVal
	Invoke putstring, ADDR strOutput
	
	ret
TestString_endsWith endp

COMMENT %
*******************************************************************************************
* Name:	ExitProgram                                                                       *
* Purpose:			                                                                      *
*				Displays message and then invokes ExitProcess                             *
******************************************************************************************%
ExitProgram PROC							;To exit the program...
	INVOKE putstring, ADDR strPromptExit	;Display exit message to user
	INVOKE ExitProcess, 0					;Exit the program
ExitProgram ENDP							;END ExitProgram

END											;END CODE
