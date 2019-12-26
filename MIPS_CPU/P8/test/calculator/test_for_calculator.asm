.text
ori $s0, $0, 0xfc01
mtc0 $s0, $12
go:
j go
nop

.ktext 0x00004180
ori $k0, $0, 0x7f40
lw $k1, 0($k0)
beq $k1, $0, return
ori $k0, $0, 0x7f2c
lw $t0, 0($k0)
lw $t1, 4($k0)

ori $t2, $0, 0x0001
beq $t2, $k1, calc_1
ori $t2, $0, 0x0002
beq $t2, $k1, calc_2
ori $t2, $0, 0x0004
beq $t2, $k1, calc_3
ori $t2, $0, 0x0008
beq $t2, $k1, calc_4
ori $t2, $0, 0x0010
beq $t2, $k1, calc_5
ori $t2, $0, 0x0020
beq $t2, $k1, calc_6
ori $t2, $0, 0x0040
beq $t2, $k1, calc_7
ori $t2, $0, 0x0080
beq $t2, $k1, calc_8
nop
j return
nop


calc_1:
addu $t2, $t0, $t1
j end_calc
ori $k0, $0, 0x7f38

calc_2:
subu $t2, $t0, $t1
j end_calc
ori $k0, $0, 0x7f38

calc_3:
and $t2, $t0, $t1
j end_calc
ori $k0, $0, 0x7f38

calc_4:
or $t2, $t0, $t1
j end_calc
ori $k0, $0, 0x7f38

calc_5:
xor $t2, $t0, $t1
j end_calc
ori $k0, $0, 0x7f38

calc_6:
nor $t2, $t0, $t1
j end_calc
ori $k0, $0, 0x7f38

calc_7:
sllv $t2, $t0, $t1
j end_calc
ori $k0, $0, 0x7f38

calc_8:
srlv $t2, $t0, $t1
j end_calc
ori $k0, $0, 0x7f38


end_calc:
sw $t2, 0($k0)
sra $t2, $t2, 31
sw $t2, 4($k0)

return:
eret