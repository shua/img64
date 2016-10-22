include ../config.mk

all: sobel_c sobel_asm

%.o: %.asm
	$(NASM) -f elf64 $< -o $@

sobel_c: test.o sobel_c.o
	$(CC) -lm $^ -o $@

sobel_asm: test.o sobel_asm.o
	$(CC) -lm $^ -o $@

%.s: %.c
	$(CC) -fno-asynchronous-unwind-tables -S $< -o $@
