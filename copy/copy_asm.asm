
global .text
	global copy
copy:
	sub rsp, 8
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
	jl	.done
	cmp	rcx, 3
	jl	.done

	mov	[rsp+.input], rdi
	mov	[rsp+.output], rsi
	mov	[rsp+.rows], rdx
	mov	[rsp+.cols], rcx
	mov	[rsp+.bpir], rcx
	imul	rcx, 4
	mov	[rsp+.bpor], rcx

	mov	rax, [rsp+.rows]
	mov	rdx, [rsp+.cols]
	mov	r8, [rsp+.input]
.Lrows:
	mov rbx, 0
.Lcols:
	movdqu xmm0, [r8+rbx]
	movdqu [rsi+rbx], xmm0

	add rbx, 16
	cmp rbx, rdx
	jl .Lcols
	add r8, rdx
	mov rsi, r8
	sub rax, 1
	cmp rax, 0
	jg .Lrows

.done:
	add	rsp, 48
	pop	r15
	pop	r14
	pop	r13
	pop	r12
	pop	rbp
	pop	rbx
	add rsp, 8
	ret