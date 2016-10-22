section .text
	global sobel
sobel:
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
	mov	[rsp+.bipr], rcx
	imul	rcx, 4
	mov	[rsp+.bpor], rcx
	
	mov	rax, [rsp+.row]
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
	pxor	xmm12m xmm12
	psrldq	xmm1, 1 ; shift pixel 1 to right
	psrldq	xmm2, 2 ; shift pixel 2 to right
			; low 14 values of xmm0
			; xmm1, and xmm2 are lined
	movdqa	xmm3, xmm
	movdqa	xmm4, xmm1
	movdqa	xmm5, xmm2
	punpcklbw xmm3, xmm13 ;low 8 values are now words
	punpcklbw xmm4, xmm14
	punpcklbw xmm5, xmm15
	psubw	xmm11, xmm3
	psubw	xmm9, xmm3
	paddw	xmm11, xmm5
	psubw	xmm9, xmm4
	psubw   xmm9, xmm4
	psubw 	xmm9, xmm5
	punpckhbw xmm0, xmm13
	punpckhbw xmm1, xmm14
	punpckhbw xmm2, xmm15
	psubw	xmm12, xmm0
	psubw	xmm10, xmm0
	paddw	xmm12, xmm2
	psubw	xmm10, xmm1
	psubw	xmm10, xmm1
	psubw	xmm10, xmm2
	
	movdqu	xmm0, [r9+rbx-1]
	movdqu	xmm2, xmm0
	psrldq	xmm2, 2
	movdqa	xmm3, xmm0
	movdqa	xmm5, xmm2
	punpcklbw  xmm3, xmm13
	punpcklbw  xmm5, xmm15
	psubw	xmm11, xmm3
	psubw	xmm11, xmm3
	paddw	xmm11, xmm5
	paddw	xmm11, xmm5
	punpckhbw  xmm0, xmm13
	punpckhbw  xmm2, xmm15
	psubw	xmm12, xmm0
	psubw	xmm12, xmm0
	paddw	xmm12, xmm2
	paddw	xmm12, xmm2
	
	movdqu	xmm0, [r10+rbx-1]
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
	paddw	xmm11, xmm5
	paddw	xmm9, xmm4
	paddw	xmm9, xmm4
	paddw	xmm9, xmm5
	punpckhbw  xmm0, xmm13
	punpckhbw  xmm1, xmm14
	punpckhbw  xmm2, xmm15
	psubw	xmm12, xmm0
	paddw	xmm10, xmm0
	paddw	xmm12, xmm2
	paddw	xmm10, xmm1
	paddw	xmm10, xmm1
'	paddw	xmm10, xmm2

	pmullw	xmm9, xmm9
	pmullw  xmm10, xmm10
	pmullw  xmm11, xmm11
	pmullw	xmm12, xmm12
	paddw	xmm9, xmm11
	paddw	xmm10, xmm12
	movdqa	xmm1, xmm9
	movdqa	xmm3, xmm10
	punpcklwd xmm9, xmm13
	punpckhwd xmm1, xmm13
	punpcklwd xmm10, xmm13
	punpckhwd xmm3, xmm13
	cvtdq2ps  xmm0, xmm9 ; convert to floating poin
	cvtdq2ps  xmm1, xmm1 
	cvtdq2ps  xmm2, xmm10
	cvtdq2ps  xmm3, xmm3
	sqrtps	xmm0, xmm0; take sqrt for magnitude
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
.noworktodo
	add	rsp, 48
	pop	rbx
	pop	rbp
	pop	r12
	pop	r13
	pop	r14
	pop	r15
	ret
