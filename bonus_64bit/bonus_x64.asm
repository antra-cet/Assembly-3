section .text
	global intertwine

;; void intertwine(int *v1, int n1, int *v2, int n2, int *v);
;
;  Take the 2 arrays, v1 and v2 with varying lengths, n1 and n2,
;  and intertwine them
;  The resulting array is stored in v
intertwine:
	enter 0, 0

	; pushing all the used registers
	push rbx
	push r12
	push r13
	push r14
	push r15

	; Getting the parameters
	; rdi has the first array
	; rsi has the first array size
	; rdx has the second array
	; rcx has the second array size
	; r8 has the final array to return

	xor rbx, rbx ;using it to iterate through the v array
	xor r12, r12 ;using it to iterate through the first array
	xor r13, r13 ;using it to iterate through the second array

int_loop:
	cmp r12, rsi ;verifying if the first array has ended
	jge verify_second ;if so, verifying if the second has any elements left
	cmp r13, rcx ;verifying if the second array has ended
	jge verify_first ;if so, verifying if the first has any elements left

	mov eax, dword [rdi + r12 * 4] ; storing the value at the current position
	mov dword [r8 + rbx], eax ;putting the value in the final array
	add qword rbx, 4 ;iterating through v

	mov eax, dword [rdx + r13 * 4] ;at the current position storing the value
	mov dword [r8 + rbx], eax ;putting the value in the final array
	add qword rbx, 4 ;iterating through v

	add qword r12, 1 ;iterating through first array
	add qword r13, 1 ;iterating through second array
	jmp int_loop ;continuing the loop

verify_second:
	cmp r13, rcx ;verifying if the second array has any elements left
	jge end_int ;if it doesn't ending the function

	mov eax, dword [rdx + r13 * 4] ;at the current position storing the value
	mov dword [r8 + rbx], eax ;putting the value in the final array
	add qword rbx, 4 ;iterating through v

	add qword r13, 1 ;iterating through the second array
	jmp verify_second ;continuing the loop

verify_first:
	cmp r12, rsi ;verifying if the first array has any elements left
	jge end_int ;if it doesn't ending the function

	mov eax, dword [rdi + r12 * 4] ;at the current position storing the value
	mov dword [r8 + rbx], eax ;putting the value in the final array
	add qword rbx, 4 ;iterating through v

	add qword r12, 1 ;iterating through the first array
	jmp verify_first ;continuing the loop

end_int:
	; retrieving all the registers
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx

	; finishing the function
	leave
	ret
