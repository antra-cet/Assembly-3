section .data
    delimiters db " ,.", 0 ;global variable for delimiters

global get_words
global compare_func
global sort

section .text ;added all the needed external libc functions
    extern strlen ;strlen to get a strings length
    extern strcmp ;strcmp to compare lexicographically two strings
    extern qsort ;called the qsort to sort the words
    extern strtok ;to get the words from the text

;the compare function is called in the qsort
compare_func:
    enter 0, 0

    ; pushing all the registers because some of the functions
    ; called change them
    push ebx
    push edx
    push ecx
    push edi
    push esi

    ;; Reading the parameters
    mov ebx, [ebp + 8]   ;char *first_word
    mov edx, [ebp + 12]  ;char *second_word

    ; because we read the registers as pointers, we want to work
    ; with them as strings so we change their values
    ; from pointing to a certain memory place to having
    ; the value of the pointer
    mov ebx, [ebx] ;changing the first word to become a string
    mov edx, [edx] ;changing the second word to become a string

    ; strlen changes the edx register so we push it in order
    ; to not loose the string
    ; now, our stack has the second word on top
    push edx

    ;remembering the length of ebx in eax by calling the strlen function
    push ebx
    call strlen
    add esp, 4

    ; eax contains now the string length of the first word
    ; we pop the second word and also push on the stack
    ; the length of the first word
    pop edx
    push eax

    ; as mentioned before, strlen changes the value of the edx register
    ; so, by using the eax register we remember the value of the second
    ; word and then push it on the stack
    mov eax, edx
    push eax

    ; remembering the length of edx in eax by calling the strlen function
    push edx
    call strlen
    add esp, 4

    ; getting back the second word
    pop edx

    ; the stack also contained the length of the first word, so because eax
    ; now contains the length of the second word, we remember the
    ; first word's length in ecx
    pop ecx

    cmp eax, ecx ; comparing after length
    je equal_strings ; if they are the same length compare lexicographically with strcmp
    sub ecx, eax ;if not subtract one from another in the correct order
    mov eax, ecx ;so eax contains the correct answer
    jmp end_comp_func ;and jump to terminate the function

equal_strings:
    ; if equal lengths compare lexicographically by using strcmp
    push edx
    push ebx
    call strcmp ;remembering the return value in eax
    add esp, 8

;finished the function
end_comp_func:
    ; because at the beginning we pushed all the registers
    ; on the stack to not loose their
    ; values, at the end we need to retrieve them
    pop esi
    pop edi
    pop ecx
    pop edx
    pop ebx

    leave
    ret

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru sortarea cuvintelor 
;  dupa lungime si apoi lexicografic
sort:
    enter 0, 0

    ;; Reading the parameters
    mov ebx, [ebp + 8]   ;char **words
    mov ecx, [ebp + 12]  ;int number_of_words
    mov edx, [ebp + 16]  ;int size

    ;; calling the qsort function by firstly
    ;; putting on the stack in the correct order
    ;; the parameters
    push compare_func ;putting the compare function
    push edx ;putting the size
    push ecx ;putting the number of words
    push ebx ;putting the words
    call qsort ;calling the function
    add esp, 16

    leave
    ret

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    enter 0, 0

    ;; Reading the parameters
    mov edx, [ebp + 8]   ;char *s
    mov ebx, [ebp + 12]  ;char **words
    mov ecx, [ebp + 16]  ;int number_of_words

    ; separating the words using strtok
    push delimiters
    push edx
    call strtok
    add esp, 8

    ;making ecx 0 so we can add each word in the edx register
    xor ecx, ecx
    push ecx

words_loop:
    cmp eax, 0 ;verifying if there are no more words
    je end_get_words ;terminating the loop if so

    ; adding the word in the edx register
    pop ecx
    mov dword [ebx + ecx], eax
    ; using ecx to iterate through the words
    add ecx, 4
    push ecx

    ; going to the next word with strtok
    push delimiters ;pushing the delimiters
    push 0 ;pushing the NULL element
    call strtok ;calling the function
    add esp, 8
    jmp words_loop ;continuing the loop

end_get_words:
    leave
    ret
