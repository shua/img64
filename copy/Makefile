include ../config.mk

all: copy_c copy_asm

%.o: %.asm
	$(NASM) $(NASMFLAGS) $< -o $@

copy_c: test.o copy_c.o
	$(CC) -lm $^ -o $@

copy_asm: test.o copy_asm.o
	$(CC) -lm $^ -o $@

%.s: %.c
	$(CC) -fno-asynchronous-unwind-tables -S $< -o $@
