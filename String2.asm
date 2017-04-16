;*************************************************************************************
; Program Name:  String2.asm
; Programmer:    Brenden Kentera
; Class:         CS 3B
; Date:          April 16, 2017
; Purpose:
;        Define the methods for the String class:
;	String_length, String_indexOf1, String_indexOf2, String_indexOf3
;	String_lastIndexOf1, String_lastIndexOf2, String_lastIndexOf3, String_concat
;	String_replace, String_toLowerCase, String_toUpperCase
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
dVal1 dword ?
dVal2 dword ?
	.code
	
COMMENT %			;terminating symbol for the block is  								
*****************************************************************************************
* Name: String_length									*
* Purpose:										*
*		Determine the number of characters in a string				*
*											*
*   @param  lpString1:dword  								*
*   @return length:dword  the length of a the string	                                *
****************************************************************************************%
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

COMMENT %								
*****************************************************************************************
* Name: String_indexOf1									*
* Purpose:										*
*		Returns the position in the string of the char value(if found)		*
*											*
*   @param  lpString1:dword char:byte							*
*   @return lastVal:dword  the position of the char value in the string(if found)	*
****************************************************************************************%	
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

COMMENT %								
*****************************************************************************************
* Name: String_indexOf2									*
* Purpose:										*
*		Returns the position in the string of the char value(if found), starting*
*	from a specified index								*
*											*
*   @param  lpString1:dword, char:byte, int:dword					*
*   @return firstVal:dword  the position of the char value in the string(if found)	*
****************************************************************************************%	
String_indexOf2 proc Near32
	push ebp					;preserve base register
	mov ebp,esp					;set new stack frame
	push ebx					;preserve used registers
	push esi
	
	mov ebx,[ebp+8]		;string
	
	push ebx			;pushe string, for string_length
	call String_length	;get the length of the string (value in eax)
	add esp,4			;fix the stack
	
	mov ax, [ebp+12]	;character
	mov esi, [ebp+14]	;index
	cmp esi, eax		;checks if given index is greater than the length of the string
	jg charNotFound		;if index > length of string, exit
stLoop:
	cmp byte ptr [ebx+esi], 0	;checks for end of string	
	je charNotFound
	cmp byte ptr [ebx+esi], al	;compares char in string with the search char
	je charFound				;char found
	inc esi
	jmp stLoop
charFound:
	mov eax,esi		;stores the result(index of character) into eax
	jmp exit
charNotFound:	
	mov eax, -1		;character not found or given index larger than string length, return -1
exit:
	pop esi			;restore preserved registers
	pop ebx
	pop ebp
	RET	
String_indexOf2 endp

COMMENT %									
*****************************************************************************************
* Name: String_indexOf3									*
* Purpose:										*
*		Returns the position of the first occurence of a substring a string 	*
*											*
*   @param  lpString1:dword, lpSubStr:dword						*
*   @return firstVal:dword  the position of the string					*
****************************************************************************************%	
String_indexOf3 proc Near32
	push ebp					;preserve base register
	mov ebp,esp					;set new stack frame
	push ebx					;preserve used registers
	push esi
	push ecx
	push edx
	
	mov ebx,[ebp+8]		;string
	mov ecx,[ebp+12]	;substring
	mov esi,0
	
stLoop:
	mov edx,0
	mov dVal1, esi
subLoop:

	cmp byte ptr [ecx+edx],0	;checks for end of substring
	je found		;if substring ends exit

	cmp byte ptr [ebx+esi],0	;check end of string
	je strEnd		;end of string(substring not found), exit
	
	mov al, byte ptr[ebx+esi]	;store value at index of string
	inc esi	
	cmp byte ptr [ecx+edx],al	;compare value in substring with stroed value form string
	jne stLoop	;not equal, loops from stLoop
	inc edx
	jmp subLoop	;equal, loops from subLoop
found:
	mov eax,dVal1	;substring found, store index into eax
	jmp exit
strEnd:
	mov eax,-1	;substring not found, return -1
exit:
	pop edx
	pop ecx
	pop esi			;restore preserved registers
	pop ebx
	pop ebp
	RET	
String_indexOf3 endp

