
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


strTest1 byte 13,10,  "Parsing something for word 1", 13,10,  0
strTest2 byte 13,10, "Parsing something for word 2", 13,10,  0

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
compare:	
	
	
	
	
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
	
	
parse1:

	jmp checkChar2


parse2:

	jmp compare
	
String_equalsIgnoreCase endp	
end