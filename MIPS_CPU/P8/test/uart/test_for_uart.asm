.text
ori $s0, $0, 0xfc01
mtc0 $s0, $12
ori $s0, $0, 0x7f34
lui $s1, 0x5555
ori $s1, $s1, 0x5555
sw $s1, 0($s0)
ori $s0, $0, 0x7f38
lui $s1, 0x7654
ori $s1, $s1, 0x3210
sw $s1, 0($s0)
go:
j go
nop

.ktext 0x00004180
mfc0 $k0, $13
andi $k0, $k0, 0x0800
beq $k0, $0, return
ori $t0, $0, 0x7f10
lw $k1, 0($t0)
sw $k1, 0($t0)
return:
eret