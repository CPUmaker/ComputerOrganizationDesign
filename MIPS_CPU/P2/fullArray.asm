.data
symbol:	.space 28
array:	.space 28
str_space:	.asciiz " "
str_enter:	.asciiz "\n"

.macro push(%x)
	sw %x, 0($sp)
	subi $sp, $sp, 4
.end_macro 

.macro pop(%x)
	addi $sp, $sp, 4
	lw %x, 0($sp)
.end_macro 

.text
	li $v0, 5
	syscall
	move $s0, $v0
	
	li $a0, 0
	jal FullArray
	
	li $v0, 10
	syscall

FullArray:
	push($ra)
	push($s0)
	push($s1)
	push($s2)
	
	move $s1, $a0
	
	blt $s1, $s0, else
	
	li $t0, 0
loop1:
	bge $t0, $s0, loop1End
	
	sll $t1, $t0, 2
	lw $a0, array($t1)
	li $v0, 1
	syscall
	la $a0, str_space
	li $v0, 4
	syscall
	
	addiu $t0, $t0, 1
	j loop1
loop1End:
	la $a0, str_enter
	li $v0, 4
	syscall
	j return

else:
	li $t0, 0
loop2:
	bge $t0, $s0, loop2End

	sll $t1, $t0, 2
	lw $t2, symbol($t1)
	bnez $t2, pass
	
	addiu $t3, $t0, 1
	sll $t4, $s1, 2
	sw $t3, array($t4)
	li $t3, 1
	sw $t3, symbol($t1)
	
	move $s2, $t0
	
	addiu $a0, $s1, 1
	jal FullArray
	
	move $t0, $s2
	
	sll $t1, $t0, 2
	li $t3, 0
	sw $t3, symbol($t1)
	
pass:
	addiu $t0, $t0, 1
	j loop2
loop2End:
	
	
return:
	pop($s2)
	pop($s1)
	pop($s0)
	pop($ra)
	jr $ra
	
	
	
