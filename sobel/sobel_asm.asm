section .text
	global sobel
	extern printf

sobel:
	sub	rsp, 8 ; the return address sits on the stack so we align to 
		       ; 16 byte by sub the difference of 8 byte on the stack
	.cols	equ	0
	.rows	equ	8
	.output equ	16
	.input  equ	24
	.bpir	equ	32
	.bpor	equ	40
	push	rbx
	push	rbp
	push	r12
	push	r13
	push	r14
	push	r15
	sub	rsp, 48
	cmp	rdx, 3
	jl	.noworktodo
	cmp	rcx, 3
	jl	.noworktodo
	mov	[rsp+.input], rdi
	mov	[rsp+.output], rsi
	mov	[rsp+.rows], rdx
	mov	[rsp+.cols], rcx
	mov	[rsp+.bpir], rcx
	imul	rcx, 4
	mov	[rsp+.bpor], rcx
 	
	mov	rax, [rsp+.rows]
	mov	rdx, [rsp+.cols]
	sub	rax, 2
	mov	r8, [rsp+.input]
	add	r8, rdx
	mov	r9, r8 ;address of row
	mov	r10, r8
	sub	r8, rdx
	add	r10, rdx
	pxor	xmm13, xmm13
	pxor	xmm14, xmm14
	pxor	xmm15, xmm15
.more_rows:
	mov	rbx, 1 ; first column to process
.more_cols: 
	movdqu 	xmm0, [r8+rbx-1]
	movdqu	xmm1, xmm0
	movdqu	xmm2, xmm0
	pxor	xmm9, xmm9
	pxor	xmm10, xmm10
	pxor	xmm11, xmm11
	pxor	xmm12, xmm12
	psrldq	xmm1, 1 ; shift pixel 1 to right
	psrldq	xmm2, 2 ; shift pixel 2 to right
			; low 14 values of xmm0
			; xmm1, and xmm2 are lined
	movdqa	xmm3, xmm0
	movdqa	xmm4, xmm1
	movdqa	xmm5, xmm2
	punpcklbw xmm3, xmm13 ;low 8 values are now words
	punpcklbw xmm4, xmm14
	punpcklbw xmm5, xmm15
	psubw	xmm11, xmm3 ; Gx
	psubw	xmm9, xmm3  ; Gy
	paddw	xmm11, xmm5 ; xmm11 = -xmm0 + xmm2
	psubw	xmm9, xmm4
	psubw   xmm9, xmm4
	psubw 	xmm9, xmm5  ; xmm9 = -xmm0 + 2*xmm1 - xmm2
	punpckhbw xmm0, xmm13 ; unpack to words
	punpckhbw xmm1, xmm14
	punpckhbw xmm2, xmm15
	psubw	xmm12, xmm0 ; Gx
	psubw	xmm10, xmm0 ; Gy
	paddw	xmm12, xmm2 ; xmm12 = -xmm0 + xmm2
	psubw	xmm10, xmm1
	psubw	xmm10, xmm1
	psubw	xmm10, xmm2 ; xmm10 = -xmm0 + 2*xmm1 + xmm2
	
	movdqu	xmm0, [r9+rbx-1] ; store next row in xmm0
	movdqu	xmm2, xmm0
	psrldq	xmm2, 2 ; Gy doesn't use this row, and Gx only uses first and third column
	                ; so he doesn't need another register for the middle pixel
	movdqa	xmm3, xmm0
	movdqa	xmm5, xmm2
	punpcklbw  xmm3, xmm13
	punpcklbw  xmm5, xmm15
	psubw	xmm11, xmm3
	psubw	xmm11, xmm3
	paddw	xmm11, xmm5
	paddw	xmm11, xmm5 ; xmm11 += -2*xmm0 + 2*xmm2
	punpckhbw  xmm0, xmm13
	punpckhbw  xmm2, xmm15
	psubw	xmm12, xmm0
	psubw	xmm12, xmm0
	paddw	xmm12, xmm2
	paddw	xmm12, xmm2 ; xmm12 += -2*xmm0 + 2*xmm2
	
	movdqu	xmm0, [r10+rbx-1] ; load two rows down from top
	; xmm11 and xmm12 are doing the bottom row multiplication of Gx
	; xmm9 and xmm10 are doing the bottom row mul of Gy
	movdqu  xmm1, xmm0
	movdqu	xmm2, xmm0
	psrldq	xmm1, 1
	psrldq	xmm2, 2
	movdqa	xmm3, xmm0
	movdqa	xmm4, xmm1
	movdqa	xmm5, xmm2
	punpcklbw  xmm3, xmm13
	punpcklbw  xmm4, xmm14
	punpcklbw  xmm5, xmm15
	psubw	xmm11, xmm3
	paddw	xmm9, xmm3
	paddw	xmm11, xmm5 ; xmm11 += -xmm0 + xmm2
	paddw	xmm9, xmm4
	paddw	xmm9, xmm4
	paddw	xmm9, xmm5  ; xmm9 += -xmm0 + 2*xmm1 + xmm2
	punpckhbw  xmm0, xmm13
	punpckhbw  xmm1, xmm14
	punpckhbw  xmm2, xmm15
	psubw	xmm12, xmm0
	paddw	xmm10, xmm0
	paddw	xmm12, xmm2 ; xmm12 += -xmm0 + xmm2
	paddw	xmm10, xmm1
	paddw	xmm10, xmm1
	paddw	xmm10, xmm2 ; xmm10 += -xmm0 + 2*xmm1 + xmm2

	pmullw	xmm9, xmm9 ; square xmm9,10,11,12
	pmullw  xmm10, xmm10
	pmullw  xmm11, xmm11
	pmullw	xmm12, xmm12
	paddw	xmm9, xmm11  ; xmm9  += xmm11 or sum of squares Gx^2 + Gy^2
	paddw	xmm10, xmm12 ; xmm10 += xmm12 sames
	movdqa	xmm1, xmm9   ; xmm1 = xmm9 all of it
	movdqa	xmm3, xmm10  ; xmm3 = xmm10
	punpcklwd xmm9, xmm13
	punpckhwd xmm1, xmm13
	punpcklwd xmm10, xmm13
	punpckhwd xmm3, xmm13
	cvtdq2ps  xmm0, xmm9 ; convert to floating point
	cvtdq2ps  xmm1, xmm1 
	cvtdq2ps  xmm2, xmm10
	cvtdq2ps  xmm3, xmm3
	sqrtps	xmm0, xmm0 ; take sqrt for magnitude
	sqrtps	xmm1, xmm1
	sqrtps  xmm2, xmm2
	sqrtps  xmm3, xmm3

	movups	[rsi+rbx*4], xmm0
	movups  [rsi+rbx*4+16], xmm1
	movups	[rsi+rbx*4+32], xmm2
	movups	[rsi+rbx*4+48], xmm3

	add	rbx, 14
	cmp	rbx, rdx
	jl	.more_cols
	add	r8, rdx
	add	r9, rdx
	add	r10, rdx
	add	rsi, [rsp+.bpor]
	sub	rax, 1
	cmp	rax, 0
	jg	.more_rows
	
.noworktodo:
	add	rsp, 48
	pop	r15
	pop	r14
	pop	r13
	pop	r12
	pop	rbp
	pop	rbx
	add rsp, 8
	ret

section .data
	sentence dq "aaaaaaac", 0x0a, 0
