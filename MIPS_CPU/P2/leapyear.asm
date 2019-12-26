li $v0, 5
syscall
move $s0, $v0

li $t0, 4
divu $s0, $t0
mfhi $t1
bne $t1, $0, not_leapyear

li $t0, 100
divu $s0, $t0
mfhi $t1
bne $t1, $0, is_leapyear

li $t0, 400
divu $s0, $t0
mfhi $t1
bne $t1, $0, not_leapyear
j is_leapyear

not_leapyear:
li $a0, 0
li $v0, 1
syscall
j end

is_leapyear:
li $a0, 1
li $v0, 1
syscall

end:
li $v0, 10
syscall



