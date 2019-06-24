#--------------------------------------------------------------
# 
#  4190.308 Computer Architecture (Spring 2019)
#
#  Project #3: Drawing diagonal lines in an image
#
#  April 24, 2019.
#
#  Jin-Soo Kim (jinsoo.kim@snu.ac.kr)
#  Systems Software & Architecture Laboratory
#  Dept. of Computer Science and Engineering
#  Seoul National University
#
#--------------------------------------------------------------

.text
	.align 4
.globl bmp_diag
	.type bmp_diag,@function

bmp_diag:
	#------------------------------------------------------------
	# Use %rax, %rcx, %rdx, %rsi, %rdi, and %r8 registers only
	#	imgptr is in %rdi
	#	width  is in %rsi
	#	height is in %rdx
	#	gap    is in %rcx
	#------------------------------------------------------------

	# --> FILL HERE <--

	pushq	%rsi 	# original %rsp - '40' // width
	pushq	%rdx 	# %rsp - '32' // height
	pushq	%rcx	# %rsp - '24' // original gap
	imulq	$3, %rcx
	pushq	%rcx 	# %rsp - '16' // pushed_gap ( not original gap)
	pushq	%rdi	# %rsp - '8' // imgptr

	# save computed_width in %r8
	movq	%rsi,	%r8 # r8 = width
	imulq	$0x3,	%r8 # r8 = width * 3
	addq	$0x3,	%r8 # r8 = (width * 3) + 3
	sarq	$0x2,	%r8
	salq	$0x2,	%r8
	# r8 = (((width*3)+3) / 4) * 4 = computed_width

	# save new_start in %rsp - '0'
	movq	%r8,	%rax # rax = computed_width
	imulq	%rdx,	%rax # rax = computed_width * heights
	subq	%r8,	%rax # rax = computed_width * (height - 1)
	addq	%rdi,	%rax # rax = computed_width * (height - 1) + imgptr = new_start
	pushq	%rax

	# save posX in %rcx
	movq	(%rsp),	%rcx # posX = new_start

	# save gap_inc in %rsi
	xorq	%rsi, %rsi	

	# save j in %rdx
	movq	(%rsp), %rdx	# j = new_start



	# now only %rdi and %rax are free.
	# TO-DO







	jmp .L0
.L1:
	movq	16(%rsp), %rdi
	subq	%rsi, %rdi
	jne	.L4
	movq	$0, %rsi
.L4:
	movq	%rsi, %rdx
	addq	%rcx, %rdx
.L2:
	movq	40(%rsp), %rdi
	imulq	$3, %rdi
	addq	%rcx, %rdi
	subq	%rdx, %rdi	# %rdi = (posX + width*3) - j
	jle	.L3
	
	movw	$0x0, (%rdx)
	movb	$0xff, 2(%rdx)	# set red
	addq	16(%rsp), %rdx
	jmp	.L2

.L3:
	subq	%r8, %rcx	# posX = posX - computed_width
	addq	$3, %rsi	# gap_inc = gap_inc + 3



.L0:
	movq	%rcx, %rdi
	subq	8(%rsp), %rdi # %rdi = posX - imgptr
	jge	.L1	 # jump posX >= imgptr ##################







	movq	(%rsp), %rcx
	addq	16(%rsp), %rcx	# posX = new_start + pushed_gap
	movq	$0, %rsi
	movq	%rcx, %rdx
	movq	40(%rsp), %rax
	imulq	$3, %rax
	addq	(%rsp), %rax	# %rax is now new variable tmp_start!!!!!!!!!!!!!!!!!




	jmp .L15
.L11:
	movq	16(%rsp), %rdi
	subq	%rsi, %rdi
	jne	.L14
	movq	$0, %rsi
.L14:
	movq	%rcx, %rdx
	subq	%rsi, %rdx	# j = posX - gap_inc (changed!)
.L12:
	movq	%rax, %rdi
	subq	%rdx, %rdi	# tmp_start - j
	jle	.L13
	
	movw	$0x0, (%rdx)
	movb	$0xff, 2(%rdx)	# set red
	addq	16(%rsp), %rdx
	jmp	.L12

.L13:
	subq	%r8, %rcx	# posX = posX - computed_width
	addq	$3, %rsi	# gap_inc = gap_inc + 3
	subq	%r8, %rax	# tmp_start = tmp_start - computed_width


.L15:
	movq	%rcx, %rdi
	subq	8(%rsp), %rdi # %rdi = posX - imgptr
	jge	.L11	 # jump posX >= imgptr ##################





	# end




	# Example: Initially, the %rdi register points to the first 
	# pixel in the last row of the image.  The following three 
	# instructions change its color to red.

//	movb 	$0x00, (%rdi)			# blue
//	movb	$0x00, 1(%rdi)			# green
//	movb	$0xff, 2(%rdi)			# red


	popq	%rax
	popq	%rdi
	popq	%rcx
	popq	%rcx
	popq	%rdx
	popq	%rsi


	#------------------------------------------------------------

	ret
