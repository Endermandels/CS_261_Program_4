; Elijah Delavar
; CS 261
; 5/6/2023
; start.asm encoder.asm Makefile

section .data
desc1:  db "        msg: "
ld1:    equ $-desc1
desc2:  db "encoded msg: "
ld2:    equ $-desc2
desc3:  db "decoded msg: "
ld3:    equ $-desc3
newline:    db 10
section .bss
section .text
global encode
global decode
    
    ; void encode(char *msg, int len, int shift) {
    ;   int n = shift;
    ;   for (int i = 0; i < len; i++) {
    ;     char c = msg[i];
    ;     if (c < 97 || c > 122) {
    ;       n *= -1;
    ;       continue;
    ;     }
    ;     if (!(c > 96 + n)) {
    ;       msg[i] = 26 + c;
    ;     }
    ;     else if (!(c < 123 + n)) {
    ;       msg[i] = -26 + c;
    ;     }
    ;     msg[i] -= n;
    ;     n *= -1;
    ;   }
    ; }
    
    
; encode msg by shift
; arg3: shift
; arg2: len
; arg1: msg
encode:
    ; EAX: n
    ; EBX: msg
    ; ECX: i
    ; EDX: len, c
    push ebp
    mov ebp, esp
    
    push eax
    push ebx
    push ecx
    push edx
    
    xor eax, eax
    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx
    
    mov ebx, [ebp+8]    ; msg
    mov edx, [ebp+12]   ; len
    mov ax, [ebp+16]    ; n = shift
    mov ecx, 0          ; i = 0
    
    push ecx
    push edx
    mov ecx, desc1
    mov edx, ld1
    call printDesc
    pop edx
    pop ecx
    
    call print
    
for:
    cmp ecx, edx
    jnb done            ; if (i >= len) break
    
    push edx
    mov edx, 0
    mov dl, [ebx+ecx]   ; c = msg[i]
    
    cmp dl, 97
    jb continue         ; if (c < 97) continue
    
    cmp dl, 122
    ja continue         ; if (c > 122) continue

checkA:
    push ecx
    mov cl, 96
    add cl, al
    
    cmp dl, cl
    pop ecx
    ja checkZ               ; c > 96 + n
    
    push eax
    mov al, 26
    add al, dl
    
    mov [ebx+ecx], al       ; msg[i] = 26 + c
    pop eax

    jmp normalShift         ; else if
    
checkZ:
    push ecx
    mov cl, 123
    add cl, al

    cmp dl, cl
    pop ecx
    jb normalShift          ; c < 123 + n
    
    push eax
    mov al, -26
    add al, dl
    
    mov [ebx+ecx], al       ; msg[i] = -26 + c
    pop eax

normalShift:
    sub [ebx+ecx], eax      ; msg[i] -= n
    
continue:
    push ebx
    mov ebx, -1
    imul ebx            ; n *= -1
    pop ebx
    
    pop edx
    inc ecx             ; i++
    jmp for
    
done:
    push ecx
    push edx
    mov ecx, desc2
    mov edx, ld2
    call printDesc
    pop edx
    pop ecx

    call print
    pop eax
    pop ebx
    pop ecx
    pop edx
    
    mov esp, ebp
    pop ebp
    ret
    
    ; void decode(char *msg, int len, int shift) {
    ;   int n = shift;
    ;   for (int i = 0; i < len; i++) {
    ;     char c = msg[i];
    ;     if (c < 97 || c > 122) {
    ;       n *= -1;
    ;       continue;
    ;     }
    ;     if (!(c > 96 - n)) {
    ;       msg[i] = 26 + c;
    ;     }
    ;     else if (!(c < 123 - n)) {
    ;       msg[i] = -26 + c;
    ;     }
    ;     msg[i] += n;
    ;     n *= -1;
    ;   }
    ; }
    
; decode msg by shift
; arg3: shift
; arg2: len
; arg1: msg
decode:
    ; EAX: n
    ; EBX: msg
    ; ECX: i
    ; EDX: len, c
    push ebp
    mov ebp, esp
    
    push eax
    push ebx
    push ecx
    push edx
    
    xor eax, eax
    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx
    
    mov ebx, [ebp+8]    ; msg
    mov edx, [ebp+12]   ; len
    mov ax, [ebp+16]    ; n = shift
    mov ecx, 0          ; i = 0
    
for2:
    cmp ecx, edx
    jnb done2           ; if (i >= len) break
    
    push edx
    mov edx, 0
    mov dl, [ebx+ecx]   ; c = msg[i]
    
    cmp dl, 97
    jb continue2         ; if (c < 97) continue
    
    cmp dl, 122
    ja continue2         ; if (c > 122) continue

checkA2:
    push ecx
    mov cl, 96
    sub cl, al
    
    cmp dl, cl
    pop ecx
    ja checkZ2              ; c > 96 - n
    
    push eax
    mov al, 26
    add al, dl
    
    mov [ebx+ecx], al       ; msg[i] = 26 + c
    pop eax

    jmp normalShift2        ; else if

checkZ2:
    push ecx
    mov cl, 123
    sub cl, al

    cmp dl, cl
    pop ecx
    jb normalShift2         ; c < 123 - n
    
    push eax
    mov al, -26
    add al, dl
    
    mov [ebx+ecx], al       ; msg[i] = -26 + c
    pop eax

normalShift2:
    add [ebx+ecx], eax      ; msg[i] += n
    
continue2:
    push ebx
    mov ebx, -1
    imul ebx            ; n *= -1
    pop ebx
    
    pop edx
    inc ecx             ; i++
    jmp for2

done2:
    push ecx
    push edx
    mov ecx, desc3
    mov edx, ld3
    call printDesc
    pop edx
    pop ecx

    call print
    pop eax
    pop ebx
    pop ecx
    pop edx
    
    mov esp, ebp
    pop ebp
    ret
    
; ECX: which description (1,2,3)
; EDX: length of description
printDesc:
    push eax
    push ebx
    
    mov eax, 4
    mov ebx, 1
    int 0x80
    
    pop ebx
    pop eax
    ret

; EBX: msg
; EDX: len
print:
    push eax
    push ebx
    push ecx
    
    mov eax, 4      ; print syscall
    mov ecx, ebx    ; msg
    mov ebx, 1      ; to stdout
    int 0x80        ; print(stdout, msg, len)
    
    push edx
    mov eax, 4
    mov ecx, newline
    mov ebx, 1
    mov edx, 1
    int 0x80
    pop edx
    
    pop ecx
    pop ebx
    pop eax
    ret
