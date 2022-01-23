	.file	"daxpy.cc"
	.section	.text._ZSt18generate_canonicalIdLm53ESt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EEET_RT1_,"axG",@progbits,_ZSt18generate_canonicalIdLm53ESt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EEET_RT1_,comdat
	.p2align 4,,15
	.weak	_ZSt18generate_canonicalIdLm53ESt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EEET_RT1_
	.type	_ZSt18generate_canonicalIdLm53ESt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EEET_RT1_, @function
_ZSt18generate_canonicalIdLm53ESt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EEET_RT1_:
.LFB3330:
	.cfi_startproc
	movq	4992(%rdi), %rax
	movl	$2, %r9d
	movl	$2567483615, %r8d
	movsd	.LC0(%rip), %xmm1
	xorpd	%xmm0, %xmm0
	flds	.LC2(%rip)
	jmp	.L14
	.p2align 4,,10
	.p2align 3
.L19:
	movq	(%rdi,%rax,8), %rdx
	leaq	1(%rax), %rcx
.L3:
	movq	%rdx, %rax
	movq	%rcx, 4992(%rdi)
	shrq	$11, %rax
	movl	%eax, %eax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	$7, %rdx
	andl	$2636928640, %edx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	$15, %rax
	andl	$4022730752, %eax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	shrq	$18, %rdx
	xorq	%rdx, %rax
	js	.L11
	cvtsi2sdq	%rax, %xmm2
.L12:
	movsd	%xmm1, -24(%rsp)
	mulsd	%xmm1, %xmm2
	subq	$1, %r9
	fldl	-24(%rsp)
	fmul	%st(1), %st
	addsd	%xmm2, %xmm0
	fstpl	-16(%rsp)
	movsd	-16(%rsp), %xmm1
	je	.L13
	movq	%rcx, %rax
.L14:
	cmpq	$623, %rax
	jbe	.L19
	movq	%rdi, %rdx
	xorl	%esi, %esi
	xorl	%r10d, %r10d
	.p2align 4,,10
	.p2align 3
.L6:
	movq	(%rdx), %rcx
	movq	8(%rdx), %rax
	addq	$1, %rsi
	andq	$-2147483648, %rcx
	andl	$2147483647, %eax
	orq	%rcx, %rax
	movq	%rax, %rcx
	shrq	%rcx
	xorq	3176(%rdx), %rcx
	testb	$1, %al
	movq	%r8, %rax
	cmove	%r10, %rax
	addq	$8, %rdx
	xorq	%rax, %rcx
	movq	%rcx, -8(%rdx)
	cmpq	$227, %rsi
	jne	.L6
	leaq	1816(%rdi), %rdx
	xorl	%r10d, %r10d
	.p2align 4,,10
	.p2align 3
.L9:
	movq	(%rdx), %rcx
	movq	8(%rdx), %rax
	addq	$1, %rsi
	andq	$-2147483648, %rcx
	andl	$2147483647, %eax
	orq	%rcx, %rax
	movq	%rax, %rcx
	shrq	%rcx
	xorq	-1816(%rdx), %rcx
	testb	$1, %al
	movq	%r8, %rax
	cmove	%r10, %rax
	addq	$8, %rdx
	xorq	%rax, %rcx
	movq	%rcx, -8(%rdx)
	cmpq	$623, %rsi
	jne	.L9
	movq	(%rdi), %rdx
	movq	4984(%rdi), %rax
	movq	%rdx, %rcx
	andq	$-2147483648, %rax
	andl	$2147483647, %ecx
	orq	%rax, %rcx
	movq	%rcx, %rax
	shrq	%rax
	xorq	3168(%rdi), %rax
	andl	$1, %ecx
	movl	$0, %ecx
	cmovne	%r8, %rcx
	xorq	%rcx, %rax
	movl	$1, %ecx
	movq	%rax, 4984(%rdi)
	jmp	.L3
.L11:
	movq	%rax, %rdx
	andl	$1, %eax
	shrq	%rdx
	orq	%rax, %rdx
	cvtsi2sdq	%rdx, %xmm2
	addsd	%xmm2, %xmm2
	jmp	.L12
.L13:
	fstp	%st(0)
	divsd	%xmm1, %xmm0
	ret
	.cfi_endproc
.LFE3330:
	.size	_ZSt18generate_canonicalIdLm53ESt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EEET_RT1_, .-_ZSt18generate_canonicalIdLm53ESt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EEET_RT1_
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC4:
	.string	"default"
	.section	.text.startup,"ax",@progbits
	.p2align 4,,15
	.globl	main
	.type	main, @function
main:
.LFB3142:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	.cfi_lsda 0x3,.LLSDA3142
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movl	$.LC4, %esi
	subq	$26016, %rsp
	.cfi_def_cfa_offset 26032
	leaq	18016(%rsp), %rdi
	leaq	5008(%rsp), %rdx
.LEHB0:
	call	_ZNSsC1EPKcRKSaIcE
.LEHE0:
	leaq	18016(%rsp), %rsi
	movq	%rsp, %rdi
.LEHB1:
	call	_ZNSt13random_device7_M_initERKSs
.LEHE1:
	movq	18016(%rsp), %rax
	leaq	10016(%rsp), %rsi
	leaq	-24(%rax), %rdi
	call	_ZNSs4_Rep10_M_disposeERKSaIcE
	movq	%rsp, %rdi
.LEHB2:
	call	_ZNSt13random_device9_M_getvalEv
	movl	%eax, %edx
	movl	$1, %ecx
	movabsq	$945986875574848801, %rdi
	movq	%rdx, 5008(%rsp)
	jmp	.L22
	.p2align 4,,10
	.p2align 3
