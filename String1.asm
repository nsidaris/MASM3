
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
strNewline 	        byte 10,0 ;newline constant
strOutput dword ?
dOffset   dword ?

strTest1 byte 13,10,  "Parsing something for word 1", 13,10,  0
strTest2 byte 13,10, "Parsing something for word 2", 13,10,  0
strEmpty byte " ", 0
	.code

	
COMMENT %			;terminating symbol for the block is  								
 ****************************************************************************************
 * Name: String_length																	*
 * Purpose:																				*
 *		The purpose of the method is to determine the number of characters in a string	*
 *																						*
 * Date created: October 1, 2016														*
 * Date last modified: October 19, 2016													*
 *																						*																	*
 *																						*
 *   @param  lpString1:dword  															*
 *   @return len:dword  the length of a the string										*
 ***************************************************************************************%
;COMMENT %
String_length	proc Near32
	push ebp					;preserve base register
	mov ebp,esp					;set new stack frame
	;enter 0,0 
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
	pop ebx
	pop ebp
	;leave
	RET
String_length endp
 ; end of comment block

 COMMENT %			;terminating symbol for the block is  								
 ****************************************************************************************
 * Name: String_equals																    *
 * Purpose:																				*
 *		See if 2 strings are equal                                                  	*
 *																						*
 * Date created: October 1, 2016														*
 * Date last modified: October 19, 2016													*
 *																						*
 * Notes on specifications, special algorithms, and assumptions:						*
 *   notes go here. Omit these lines if there is no special algorithm or there were no	*
 *   assumptions.																		*
 *																						*
 *   @param  lpString1:dword, lpString2:dword  											*
 *   @return equal:byte  whether or not the strings are equal							*
 ***************************************************************************************%
String_equals  proc Near32

;enter 0,0  ;start method - EBP is now the stack frame
	push ebp					;preserve base register
	mov ebp,esp	      ; new stack frame
	push ebx 
	push ecx   ;saving registers
	push esi
	push edx 
	
	push [ebp + 8]     ;push first string onto stack(ebp + 4 is return address )
	call String_length 
	mov ebx, eax   ;save the length

	
	push [ebp + 12] ; push second string onto stack
	call String_length
	mov edx, eax
	
	cmp ebx, edx
	je  EvenLength
	jne UnevenLength
; accounts for uneven length or character mismatch
UnevenLength:
	mov eax, 0
	jmp finish
	
equalStrings:

	mov eax, 1
	jmp finish
EvenLength:
	mov ecx, edx         ;use to store length of the strings and serve as upper loop boundary
	mov edx, [ebp + 8]   ;store string 1
	mov ebx, [ebp + 12]  ;store string 2
	mov esi, 0
	
checkChar:
	mov al, [edx + esi]
	mov ah, [ebx + esi]
	cmp ah, al
	jne UnevenLength
	inc ESI
	cmp esi, ecx ; we have reached the end of the string and they are the same at this point
	je equalStrings
	jne checkChar
	

	
finish:
	pop edx
	pop esi ;restore registers
	pop ecx
	pop ebx

	
	add esp, 8
	pop ebp	

	
	;leave      ;Finish method
	RET

String_equals endp


 COMMENT %			;terminating symbol for the block is  								
 ****************************************************************************************
 * Name: String_equalsIgnoreCase												        *
 * Purpose:																				*
 *		See if 2 strings are equal, ignores upper vs lowercase                        	*
 *																						*
 * Date created: October 1, 2016														*
 * Date last modified: October 19, 2016													*
 *																						*
 * Notes on specifications, special algorithms, and assumptions:						*
 *   notes go here. Omit these lines if there is no special algorithm or there were no	*
 *   assumptions.																		*
 *																						*
 *   @param  lpString1:dword, lpString2:dword  											*
 *   @return equal:byte  whether or not the strings are equal							*
 ***************************************************************************************%

String_equalsIgnoreCase proc Near32

;enter 0,0  ;start method - EBP is now the stack frame
	push ebp					;preserve base register
	mov ebp,esp	      ; new stack frame
	push ebx 
	push ecx   ;saving registers
	push esi
	push edx 
	
	push [ebp + 8]     ;push first string onto stack(ebp + 4 is return address )
	call String_length 
	mov ebx, eax   ;save the length

	
	push [ebp + 12] ; push second string onto stack
	call String_length
	mov edx, eax
	
	cmp ebx, edx
	je  EvenLength
	jne UnevenLength
