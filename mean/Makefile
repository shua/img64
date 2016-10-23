include ../config.mk

all: mean_c mean_asm

%.o: %.asm
	$(NASM) $(NASMFLAGS) $< -o $@

mean_c: test.o mean_c.o
	$(CC) -lm $^ -o $@

mean_asm: test.o mean_asm.o
	$(CC) -lm $^ -o $@

%.s: %.c
	$(CC) -fno-asynchronous-unwind-tables -S $< -o $@
