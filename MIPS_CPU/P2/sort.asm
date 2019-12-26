.data
array:		.space 128	#maximum member is 32
str_space:	.asciiz " "
head:		.asciiz "The sorted array is:\n"

.text
	la $s0, array
	li $v0, 5
	syscall
	move $s1, $v0
	beqz $v0, end
	li $t0, 0
get:	bge $t0, $s1, calc
	sll $t1, $t0, 2
	add $t1, $t1, $s0
	li $v0, 5
	syscall
	sw $v0, 0($t1)
	addi $t0, $t0, 1
	j get
calc:	li $t0, 0
loop_1:	bge $t0, $s1, loop_1_end
	addi $t1, $t0, 1
loop_2:	bge, $t1, $s1, loop_2_end
	sll $t2, $t0, 2
	add $t2, $t2, $s0
	sll $t3, $t1, 2
	add $t3, $t3, $s0
	lw $t4, 0($t2)
	lw $t5, 0($t3)
	ble $t4, $t5, replace_pass
	sw $t4, 0($t3)
	sw $t5, 0($t2)
replace_pass:
	addi $t1, $t1, 1
	j loop_2
loop_2_end:
	addi $t0, $t0, 1
	j loop_1
loop_1_end:
	la $a0, head
	li $v0, 4
	syscall
	li $t0, 0
print:	bge $t0, $s1, end
	sll $t1, $t0, 2
	add $t1, $t1, $s0
	lw $a0, 0($t1)
	li $v0, 1
	syscall
	la $a0, str_space
	li $v0, 4
	syscall
	addi $t0, $t0, 1
	j print
end:	li $v0, 10
	syscall


