.data 
string: .space 25

.text
	li $v0, 5
	syscall
	move $s0, $v0
	
	move $t0, $0
init:
	bge $t0, $s0, initEnd
	
	li $v0, 12
	syscall
	sb $v0, string($t0)
	
	addiu $t0, $t0, 1
	j init
initEnd:

	move $t0, $0
	move $t1, $s0
	subiu $t1, $t1, 1
judgeLoop:
	bge $t0, $t1, judgeEnd
	
	lb $s1, string($t0)
	lb $s2, string($t1)
	bne $s1, $s2, notPString
	
	addiu $t0, $t0, 1
	subiu $t1, $t1, 1
	j judgeLoop
judgeEnd:
	li $a0, 1
	li $v0, 1
	syscall
	li $v0, 10
	syscall
	
notPString:
	li $a0, 0
	li $v0, 1
	syscall
	li $v0, 10
	syscall
	
	

