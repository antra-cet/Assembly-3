section .text
	global cmmmc
	extern printf

;; int cmmmc(int a, int b)
;
;; calculate least common multiple for 2 numbers, a and b
cmmmc:
	;enter
	push ebp
	push esp
	pop ebp

	;Reading the variables in ecx and edx
	xor ecx, ecx
	add ecx, dword [ebp + 8] ;int a
	xor ebx, ebx
	add ebx, dword [ebp + 12] ;int b

; Using the euclidian formula for calculating the
; biggest common divisor, then using the formula 
; cmmmc * cmmdc = a * b => cmmmc = (a*b)/cmmdc

; Using eax to remember a * b
	xor eax, eax ; making it on 0
	add eax, ecx ; remembering the "a" value
	xor edx, edx ; using edx as an intermediate
	add edx, ebx ; so that ebx doesn't change
	imul edx ; multiplicating with b (edx)

; Finding the biggest common divisor
cmmmc_start:
	cmp ecx, ebx ;comparing the two (a and b)
	je end_cmmmc ;if equal we found the divisor
	jg sub_ecx ;if one is bigger we subtract
	jl sub_ebx ;from that the other value
	
; subtracting the value of b from a
sub_ecx:
	sub ecx, ebx
	jmp cmmmc_start

; subtracting the value of a from b
sub_ebx:
	sub ebx, ecx
	jmp cmmmc_start

end_cmmmc:
	; Calculating cmmmc after the formula (a*b)/cmmdc
	; having the cmmdc in either ecx or edx, having
	; the answer now in eax
	div ecx

	;leave
	push ebp
	pop esp
	pop ebp
	ret
