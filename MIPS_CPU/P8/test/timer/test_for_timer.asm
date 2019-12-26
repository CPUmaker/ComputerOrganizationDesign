.text
ori $s0, $0, 0x1c01
mtc0 $s0, $12
lui $s0, 0x0131
ori $s0, $s0, 0x2d00
sw $s0, 0x7f04($0)
ori $s0, $0, 11
sw $s0, 0x7f00($0)

go:
lw $t0, 0x7f2c($0)
beq $t0, $t1, pass
nop

move $k0, $t0 

pass:
move $t1, $t0
j go
nop


.ktext 0x00004180
beq $k0, $0, return
nop
addiu $k0, $k0, -1
sw $k0, 0x7f38
return:
eret
