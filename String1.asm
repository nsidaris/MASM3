
;*************************************************************************************
; Program Name:  String1.asm
; Programmer:    Nick Sidaris
; Class:         CS1C
; Date:          April 11, 2017
; Purpose:
;        Define the methods for the String class
;
	.486
	.model flat
	.stack 100h
	
	ascint32	PROTO Near32 stdcall, lpStringToConvert:dword 
 	intasc32	PROTO Near32 stdcall, lpStringToHold:dword, dval:dword
	getstring	PROTO Near32 stdcall, lpStringToGet:dword, dlength:dword
	putstring 	PROTO Near32 stdcall, lpStringToPrint:dword
	memoryallocBailey PROTO Near32 stdcall, dNumBytes:dword  ;returns address ofmemory
	;extern String_length:near32
.data
strInput	byte	20 dup(?)	
	.code

	
COMMENT %			;terminating symbol for the block is  								
 ****************************************************************************************
 * Name: String_length																	*
 * Purpose:																				*
 *		The purpose of the method is to determine the number of characters in a string	*
 *																						*
 * Date created: October 1, 2016														*
 * Date last modified: October 19, 2016													*
 *																						*
 * Notes on specifications, special algorithms, and assumptions:						*
 *   notes go here. Omit these lines if there is no special algorithm or there were no	*
 *   assumptions.																		*
 *																						*
 *   @param  lpString1:dword  															*
 *   @return len:dword  the length of a the string										*
 ***************************************************************************************%
;COMMENT %
String_length	proc Near32
	;push ebp					;preserve base register
	;mov ebp,esp					;set new stack frame
	enter 0,0 
	push ebx					;preserve used registers
	push esi
	mov ebx,[ebp+8]				;ebx-> 1st string
	mov esi,0					;esi indexes into the strings
	
stLoop:
		cmp byte ptr[ebx+esi],0	;reached the end of the string
		je finished				;if yes, done in here
		inc esi					;otherwise, continue to next character
		jmp stLoop				;  until you hit the NULL character
finished:

	mov eax,esi					;returns the length in EAX
	pop esi			;restore preserved registers
	;pop ebx
	;pop ebp
	leave
	RET
String_length endp
 ; end of comment block
	


	end
	