; accounts for uneven length or character mismatch
UnevenLength:
	mov eax, 0
	jmp finish
	
equalStrings:

	mov eax, 1
	jmp finish
EvenLength:
	mov ecx, edx         ;use to store length of the strings and serve as upper loop boundary
	mov edx, [ebp + 8]   ;store string 1
	mov ebx, [ebp + 12]  ;store string 2
	mov esi, 0
	
checkChar1:
	mov al, [edx + esi]

lower1:
	cmp al, 64
	jl checkChar2
	cmp al, 91
	jg checkChar2
	
	;Invoke putString, ADDR strTest1
	add al, 32

checkChar2:
	mov ah, [ebx + esi]
lower2:
	cmp ah, 64
	jl compare
	cmp ah, 91
	jg compare

	;Invoke putString, ADDR strTest2
	add ah, 32
compare:	;
	cmp ah, al
	jne UnevenLength
	inc ESI
	cmp esi, ecx ; we have reached the end of the string and they are the same at this point
	je equalStrings
	jne checkChar1
	

	
finish:
	pop edx
	pop esi ;restore registers
	pop ecx
	pop ebx

	
	add esp, 8
	pop ebp	

	
	;leave      ;Finish method
	RET
	
	
String_equalsIgnoreCase endp	

 COMMENT %			;terminating symbol for the block is  								
 ****************************************************************************************
 * Name: String_copy															        *
 * Purpose:																				*
 *		Copies a string                                                             	*
 *																						*
 * Date created: October 1, 2016														*
 * Date last modified: October 19, 2016													*
 *																						*
 * Notes on specifications, special algorithms, and assumptions:						*
 *   notes go here. Omit these lines if there is no special algorithm or there were no	*
 *   assumptions.																		*
 *																						*
 *   @param  lpString1:dword										                    *
 *   @return string:dword	                                        					*
 ***************************************************************************************%
String_copy proc Near32

	push ebp					;preserve base register
	mov ebp,esp	      ; new stack frame
	push ebx 
	push ecx   ;saving registers
	push esi
	push edx 
	

	push [ebp + 8] ;push the string to the stack
	call String_length 
	mov ecx, eax   ;save the length of the string
	add esp, 4
	
	
	Invoke memoryallocBailey, ecx
	mov esi, 0
	
	mov ebx, [ebp + 8]
	mov edx, eax
buildString:
	
	mov al, [ebx + esi]
	mov [EDX + ESI], al
	inc esi
	loop buildString
	
		
	
	mov eax, edx
	pop edx
	
	pop esi ;restore registers
	pop ecx
	pop ebx
	pop ebp

	RET

String_copy endp
 COMMENT %			;terminating symbol for the block is  								
 ****************************************************************************************
 * Name: String_substring_1														        *
 * Purpose:																				*
 *		Returns a section of a string                                                 	*
 *																						*
 * Date created: October 1, 2016														*
 * Date last modified: October 19, 2016													*
 *																						*
 * Notes on specifications, special algorithms, and assumptions:						*
 *   notes go here. Omit these lines if there is no special algorithm or there were no	*
 *   assumptions.																		*
 *																						*
 *   @param  lpString1:dword	                                                        *
 *   @param  beginIndex:int start index                                                 *
 *	 @param endIndex:int    end index                                                   *
 *   @return string:dword	                                     					    *
 ***************************************************************************************%
String_substring_1 proc Near32
	push ebp					;preserve base register
	mov ebp,esp	      ; new stack frame
	push ebx 
	push ecx   ;saving registers
	push esi
	push edx    ; new stack frame
	
	
	
	mov ebx, [ebp + 8] ; save string
	mov edx, [ebp + 12] ;start index
	mov ecx, [ebp + 16] ;end index
	cmp ecx, edx
	jl Invalid
	push [ebp + 8]
	call String_length
	add esp, 4
	cmp edx, eax
	jg Invalid
	
	;make sure they are gud
	add ecx, 1 ; account for the null char
	sub ecx, edx ; ecx is the length of the substring
	mov esi, edx ;save start index to esi
	

	Invoke memoryallocBailey, ecx  ;allocate memory
	
	
	mov dOffset, esi  ;find the offset for copying 
	mov edx, eax
