.data
matrixA: .space 256
matrixB: .space 256
matrixC: .space 256
str_enter: .asciiz "\n"
str_space: .asciiz " "

.macro print_int(%x)
	li $v0, 1
	add $a0, $zero, %x
	syscall
.end_macro

.macro print_str(%x)
	li $v0, 4
	add $a0, $zero, %x
	syscall
.end_macro

.macro scan_int()
	li $v0, 5
	syscall
.end_macro

.macro calc_addr(%dst, %row, %column, %rank)
	multu %rank, %row
	mflo %dst
	addu %dst, %dst, %column
	sll %dst, %dst, 2
.end_macro

.text
	scan_int()
	move $s0, $v0
	move $s1, $0
initLoop1:
	bge $s1, $s0, initLoop1End
	
	move $s2, $0
initLoop2:
	bge $s2, $s0, initLoop2End
	
	calc_addr($s3, $s1, $s2, $s0)
	scan_int()
	sw $v0, matrixA($s3)
	
	addiu $s2, $s2, 1
	j initLoop2
initLoop2End:
	addiu $s1, $s1, 1
	j initLoop1
initLoop1End:

	move $s1, $0
initLoop3:
	bge $s1, $s0, initLoop3End
	
	move $s2, $0
initLoop4:
	bge $s2, $s0, initLoop4End
	
	calc_addr($s3, $s1, $s2, $s0)
	scan_int()
	sw $v0, matrixB($s3)
	
	addiu $s2, $s2, 1
	j initLoop4
initLoop4End:
	addiu $s1, $s1, 1
	j initLoop3
initLoop3End:

	move $s1, $0
loop1:
	bge $s1, $s0, loop1End
	
	move $s2, $0
loop2:
	bge $s2, $s0, loop2End
	
	move $t0, $0
	move $t4, $0
addLoop:
	bge $t0, $s0, addLoopEnd
	
	calc_addr($s3, $s1, $t0, $s0)
	lw $t1, matrixA($s3)
	calc_addr($s3, $t0, $s2, $s0)
	lw $t2, matrixB($s3)
	multu $t1, $t2
	mflo $t3
	addu $t4, $t4, $t3
	
	addiu $t0, $t0, 1
	j addLoop
addLoopEnd:
	
	calc_addr($s3, $s1, $s2, $s0)
	sw $t4, matrixC($s3)
	addiu $s2, $s2, 1
	j loop2
loop2End:
	addiu $s1, $s1, 1
	j loop1
loop1End:

	move $s1, $0
loop3:
	bge $s1, $s0, loop3End
	
	move $s2, $0
loop4:
	bge $s2, $s0, loop4End
	
	calc_addr($s3, $s1, $s2, $s0)
	lw $t0, matrixC($s3)
	print_int($t0)
	la $s3, str_space
	print_str($s3)
	
	addiu $s2, $s2, 1
	j loop4
loop4End:
	la $s3, str_enter
	print_str($s3)
	addiu $s1, $s1, 1
	j loop3
loop3End:
	
	li $v0, 10
	syscall
	
	
	
	
	
	
	
	
	
	