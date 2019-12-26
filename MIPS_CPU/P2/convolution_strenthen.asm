.data 
matrix: .space 400
kernel: .space 400
result: .space 400
str_enter: .asciiz "\n"
str_space: .asciiz " "

.macro scan_int(%dst)
	li $v0, 5
	syscall
	move %dst, $v0
.end_macro

.macro print_int(%value)
	li $v0, 1
	move $a0, %value
	syscall
.end_macro

.macro print_str(%value)
	li $v0, 4
	la $a0, %value
	syscall
.end_macro

.macro calc_addr(%dst, %row, %column, %rank)
	multu %row, %rank
	mflo %dst
	addu %dst, %dst, %column
	sll %dst, %dst, 2
.end_macro

.text
	scan_int($s0)
	scan_int($s1)
	scan_int($s2)
	scan_int($s3)
	subu $s4, $s0, $s2
	addiu $s4, $s4, 1
	subu $s5, $s1, $s3
	addiu $s5, $s5, 1
	
	move $t0, $0
	multu $s0, $s1
	mflo $t1
init1:
	bge $t0, $t1, init1End
	scan_int($t2)
	sll $t3, $t0, 2
	sw $t2, matrix($t3)
	addiu $t0, $t0, 1
	j init1
init1End:

	move $t0, $0
	multu $s2, $s3
	mflo $t1
init2:
	bge $t0, $t1, init2End
	scan_int($t2)
	sll $t3, $t0, 2
	sw $t2, kernel($t3)
	addiu $t0, $t0, 1
	j init2
init2End:
	
	move $t0, $0
loop1:
	bge $t0, $s4, loop1End

	move $t1, $0
loop2:
	bge $t1, $s5, loop2End
	
	move $t2, $0
	move $s6, $0
	move $s7, $0
calcLoop1:
	bge $t2, $s2, calc1End
	
	move $t3, $0
calcLoop2:
	bge $t3, $s3, calc2End
	
	addu $t4, $t0, $t2
	addu $t5, $t1, $t3
	calc_addr($t4, $t4, $t5, $s1)	#matrix addr
	calc_addr($t5, $t2, $t3, $s3)	#kernel addr
	lw $t4, matrix($t4)
	lw $t5, kernel($t5)
	mthi $s6
	mtlo $s7
	madd $t4, $t5
	mfhi $s6
	mflo $s7
	
	addiu $t3, $t3, 1
	j calcLoop2
calc2End:

	addiu $t2, $t2, 1
	j calcLoop1
calc1End:
	#print_int($t6)
	li $t7, 31
l1:
	srlv $t8, $s6, $t7
	andi $t8, $t8, 1
	print_int($t8)
	subu $t7, $t7, 1
	bgez $t7, l1
	
	li $t7, 31
l2:
	srlv $t8, $s7, $t7
	andi $t8, $t8, 1
	print_int($t8)
	subu $t7, $t7, 1
	bgez $t7, l2
	
	print_str(str_space)
	
	addiu $t1, $t1, 1
	j loop2
loop2End:
	print_str(str_enter)
	
	addiu $t0, $t0, 1
	j loop1
loop1End:
	li $v0, 10
	syscall