.L36:
	movq	5000(%rsp,%rcx,8), %rdx
.L22:
	movq	%rdx, %rax
	shrq	$30, %rax
	xorq	%rdx, %rax
	movq	%rcx, %rdx
	shrq	$4, %rdx
	imulq	$1812433253, %rax, %rsi
	movq	%rdx, %rax
	mulq	%rdi
	movq	%rcx, %rax
	shrq	%rdx
	imulq	$624, %rdx, %rdx
	subq	%rdx, %rax
	addl	%eax, %esi
	movq	%rsi, 5008(%rsp,%rcx,8)
	addq	$1, %rcx
	cmpq	$624, %rcx
	jne	.L36
	movq	$624, 10000(%rsp)
	xorl	%ebx, %ebx
	.p2align 4,,10
	.p2align 3
.L24:
	leaq	5008(%rsp), %rdi
	call	_ZSt18generate_canonicalIdLm53ESt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EEET_RT1_
	addsd	.LC0(%rip), %xmm0
	leaq	5008(%rsp), %rdi
	movsd	%xmm0, 10016(%rsp,%rbx)
	addq	$8, %rbx
	call	_ZSt18generate_canonicalIdLm53ESt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EEET_RT1_
	addsd	.LC0(%rip), %xmm0
	movsd	%xmm0, 18008(%rsp,%rbx)
	cmpq	$8000, %rbx
	jne	.L24
	xorl	%esi, %esi
	xorl	%edi, %edi
	call	m5_dump_reset_stats
	movsd	.LC5(%rip), %xmm1
	xorl	%eax, %eax
	.p2align 4,,10
	.p2align 3
.L26:
	movsd	10016(%rsp,%rax), %xmm0
	addq	$8, %rax
	mulsd	%xmm1, %xmm0
	addsd	18008(%rsp,%rax), %xmm0
	movsd	%xmm0, 18008(%rsp,%rax)
	cmpq	$8000, %rax
	jne	.L26
	xorl	%esi, %esi
	xorl	%edi, %edi
	call	m5_dump_reset_stats
	xorpd	%xmm0, %xmm0
	leaq	18016(%rsp), %rax
	leaq	26016(%rsp), %rdx
	.p2align 4,,10
	.p2align 3
.L28:
	addsd	(%rax), %xmm0
	addq	$8, %rax
	cmpq	%rdx, %rax
	jne	.L28
	movl	$_ZSt4cout, %edi
	call	_ZNSo9_M_insertIdEERSoT_
.LEHE2:
	movq	%rsp, %rdi
	call	_ZNSt13random_device7_M_finiEv
	addq	$26016, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	xorl	%eax, %eax
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
.L31:
	.cfi_restore_state
	movq	%rax, %rbx
	movq	18016(%rsp), %rax
	leaq	10016(%rsp), %rsi
	leaq	-24(%rax), %rdi
	call	_ZNSs4_Rep10_M_disposeERKSaIcE
	movq	%rbx, %rdi
.LEHB3:
	call	_Unwind_Resume
.LEHE3:
.L32:
	movq	%rax, %rbx
	movq	%rsp, %rdi
	call	_ZNSt13random_device7_M_finiEv
	movq	%rbx, %rdi
.LEHB4:
	call	_Unwind_Resume
.LEHE4:
	.cfi_endproc
.LFE3142:
	.globl	__gxx_personality_v0
	.section	.gcc_except_table,"a",@progbits
.LLSDA3142:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE3142-.LLSDACSB3142
.LLSDACSB3142:
	.uleb128 .LEHB0-.LFB3142
	.uleb128 .LEHE0-.LEHB0
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB1-.LFB3142
	.uleb128 .LEHE1-.LEHB1
	.uleb128 .L31-.LFB3142
	.uleb128 0
	.uleb128 .LEHB2-.LFB3142
	.uleb128 .LEHE2-.LEHB2
	.uleb128 .L32-.LFB3142
	.uleb128 0
	.uleb128 .LEHB3-.LFB3142
	.uleb128 .LEHE3-.LEHB3
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB4-.LFB3142
	.uleb128 .LEHE4-.LEHB4
	.uleb128 0
	.uleb128 0
.LLSDACSE3142:
	.section	.text.startup
	.size	main, .-main
	.p2align 4,,15
	.type	_GLOBAL__sub_I_main, @function
_GLOBAL__sub_I_main:
.LFB3361:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movl	$_ZStL8__ioinit, %edi
	call	_ZNSt8ios_base4InitC1Ev
	movl	$__dso_handle, %edx
	movl	$_ZStL8__ioinit, %esi
	movl	$_ZNSt8ios_base4InitD1Ev, %edi
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	jmp	__cxa_atexit
	.cfi_endproc
.LFE3361:
	.size	_GLOBAL__sub_I_main, .-_GLOBAL__sub_I_main
	.section	.init_array,"aw"
	.align 8
	.quad	_GLOBAL__sub_I_main
	.local	_ZStL8__ioinit
	.comm	_ZStL8__ioinit,1,1
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC0:
	.long	0
	.long	1072693248
	.section	.rodata.cst4,"aM",@progbits,4
	.align 4
.LC2:
	.long	1333788672
	.section	.rodata.cst8
	.align 8
.LC5:
	.long	0
	.long	1071644672
	.hidden	__dso_handle
	.ident	"GCC: (GNU) 4.8.5 20150623 (Red Hat 4.8.5-44)"
	.section	.note.GNU-stack,"",@progbits
