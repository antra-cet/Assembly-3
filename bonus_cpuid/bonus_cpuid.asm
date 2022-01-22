section .text
	global cpu_manufact_id
	global features
	global l2_cache_info

;; void cpu_manufact_id(char *id_string);
;
;  reads the manufacturer id string from cpuid and stores it in id_string
cpu_manufact_id:
	enter 	0, 0
	
	; pushing the registers
	push ebx
	push ecx
	push edx

	; Reading the variables
	mov ebx, [ebp + 8] ;char *id_string
	
	; retrieving the variables
	pop edx
	pop ecx
	pop ebx

	leave
	ret

;; void features(char *vmx, char *rdrand, char *avx)
;
;  checks whether vmx, rdrand and avx are supported by the cpu
;  if a feature is supported, 1 is written in the corresponding variable
;  0 is written otherwise
features:
	enter 	0, 0

	; pushing the registers
	push ebx
	push ecx
	push edx

	; Reading the variables
	mov ebx, [ebp + 8] ;char *vmx
	mov edx, [ebp + 12] ;char *rdrand
	mov eax, [ebp + 16] ;char *avx
	
	; retrieving the variables
	pop edx
	pop ecx
	pop ebx

	leave
	ret

;; void l2_cache_info(int *line_size, int *cache_size)
;
;  reads from cpuid the cache line size, and total cache size for the current
;  cpu, and stores them in the corresponding parameters
l2_cache_info:
	enter 	0, 0

	; pushing the registers
	push ebx
	push ecx
	push edx

	; Reading the variables
	mov ebx, [ebp + 8] ;int *line_size
	mov edx, [ebp + 12] ;int *cache_size
	
	; retrieving the variables
	pop edx
	pop ecx
	pop ebx
	
	leave
	ret
