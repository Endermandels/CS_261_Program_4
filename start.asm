; Elijah Delavar
; CS 261
; 5/6/2023
; start.asm encoder.asm Makefile

; Compiling:
;	nasm -f elf -g -F dwarf start.asm
;	nasm -f elf -g -F dwarf encoder.asm
;	gcc -m32 -nostartfiles -g -o encoder start.o encoder.o
; Running:   ./encoder

; Using Makefile
; Compiling: make
; Running:	 make run

; Description:
; This program encodes a string using a shift then decodes the string.
; Every character (a-z) in an even position in the string is shifted down in ASCII value.
; Every character (a-z) in an odd position in the string is shifted up in ASCII value.
; There is a wrap so that the characters being shifted stay within the lowercase alphabet.

section .data
msg:    db "this is a program for cs261 at wsu vancouver."
len:    equ $-msg
shift:  dw 12

section .bss
section .text
extern encode
extern decode
global _start
_start:
    push word [shift]   ; arg3
    push dword len      ; arg2
    push dword msg      ; arg1
    call encode
    add esp, 12         ; clean up stack
    
    push word [shift]   ; arg3
    push dword len      ; arg2
    push dword msg      ; arg1
    call decode
    add esp, 12         ; clean up stack

exit:
	mov eax, 1
	mov ebx, 0
	int 0x80