COMMENT %
*****************************************************************************************
* Name: String_toLowerCase								*			
* Purpose:										*						
*		Replaces any uppercase letter in a string with its lowercase verssion	*	    
*											*
*   @param  lpString1:dword								*						
*   @return lpString1:dword								*
****************************************************************************************%	
String_toLowerCase proc Near32
	push ebp					;preserve base register
	mov ebp,esp					;set new stack frame
	push ebx					;preserve used registers
	push esi
	push eax
	
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
	pop eax
	pop esi			;restore preserved registers
	pop ebx
	pop ebp
	RET	
String_toLowerCase endp

COMMENT %
*****************************************************************************************
* Name: String_toUpperCase								*								
* Purpose:										*										
*		Replaces any lowercase letter in a string with its uppercase verssion	*	    
*											*											*
*   @param  lpString1:dword								*								
*   @return lpString1:dword								*								
****************************************************************************************%	
String_toUpperCase proc Near32
	push ebp					;preserve base register
	mov ebp,esp					;set new stack frame
	push ebx					;preserve used registers
	push esi
	push eax
	
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
	pop eax
	pop esi			;restore preserved registers
	pop ebx
	pop ebp
	RET	
String_toUpperCase endp

COMMENT %								
*****************************************************************************************
* Name: String_replace									*								
* Purpose:										*										
*		Replaces all oldChars in string with NewChars				*					
*											*											*
*   @param  lpString1:dword oldChar:byte newChar:byte					*				
*   @return lpString1:dword								*								
****************************************************************************************%
String_replace proc Near32
	push ebp					;preserve base register
	mov ebp,esp					;set new stack frame
	push ebx					;preserve used registers
	push esi
	push ecx
	push eax
	
	mov ebx,[ebp+8]		;string
	mov ax, [ebp+12]	;old char
	mov cx, [ebp+14]	;new char
	mov esi,0					;esi indexes into the strings	
stLoop:
	cmp byte ptr[ebx+esi],0	;checks if it has reached the end of a string
	je finished				;if yes, exit
	cmp byte ptr[ebx+esi], al	;check the char in the string
	jne skip
	mov byte ptr[ebx+esi], cl	;replaces the char in the string
skip:
	inc esi					;if not, go to the next character
	jmp stLoop				;loops until you hit a NULL character
		
finished:
	pop eax
	pop ecx
	pop esi			;restore preserved registers
	pop ebx
	pop ebp
	RET
String_replace endp

COMMENT %								
*****************************************************************************************
* Name: String_lastIndexOf1								*								
* Purpose:										*										
*		Returns the last position in the string of the char value(if found)	*			
*	goes through the string backwards from a given index				*				
*											*											*
*   @param  lpString1:dword char:byte							*						
*   @return firstVal:dword  the position of the char value in the string(if found)	*	
****************************************************************************************%	
String_lastIndexOf1 proc Near32
	push ebp					;preserve base register
	mov ebp,esp					;set new stack frame
	push ebx					;preserve used registers
	push esi
	
	mov ebx,[ebp+8]		;string
	
	push ebx			;push the string
	call String_Length	;get the strings length
	add esp,4			;fix the stack
	mov esi,eax			;store string length into esi
	
	mov ax, [ebp+12]	;character
stLoop:
	cmp esi,-1		;checks if it has gone through the entire loop(nagivates through string backwards)
	je notFound
	cmp byte ptr [ebx+esi], al	;checks for the char in the string
	je charFound	;char found
	dec esi			;char not found
	jmp stLoop	;loops
charFound:
	mov eax,esi		;stores index into eax
	jmp exit
notFound:
	mov eax,-1	;char not found stores -1 into eax
exit:
	pop esi			;restore preserved registers
	pop ebx
	pop ebp
	RET	
String_lastIndexOf1 endp

COMMENT %								
*****************************************************************************************
* Name: String_lastIndexOf2								*								
* Purpose:										*										*
*		Returns the last position in the string of the char value(if found), 	*
*	starting from a specified index							*								
*											*								
*   @param  lpString1:dword, char:byte, int:dword					*
*   @return firstVal:dword  the position of the char value in the string(if found)	*
****************************************************************************************%	
String_lastIndexOf2 proc Near32
	push ebp					;preserve base register
	mov ebp,esp					;set new stack frame
	push ebx					;preserve used registers
	push esi
	
	mov ebx,[ebp+8]		;string
	
	push ebx			;pushes the string, for string_length
	call String_length	;get the length of the string (value in eax)
	add esp,4
	mov ecx,eax
	
	mov ax, [ebp+12]	;character
	mov esi, [ebp+14]	;index
	
	cmp esi, ecx		;checks if given index is greater than the length of the string
	jg charNotFound		;if index > length of string, exit
