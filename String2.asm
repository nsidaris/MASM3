;*************************************************************************************
; Program Name:  String2.asm
; Programmer:    Brenden Kentera
; Class:         CS 3B
; Date:          April 10, 2017
; Purpose:
;        Define the methods for the String class
;*************************************************************************************
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
 *		Determine the number of characters in a string									*
 *																						*
 *   @param  lpString1:dword  															*
 *   @return length:dword  the length of a the string									*
 ***************************************************************************************%
;COMMENT %
String_length	proc Near32
	push ebp					;preserve base register
	mov ebp,esp					;set new stack frame
	push ebx					;preserve used registers
	push esi
	
	mov ebx,[ebp+8]				;ebx-> 1st string
	mov esi,0					;esi indexes into the strings	
stLoop:
	cmp byte ptr[ebx+esi],0	;checks if it has reached the end of a string
	je finished				;if yes, exit
	inc esi					;if not, go to the next character
	jmp stLoop				;loops until you hit a NULL character
finished:
	mov eax,esi					;returns the length in EAX
	
	pop esi			;restore preserved registers
	pop ebx
	pop ebp
	RET
String_length endp
;end of comment block

COMMENT %			;terminating symbol for the block is  								
 ****************************************************************************************
 * Name: String_indexOf1																*
 * Purpose:																				*
 *		Returns the position in the string of the char value(if found)					*
 *																						*
 *   @param  lpString1:dword char:byte													*
 *   @return firstVal:dword  the position of the char value in the string(if found)		*
 ***************************************************************************************%	
String_indexOf1 proc Near32
	push ebp					;preserve base register
	mov ebp,esp					;set new stack frame
	push ebx					;preserve used registers
	push esi
	
	mov ebx,[ebp+8]		;string
	mov ax, [ebp+12]	;character
	mov esi,0			;start searching from the start
stLoop:
	cmp byte ptr [ebx+esi], 0	;checks for the end of the string
	je charNotFound
	cmp byte ptr [ebx+esi], al	;compares the char in the string with the search char
	je charFound	;char found
	inc esi			;char not found
	jmp stLoop
charFound:
	mov eax,esi		;stores index into eax
	jmp exit
charNotFound:	
	mov eax, -1
exit:
	pop esi			;restore preserved registers
	pop ebx
	pop ebp
	RET	
String_indexOf1 endp 

COMMENT %			;terminating symbol for the block is  								
 ****************************************************************************************
 * Name: String_indexOf2																*
 * Purpose:																				*
 *		Returns the position in the string of the char value(if found), starting 		*
 *	from a specified index																*
 *																						*
 *   @param  lpString1:dword, char:byte, int:dword										*
 *   @return firstVal:dword  the position of the char value in the string(if found)		*
 ***************************************************************************************%	
String_indexOf2 proc Near32
	push ebp					;preserve base register
	mov ebp,esp					;set new stack frame
	push ebx					;preserve used registers
	push esi
	
	call String_length	;get the length of the string(in eax)	
	mov ebx,[ebp+8]		;string
	mov ax, [ebp+12]	;character
	mov esi, [ebp+14]	;index
	cmp esi, eax		;checks if given index is greater than the length of the string
	jg charNotFound		;if index > length of string, exit
stLoop:
	cmp byte ptr [ebx+esi], 0	;checks for end of string	
	je charNotFound
	cmp byte ptr [ebx+esi], al	;compares char in string with the search char
	je charFound	;char found
	inc esi
	jmp stLoop
charFound:
	mov eax,esi
	jmp exit
charNotFound:	
	mov eax, -1
exit:
	pop esi			;restore preserved registers
	pop ebx
	pop ebp
	RET	
String_indexOf2 endp

COMMENT %			;terminating symbol for the block is  								
 ****************************************************************************************
 * Name: String_indexOf3																*
 * Purpose:																				*
 *		Returns the position in the first string of the substring 					    *
 *	from a specified index																*
 *																						*
 *   @param  lpString1:dword, lpSubStr:dword											*
 *   @return firstVal:dword  the position of the string									*
 ***************************************************************************************%	
