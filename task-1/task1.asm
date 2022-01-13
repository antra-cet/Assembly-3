struc node
    	val: resd 1 ;the information field
   		next: resd 1 ;the next field
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

	xor edx, edx ;making edx on null, using it to add the nodes
	mov ecx, eax ;iterator for the given list
	xor eax, eax ;the final node to return

; Using edx to find the nodes in inverse order (n, n-1, .. , 1)
; Adding the nodes, starting by adding the last node (n value),
; then n-1 value and so on as shown :
; edx(val:n)   (val:n-1) edx(val:n) ... (val:1) edx(val:2) ... (val:n)
; ^ eax 	    ^eax				      ^eax

; edx serves as a next node remembering all the list
; until himself, and adding the first node later with eax
; eax always remembers the head

add_nodes_inorder:
	cmp ecx, 0 ;verifying if we added all the nodes
	jle function_end

	push edx ;keeping the old node (that at first is null)
	mov edx, ebx ;making edx the head to search a certain node
	jmp find_node ;finding the wanted node

node_found:
	mov eax, edx ;making the last found node the head
	pop edx ;retrieving the next node
	mov [eax + next], edx ;connecting the nodes
	mov edx, eax ;changing edx to remember the last added node

	sub ecx, 1
	jmp add_nodes_inorder ;continuing the loop of adding nodes

find_node:
	cmp [edx + val], ecx ;verifying if we found the node
	je node_found ;returning to the main loop if so

	add edx, 8 ;if not found continuing to search
	jmp find_node

function_end:
	leave
	ret
