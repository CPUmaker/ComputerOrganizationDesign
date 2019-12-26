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
lw $t1, 4($k0)

ori $a0, $0, 0x2000
subu $a1, $t1, $a0
bgez $a1, DIY
nop
andi $a1, $t1, 0x0003
bne $a1, $0, DIY
nop

ori $t2, $0, 0x0001
beq $t2, $k1, opt_1
ori $t2, $0, 0x0002
beq $t2, $k1, opt_2

nop
j return
nop

opt_1:
	sw $t0, 0x7f38
	sw $t0, 0($t1)
	j return
	nop

opt_2:
	lw $t0, 0($t1)
	sw $t0, 0x7f38
	j return
	nop
	
DIY:
	li $t0, 03091806
	sw $t0, 0x7f38
	j return
	nop

return:
eret