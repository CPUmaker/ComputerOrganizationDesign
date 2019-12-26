.data
matrix: .space 64

.macro scan_int(%dst)
	li $v0, 5
	syscall
	move %dst, $v0
.end_macro 

.macro push(%x)
	sw %x, 0($sp)
	subi $sp, $sp, 4
.end_macro 

.macro pop(%x)
	addi $sp, $sp, 4
	lw %x, 0($sp)
.end_macro 

.macro calc_addr(%dst, %row, %column, %rank)
	multu %rank, %row
	mflo %dst
	addu %dst, %dst, %column
.end_macro

.text
	scan_int($s0)
	scan_int($s1)
	multu $s0, $s1
	mflo $t0
	li $t1, 0
init:
	bge $t1, $t0, initEnd
	
	scan_int($t2)
	sb $t2, matrix($t1)
	
	addiu $t1, $t1, 1
	j init
initEnd:
	
	scan_int($a0)
	subi $a0, $a0, 1
	scan_int($a1)
	subi $a1, $a1, 1
	scan_int($s2)
	subi $s2, $s2, 1
	scan_int($s3)
	subi $s3, $s3, 1
	
	li $s4, 0
	
	jal find
	
	move $a0, $s4
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall
	
	
find:
	push($ra)
	push($s5)
	push($s6)
	
	move $s5, $a0
	move $s6, $a1
	
	calc_addr($t0, $s5, $s6, $s1)
	li $t1, 1
	sb $t1, matrix($t0)
	
	bne $s5, $s2, continueFind
	beq $s6, $s3, isEntrance
	
continueFind:
	ble $s5, $0, x_sub
	
	subiu $a0, $s5, 1
	move $a1, $s6
	calc_addr($t0, $a0, $a1, $s1)
	lb $t1, matrix($t0)
	bnez $t1, x_sub
	jal find
x_sub:
	addiu $t0, $s5, 1
	bge $t0, $s0, x_inc
	
	addiu $a0, $s5, 1
	move $a1, $s6
	calc_addr($t0, $a0, $a1, $s1)
	lb $t1, matrix($t0)
	bnez $t1, x_inc
	jal find
x_inc:
	ble $s6, $0, y_sub
	
	move $a0, $s5
	subiu $a1, $s6, 1
	calc_addr($t0, $a0, $a1, $s1)
	lb $t1, matrix($t0)
	bnez $t1, y_sub
	jal find
y_sub:
	addiu $t0, $s6, 1
	bge $t0, $s1, y_inc
	
	move $a0, $s5
	addiu $a1, $s6, 1
	calc_addr($t0, $a0, $a1, $s1)
	lb $t1, matrix($t0)
	bnez $t1, y_inc
	jal find
y_inc:
	j return
isEntrance:
	addiu $s4, $s4, 1
return:
	calc_addr($t0, $s5, $s6, $s1)
	li $t1, 0
	sb $t1, matrix($t0)

	pop($s6)
	pop($s5)
	pop($ra)
	jr $ra
