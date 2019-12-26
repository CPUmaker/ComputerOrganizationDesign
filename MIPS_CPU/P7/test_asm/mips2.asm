.text 0x00003000
ori $v0, $0, 0xff11
mtc0 $v0, $12
la $s0, go
mtc0, $s0, $14
addiu $a0, $a0, 0x2828
go:
beq $0, $0, go
nop


.ktext 0x00004180
mfc0 $k0, $13
mfc0 $k1, $14
eret
ori $1, $k0, 0x1010