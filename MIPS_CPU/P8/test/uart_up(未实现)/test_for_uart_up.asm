.text
ori $s0, $0, 0x1c01
mtc0 $s0, $12

go:
nop
j go
nop

.ktext 0x00004180
ori $k0, $0, 0x7f40
lw $k1, 0($k0)
beq $k1, $0, return
ori $k0, $0, 0x7f2c
lw $t0, 0($k0)


ori $t2, $0, 0x0001
beq $t2, $k1, opt_1
ori $a0, $0, 0

nop
j return
nop

opt_1:
	sw $t0, 0x7f38

	lw $k0, 0x7f20
	#andi $k0, $k0, 0x0020
	#beq $k0, $0, opt_1
	nop
	sll $a1, $a0, 2
	srlv $a2, $t0, $a1
	andi $a2, $a2, 0x000f
	addiu $a3, $a2, -10
	bltz $a3, put_num
	nop
	addiu $a3, $a3, 'A'
	sw $a3, 0x7f10
	j end_once
	nop

put_num:
	addiu $a2, $a2, '0'
	sw $a2, 0x7f10
	j end_once
	nop
	
end_once:
	addiu $a0, $a0, 1
	beq $a0, 8, return
	nop
	j opt_1

return:
eret