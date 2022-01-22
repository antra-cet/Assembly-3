/*
 * Don't forget to include "positions.h"
 */
#include "positions.h"

.section .text
.global add_vect

/* 
 * void add_vect(int *v1, int *v2, int n, int *v)
 *
 * add v1 and v2, that have both the length n, and store the result in v3.
 * also, substract from v3 the vlues provided in positions.S, as described
 * in the task
 */

add_vect:
	pushl 	%ebp
	movl	%esp, %ebp

	// Reading the parameters
	movl 8(%ebp), %ebx //int *v1
	movl 12(%ebp), %edx //int *v2
	movl 16(%ebp), %ecx  //int n
	movl 20(%ebp), %esi //int *v

	movl %ecx, %eax //remembering the number of elements
	dec %ecx // starting point of the array

add_loop:
	cmpl $0, %ecx //using ecx to iterate through the two vectors
	jl end_add_vect // verifying if the loop has ended and if we
	// should subtract the given values from the header

	push %eax //using the eax register
	movl (%ebx, %ecx, 4), %eax // to remember the value at the v1 vector
	movl %eax, (%esi, %ecx, 4) // and moving its value in the final vector

	movl (%edx, %ecx, 4), %eax  // using the eax register to remember the value at the v2 vector
	addl %eax, (%esi, %ecx, 4) // and adding its value in the final vector
	pop %eax // retrieving the original eax

	// Verifying if we need to subtract any value from the eax vector
	push %ebx // using the two registers and pushing them on the stack
	push %edx // so that we remember the arrays

	movl $FIRST_POSITION, %ebx // calculating the relative position
	imul %ebx // by mulyiplying n (in the eax register)
	push %esi // and then using esi to devide by 10
	movl $10, %esi
	idiv %esi // deviding by 10
	pop %esi // retrieving the originak
	cmpl %eax, %ecx //comparing if the current position is equal to the
	je first_position_subtract // first relativ position and subtarcting if so

	push %esi // if it's not equal, calculating back the number of elements
	movl $10, %esi // in the array
	imul %esi // by multiplying by 10 and then
	pop %esi 
	idivl %ebx // deviding by first position

	movl $SECOND_POSITION, %ebx // doing the same for the second position
	imul %ebx // calculating the relative position
	push %esi
	movl $10, %esi
	idiv %esi
	pop %esi
	cmpl %eax, %ecx // comparing the current position with it
	je second_position_subtract // and subtracting if necessary

	push %esi // retrieving the original number of elements in the array
	movl $10, %esi
	imul %esi
	pop %esi
	idivl %ebx
	
	movl $THIRD_POSITION, %ebx // Calculating the third relavtive position
	imul %ebx
	push %esi
	movl $10, %esi
	idiv %esi
	pop %esi
	cmpl %eax, %ecx //comparing the two and
	je third_position_subtract //subtracting if necessary

	push %esi //recalculating again the n number of elements
	movl $10, %esi // if the above jump was not done
	imul %esi
	pop %esi
	idivl %ebx

continue_loop:
	// retrieving the two arrays
	pop %edx
	pop %ebx

	dec %ecx // decrementing the current position and
	jmp add_loop // continuing the loop

first_position_subtract:
	// subtracting the FIRST_VALUE from the first relative position
	// that is held in the eax register
	push %eax
	movl $FIRST_VALUE, %eax
	sub %eax, (%esi, %ecx, 4)
	pop %eax

	// Recalculating the n value in the eax register
	push %esi
	movl $10, %esi
	imul %esi
	pop %esi
	idivl %ebx
	jmp continue_loop // continuing the initial loop

second_position_subtract:
	// subtracting the SECOND_VALUE from the second relative position
	// that is held in the eax register
	push %eax
	movl $SECOND_VALUE, %eax
	sub %eax, (%esi, %ecx, 4)
	pop %eax

	// Recalculating the n value in the eax register
	push %esi
	movl $10, %esi
	imul %esi
	pop %esi
	idivl %ebx
	jmp continue_loop // continuing the initial loop

third_position_subtract:
	// subtracting the THIRD_VALUE from the third relative position
	// that is held in the eax register
	push %eax
	movl $THIRD_VALUE, %eax
	sub %eax, (%esi, %ecx, 4)
	pop %eax

	// Recalculating the n value in the eax register
	push %esi
	movl $10, %esi
	imul %esi
	pop %esi
	idivl %ebx
	jmp continue_loop // continuing the initial loop

end_add_vect:
	// Finishing the function
	leave
	ret