buildString:

	mov al, [ebx + esi]  ;get the first character
	push esi
	sub esi, dOffset     ;calc the offset to save the character
	mov [EDX + ESI], al
	pop esi
	inc esi      
	loop buildString   ;loop until finished with 
	
		
	mov al, 0 ;add dat Null
	
	mov [EDX + ESI], al 
	mov eax, edx
	
	

	
	pop edx
	pop esi ;restore registers
	pop ecx
	pop ebx
	pop ebp

	ret
	
Invalid:
	pop edx
	pop esi ;restore registers
	pop ecx
	pop ebx
	pop ebp
	mov eax, -1

	ret
String_substring_1 endp




String_substring_2 proc Near32
	push ebp					;preserve base register
	mov ebp,esp	      ; new stack frame
	push ebx 
	push ecx   ;saving registers
	push esi
	push edx    ; new stack frame

	push [ebp + 8]
	call String_length
	add esp, 4
	;need to make sure start index is greater than length of the string
	

	;use substring 1 to get the substring, use length of the string as teh 
	push eax
	push [ebp + 12]
	push [ebp + 8 ]
	call String_substring_1
	add esp, 12
	
	
	pop edx
	pop esi ;restore registers
	pop ecx
	pop ebx
	pop ebp

	ret


	
String_substring_2 endp




String_charAt proc Near32

	push ebp					;preserve base register
	mov ebp,esp	      ; new stack frame
	push ebx 
	push ecx   ;saving registers
	push esi
	push edx    ; new stack frame
	
	push [ebp +8]
	call String_length
	add esp, 4
	mov edx, [ebp + 12]
	cmp edx, eax
	jg Invalid
	
	push [ebp + 12]
	push [ebp + 12]
	push [ebp +8]
	call String_substring_1
	add esp, 12

	
	
	

	pop edx
	pop esi ;restore registers
	pop ecx
	pop ebx
	pop ebp

	ret
	
Invalid:

	mov eax, -1
	pop edx
	pop esi ;restore registers
	pop ecx
	pop ebx
	pop ebp

	ret
String_charAt endp




String_startsWith_1 proc Near32

	push ebp					;preserve base register
	mov ebp,esp	      ; new stack frame
	push ebx 
	push ecx   ;saving registers
	push esi
	push edx    ; new stack frame

	mov ebx, [ebp + 16]  ;save start position
	
	push [ebp + 8]
	call String_length
	add esp, 4
	cmp eax, ebx
	jl Invalid
	
	push [ebp + 12] 
	call String_length ; get length of the prefix

	
	add esp, 4
	add eax, ebx 
	sub eax, 1    ;eax should now have the end pos

	
	
	push eax
	push ebx   ;push the start pos
	push [ebp+8] 
	
	call String_substring_1
	add esp, 12

	
	
	push EAX
	push [ebp + 12]
	call String_equals
	add esp, 8
	
	

	pop edx
	pop esi ;restore registers
	pop ecx
	pop ebx
	pop ebp

	ret
	
	
	
Invalid:

	mov eax, -1
	pop edx
	pop esi ;restore registers
	pop ecx
	pop ebx
	pop ebp

	ret
String_startsWith_1 endp

String_startsWith_2 proc Near32

	push ebp					;preserve base register
	mov ebp,esp	      ; new stack frame
	push ebx 
	push ecx   ;saving registers
	push esi
	push edx    ; new stack frame
	
	
	mov eax, 0
	push eax
	push [ebp + 12]
	push [ebp +  8]
	call String_startsWith_1
	add esp, 12
	
	
	
	pop edx
	pop esi ;restore registers
	pop ecx
	pop ebx
	pop ebp

	ret

String_startsWith_2 endp

String_endsWith proc Near32


	push ebp					;preserve base register
	mov ebp,esp	      ; new stack frame
	push ebx 
	push ecx   ;saving registers
	push esi
	push edx    ; new stack frame
	
	
	push [ebp + 8]
	call String_length  ;get the length of the main string
	add esp, 4
	mov ebx, eax
	
	push [ebp + 12]
	call String_length  ;get the length of the suffix
	
	add esp, 4
	
	;error check
	
	
	sub ebx, eax ; find the start indez
	 
	push ebx 
	push [ebp + 8]
	call String_substring_2
	add esp, 8
	
	
	push eax
	push [ebp + 12]
	call String_equals
	add esp, 8
	


	pop edx
	pop esi ;restore registers
	pop ecx
	pop ebx
	pop ebp

	ret

String_endsWith endp



end