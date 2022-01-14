%include "../../io.mac"

section .data
    delimiters db " ,.", 0 ;global variable for delimiters

global get_words
global compare_func
global sort

section .text
    extern printf
    extern strlen
    extern strcmp
    extern qsort
    extern strtok

compare_func:
    enter 0, 0

    ;; Reading the parameters
    mov ebx, [ebp + 8]   ;char *first_word
    mov edx, [ebp + 12]  ;char *second_word

    mov ebx,  [ebx]
    mov edx,  [edx]

    ; PRINTF32`FIRST: %s\n\x0`, ebx
    ; PRINTF32`SECOND: %s\n\x0`, edx

    ; remembering the lengths of ebx in edx by calling the strlen function
    ; PRINTF32`%s\n\x0`, ebx
    push ebx
    call strlen
    add esp, 4
    ; PRINTF32`%d\n\x0`, eax
    mov ecx, eax
    xor eax, eax

    ;remembering the length of ecx in eax by calling the strlen function
    ; PRINTF32`%s\n\x0`, edx
    push edx
    call strlen
    add esp, 4
    ; PRINTF32`4\n\x0`

    ; comparing after length
    cmp eax, ecx
    ; PRINTF32`5\n\x0`
    je equal_strings ; if they are the same length compare lexicographically
    ; PRINTF32`6\n\x0`
    sub ecx, eax ;if not subtract one from another
    ; PRINTF32`7\n\x0`
    mov eax, ecx ;remembering the value in eax
    ; PRINTF32`8\n\x0`
    jmp end_comp_func ;and jump to terminate the function
    ; PRINTF32`9\n\x0`

equal_strings:
    ; if equal compare lexicographically by using strcmp
    push edx
    ; PRINTF32`10\n\x0`
    push ebx
    ; PRINTF32`11\n\x0`
    call strcmp ;remembering the retiurn value in eax
    ; PRINTF32`12\n\x0`
    add esp, 8
    ; PRINTF32`13\n\x0`

;finished the function
end_comp_func:
    ; PRINTF32`14\n\x0`
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
    PRINTF32`6\n\x0`
    add esp, 16
    PRINTF32`7\n\x0`

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
    jmp words_loop

end_get_words:
    leave
    ret
