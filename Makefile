# Elijah Delavar
# CS 261
# 5/6/2023
# start.asm encoder.asm Makefile

encoder: start.o encoder.o
	gcc -m32 -nostartfiles -g -o encoder start.o encoder.o

encoder.o: encoder.asm
	nasm -f elf -g -F dwarf encoder.asm

start.o: start.asm
	nasm -f elf -g -F dwarf start.asm

run:
	./encoder