String_indexOf3 proc Near32
	push ebp					;preserve base register
	mov ebp,esp					;set new stack frame
	push ebx					;preserve used registers
	push esi
	
	mov ebx,[ebp+8]		;string
	mov ecx,[ebp+12]	;substring
	mov esi,0
	mov eax,0	
;stLoop:
;	mov edx,0
;	mov eax, esi
;subLoop:
;	cmp byte ptr [ebx+esi],0	;check end of string
;	je strEnd
;	mov dl, byte ptr[ebx+esi]	;store value at index of string
;	inc esi	
;	cmp byte ptr [ecx+edx],dl	;compare value in substring with stroed value form string
;	jne stLoop	;not equal, loops
;	inc edx
;	cmp byte ptr [ecx+edx],0	;checks for end of substring
;	je exit	;if substring ends exit
;	jmp subLoop	
;strEnd:
;	cmp byte ptr [ecx+edx],0
;	je exit
;	mov eax,-1
exit:
	pop esi			;restore preserved registers
	pop ebx
	pop ebp
	RET	
String_indexOf3 endp

COMMENT %
 ****************************************************************************************
 * Name: String_toLowerCase																*
 * Purpose:																				*
 *		Replaces any uppercase letter in a string with its lowercase verssion		    *
 *																						*
 *   @param  lpString1:dword															*
 *   @return nothing(passed string was edited)											*
 ***************************************************************************************%	
String_toLowerCase proc Near32
	push ebp					;preserve base register
	mov ebp,esp					;set new stack frame
	push ebx					;preserve used registers
	push esi
	
	mov ebx,[ebp+8]		;string
	mov esi,0			;index for navigating the string	
stLoop:
	cmp byte ptr[ebx+esi],0	;checks for the end of a string
	je finished				;if yes, exit
	
	cmp byte ptr[ebx+esi],65	;checks lower bound for uppercase chars
	jl reLoop
	cmp byte ptr[ebx+esi],90	;checks upper bound for uppercase chars
	jg reLoop
	
	mov al,byte ptr[ebx+esi]	;gets the value of the char in the string
	add al,32					;sets it to its lowercase value
	mov byte ptr[ebx+esi],al	;stores the lowercase value back in the string
reLoop:
	inc esi					;if not, go to the next character
	jmp stLoop				;loops until you hit a NULL character

finished:	
	pop esi			;restore preserved registers
	pop ebx
	pop ebp
	RET	
String_toLowerCase endp

COMMENT %
 ****************************************************************************************
 * Name: String_toUpperCase																*
 * Purpose:																				*
 *		Replaces any lowercase letter in a string with its uppercase verssion		    *
 *																						*
 *   @param  lpString1:dword															*
 *   @return nothing(passed string was edited)											*
 ***************************************************************************************%	
String_toUpperCase proc Near32
	push ebp					;preserve base register
	mov ebp,esp					;set new stack frame
	push ebx					;preserve used registers
	push esi
	
	mov ebx,[ebp+8]		;string
	mov esi,0			;index for navigating the string	
stLoop:
	cmp byte ptr[ebx+esi],0	;checks for the end of a string
	je finished				;if yes, exit
	
	cmp byte ptr[ebx+esi],97	;checks lower bound for lowercase chars
	jl reLoop
	cmp byte ptr[ebx+esi],122	;checks upper bound for lowercase chars
	jg reLoop
	
	mov al,byte ptr[ebx+esi]	;gets the value of the char in the string
	sub al,32					;sets it to its uppercase value
	mov byte ptr[ebx+esi],al	;stores the uppercase value back in the string
reLoop:
	inc esi					;if not, go to the next character
	jmp stLoop				;loops until you hit a NULL character

finished:	
	pop esi			;restore preserved registers
	pop ebx
	pop ebp
	RET	
String_toUpperCase endp
	
end