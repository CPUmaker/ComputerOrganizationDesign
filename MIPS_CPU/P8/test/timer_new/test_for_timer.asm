.text
ori $s0, $0, 0x0c01
mtc0 $s0, $12
lui $s0, 0x0131
ori $s0, $s0, 0x2d00
sw $s0, 0x7f04($0)
ori $s0, $0, 11		#[3:0] = 4'b1011
sw $s0, 0x7f00($0)

go:
nop
j go
nop


.ktext 0x00004180
load_switch:
	lw $k0, 0x7f2c($0)
	beq $k0, $0, set_DIY
	nop
	bne $k0, 1, load_switch_2
	nop
	ori $s0, $0, 2
	sw $s0, 0x7f00($0)
	lui $s0, 0x0131
	ori $s0, $s0, 0x2d00
	sw $s0, 0x7f04($0)
	ori $s0, $0, 11
	sw $s0, 0x7f00($0)
	j count
	nop

load_switch_2:
	ori $s0, $0, 2
	sw $s0, 0x7f00($0)
	lui $s0, 0x0262
	ori $s0, $s0, 0x5a00
	sw $s0, 0x7f04($0)
	ori $s0, $0, 11
	sw $s0, 0x7f00($0)
	j count
	nop
	

count:
	beq $k1, 9, set_zero
	nop
	addiu $k1, $k1, 1
	sw $k1, 0x7f38
	j return
	nop
	
set_zero:
	ori $k1, $0, 0
	sw $k1, 0x7f38
	j return
	nop
	
set_DIY:
	lui $t1, 0xcccc
	ori $t1, $t1, 0x3399
	sw $t1, 0x7f38
	j return
	nop
	
return:
eret
