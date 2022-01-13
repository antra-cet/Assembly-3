%include "../../io.mac"

struc node
    	val: resd 1
   		next: resd 1
endstruc

section .text
	global sort
	extern printf

;; struct node* sort(int n, struct node* node);
; 	The function will link the nodes in the array
;	in ascending order and will return the address
;	of the new found head of the list
; @params:
;	n -> the number of nodes in the array
;	node -> a pointer to the beginning in the array
; @returns:
;	the address of the head of the sorted list
sort:
	enter 0, 0

	;; Reading the parameters
    mov eax, [ebp + 8]   ;int n
    mov ebx, [ebp + 12]  ;struct node *node

	xor edx, edx ;making edx on null
	mov ecx, eax ;iterator
	xor eax, eax ;the final node to return

; Using edx to find the last node (n, n-1, .. , 1)
; Adding the nodes in a inverse order, starting by adding the last node (n value)
; edx(val :n)   (val:n-1) edx(val:n) ... (val:1) edx(val:2) ... (val:n)
; ^ eax 	    ^eax				      ^eax

add_nodes_inorder:
	cmp ecx, 0
	jle function_end

	push edx ;keeping the old node
	mov edx, ebx ;making edx the head
	jmp find_node ;finding the wanted node

node_found:
	mov eax, edx ;making the last found node the head
	pop edx ;retrieving the last node
	mov [eax + next], edx ;connecting the nodes
	mov edx, eax

	sub ecx, 1
	jmp add_nodes_inorder ;continuing the loop

find_node:
	cmp [edx + val], ecx ;verifying if we found the node
	je node_found

	add edx, 8 ;if not found continuing to search
	jmp find_node

function_end:
	leave
	ret
