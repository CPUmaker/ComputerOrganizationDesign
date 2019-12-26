.data
vertex: .space 32
map:	.space 256


.text
main:
	li $v0, 5
	syscall
	move $s0, $v0
	li $v0, 5
	syscall
	move $s1, $v0
	li $t0, 0	
initial:
	beq $t0, $s0, initial_end
	sll $t1, $t0, 2
	li $t2, 1
	sw, $t2, vertex($t1)
	addi, $t0, $t0, 1
	j initial
initial_end:
	li $t0, 0
make_map:
	beq $t0, $s1, make_end
	li $v0, 5
	syscall
	addi $t1, $v0, -1	#make vertex -1
	li $v0, 5
	syscall
	addi $t2, $v0, -1	#make vertex -1
	
	mul $t3, $t1, $s0
	add $t3, $t3, $t2
	sll $t3, $t3, 2
	
	li $t4, 1
	sw $t4, map($t3)	#put(i,j)=1
	
	mul $t3, $t2, $s0
	add $t3, $t3, $t1
	sll $t3, $t3, 2
	
	li $t4, 1
	sw $t4, map($t3)	#out(j,i)=1
	
	addi $t0, $t0, 1
	j make_map
make_end:
	move $a0, $s0
	li $a1, 0
	li $a2, 1
	jal find_circle
output:
	move $a0, $v0
	li $v0, 1
	syscall
	li $v0, 10
	syscall
	
	
	
find_circle:
	sw $ra, 0($sp)
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	addi $sp, $sp, -4
	sw $t1, 0($sp)
	addi $sp, $sp, -4
	sw $t2, 0($sp)
	addi $sp, $sp, -4
	sw $t3, 0($sp)
	addi $sp, $sp, -4
	
	move $t0, $a0
	move $t1, $a1
	move $t2, $a2
	
	sll $t3, $t1, 2
	sw, $0, vertex($t3)
	
	li $t3, 0
for_1_begin:
	beq $t3, $t0, for_1_end
	
	mul $t4, $t1, $t0
	add $t4, $t4, $t3
	sll $t4, $t4, 2
	
	lw $t5, map($t4)
	sll $t7, $t3, 2
	lw $t6, vertex($t7)
	and $t5, $t5, $t6
	beq $t5, $0, pass
	move $a0, $t0
	move $a1, $t3
	addi $a2, $t2, 1
	jal find_circle
	bne $v0, $0, output
pass:
	addi $t3, $t3, 1
	j for_1_begin
for_1_end:
	#calc original vertex is have road with last one
	bne $t2, $t0, return
	mul $t3, $t1, $t0
	sll $t3, $t3, 2
	lw $t4, map($t3)
	
	beq $t4, $0, return
	li $v0, 1
	addi $sp, $sp, 4
	lw $t3, 0($sp)
	addi $sp, $sp, 4
	lw $t2, 0($sp)
	addi $sp, $sp, 4
	lw $t1, 0($sp)
	addi $sp, $sp, 4
	lw $t0, 0($sp)
	addi $sp, $sp, 4
	lw $ra, 0($sp)
	jr $ra
	
	
return:
	li $v0, 0
	sll $t7, $t1, 2
	li $t8, 1
	sw $t8, vertex($t7)
	addi $sp, $sp, 4
	lw $t3, 0($sp)
	addi $sp, $sp, 4
	lw $t2, 0($sp)
	addi $sp, $sp, 4
	lw $t1, 0($sp)
	addi $sp, $sp, 4
	lw $t0, 0($sp)
	addi $sp, $sp, 4
	lw $ra, 0($sp)
	jr $ra
	
	
