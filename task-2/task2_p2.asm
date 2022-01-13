section .text
	global par

;; int par(int str_length, char* str)
;
; check for balanced brackets in an expression
par:

	;enter
	push ebp
	push esp
	pop ebp

	;Reading the variables
	xor ebx, ebx
	add ebx, dword [ebp + 8] ;int str_length
	xor edx, edx
	add edx, dword [ebp + 12] ;char *str

	; using ecx to iterate through the string
	xor ecx, ecx ;setting it on 0

	; using eax to remember how many opened
	; paranthesis were closed (adding 1 each time
	; we find an opened one and subtracting 1 if
	; a closed one is found). At the end the result
	; is 0 if all were closed and not 0 if something is
	; incorrect. Also taking into consideration this
	; example ))()((, which is also incorrect but will return 1.
	; Conditioning eax to remain > 0.
	xor eax, eax ;setting it on 0 first

verify_par:
	cmp ecx, ebx
	jge end_par ;iterating through the string
	
	; verifying if we are upon a opened paranthesis
	cmp byte [edx + ecx], '('
	je opened

    ; verifying if we are upon a closed paranthesis
	cmp byte [edx + ecx], ')'
	je closed

continue_verify_par:
	cmp eax, 0 ;verifying if there are more closed
	jl end_par ;paranthesis before the opened ones

	add ecx, 1 ;adding 1 to continue the search
	jmp verify_par

; adding 1 to eax in case we find an opened paranthesis
opened:
	add eax, 1
	jmp continue_verify_par

; subtracting 1 to eax in case we find an opened paranthesis
closed:
	sub eax, 1
	jmp continue_verify_par

; after calculating eax, we check if all the opened
; paranthesis were also closed
end_par:
	; if so, we make eax 1
	cmp eax, 0
	je make_1
	
	; if not, we make it 0 and jumping to leave
	xor eax, eax
	jmp leave_par

; making eax 1 because the string is correct
make_1:
	xor eax, eax
	add eax, 1

leave_par:
	;leave
	push ebp
	pop esp
	pop ebp
	ret