stLoop:
	cmp esi, -1		;checks for end of string	
	je charNotFound
	cmp byte ptr [ebx+esi], al	;compares char in string with the search char
	je charFound	;char found
	dec esi			;char not found
	jmp stLoop	;loops
charFound:
	mov eax,esi	;stores index of char
	jmp exit
charNotFound:	
	mov eax, -1	;char not found, stores -1 into eax
exit:
	pop esi			;restore preserved registers
	pop ebx
	pop ebp
	RET	
String_lastIndexOf2 endp

COMMENT %								
*****************************************************************************************
* Name: String_lastIndexOf3								*								
* Purpose:										*										
*	Returns the position of the last occurence of a substring within a string 	*	 	
*											*											*
*   @param  lpString1:dword, lpString2:dword						*					
*   @return firstVal:dword  the position of the last substring within string1		*	
****************************************************************************************%	
String_lastIndexOf3 proc Near32
	push ebp					;preserve base register
	mov ebp,esp					;set new stack frame
	push ebx					;preserve used registers
	push esi
	push ecx
	push edx
	
	mov ebx,[ebp+8]		;string
	mov ecx,[ebp+12]	;substring
	mov esi,0
	mov dVal2,-1	;if substring found, updates dVal2
	
stLoop:
	mov edx,0
	mov dVal1, esi ;store index of 1st substr val in dVal1
subLoop:
	mov eax,0
	
	cmp byte ptr [ecx+edx],0	;checks for end of substring(found in string)
	je found		;if substring ends store position

	cmp byte ptr [ebx+esi],0	;check end of string
	je exit		;if end of main string exit
	
	mov al, byte ptr[ebx+esi]	;store value at index of string
	inc esi	
	cmp byte ptr [ecx+edx],al	;compare value in substring with stroed value form string
	jne stLoop	;not equal, loop at stLoop
	inc edx
	jmp subLoop	;equal, loop at subLoop
found:
	mov eax, dVal1	;substr found, store 1st index into dVal2 
	mov dVal2,eax
	jmp stLoop
exit:
	mov eax,dVal2

	pop edx
	pop ecx
	pop esi			;restore preserved registers
	pop ebx
	pop ebp
	RET		
String_lastIndexOf3 endp

COMMENT %								
*****************************************************************************************
* Name: String_concat									*								
* Purpose:										*										
*	Takes two strings (string1, string2) and addds the second string to the end 	*
*	of the first									*									
*											*											*
*   @param  lpString1:dword, lpString2:dword						*					
*   @return lpNewString:dword (in eax)							*				  		
****************************************************************************************%	
String_concat proc Near32
	push ebp					;preserve base register
	mov ebp,esp					;set new stack frame
	push ebx					;preserve registers
	push esi
	push ecx
	push edx
			
	push [ebp+8]			;get length of string1
	call String_length
	add esp,4
	mov dVal1,eax	;store length of string1
	
	push [ebp+12]				;get length of string2
	call String_length
	add esp,4
	mov dVal2,eax	;store length of string2
	add eax, dVal1
	add eax,1		;get total length: string1 + string2 + null char
	
	INVOKE memoryallocBailey, eax	;allocate memory for string(address stored in eax)
	cmp eax,0						;returns 0 in eax if it cant allocate enough memory
	je memFail
	
	mov ebx,[ebp+8]		;string1
	mov esi,0			;index moving through strings
	mov edx,0	
	mov ecx,0			
storeStr1:			
	cmp dVal1,esi
	je startStr2
	
	mov dl, byte ptr[ebx+esi]	;moves char in first string to dl (byte register)
	mov byte ptr [eax+esi], dl	;move char from register into new string
	inc esi						;increment index
	jmp storeStr1				;loop
startStr2:
	mov ebx,[ebp+12]	;string2
storeStr2:
	cmp dVal2,ecx	;check for end of string2
	je addNull
	
	mov dl,byte ptr [ebx+ecx]	;get char from string2 and put it into new string
	mov byte ptr [eax+esi],dl
	inc esi
	inc ecx
	jmp storeStr2
addNull:
	mov word ptr[eax+esi],0		;add null char if finshed
	jmp exit
memFail:
	mov eax,-1				;couldnt allocate memory from heap, returns -1
exit:
	pop edx
	pop ecx
	pop esi			;restore preserved registers
	pop ebx
	pop ebp
	RET	
String_concat endp

end
