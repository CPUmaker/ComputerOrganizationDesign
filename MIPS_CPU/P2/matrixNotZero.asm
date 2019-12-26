.data
matrix: .space 10000
str_space: .asciiz " "
str_enter: .asciiz "\n"

.text
li $v0, 5
syscall
move $s0, $v0
li $v0, 5
syscall
move $s1, $v0

li $t0, 0
loop_1_begin:
beq $t0, $s0, loop_1_end
li $t1, 0
loop_2_begin:
beq $t1, $s1, loop_2_end

mulu $t2, $s1, $t0
addu $t2, $t2, $t1
sll $t2, $t2, 2

li $v0, 5
syscall
sw $v0, matrix($t2)

addi $t1, $t1, 1
j loop_2_begin
loop_2_end:

addi $t0, $t0, 1
j loop_1_begin
loop_1_end:


addi $t0, $s0, -1
loop_3_begin:
blt $t0, $0, loop_3_end
addi $t1, $s1, -1
loop_4_begin:
blt $t1, $0, loop_4_end

mulu $t2, $s1, $t0
addu $t2, $t2, $t1
sll $t2, $t2, 2

lw $t3, matrix($t2)
beq $t3, $0, pass

addi $a0, $t0, 1
li $v0, 1
syscall
la $a0, str_space
li $v0, 4
syscall
addi $a0, $t1, 1
li $v0, 1
syscall
la $a0, str_space
li $v0, 4
syscall
addi $a0, $t3, 0
li $v0, 1
syscall
la $a0, str_enter
li $v0, 4
syscall

pass:
addi $t1, $t1, -1
j loop_4_begin
loop_4_end:

addi $t0, $t0, -1
j loop_3_begin
loop_3_end:

li $v0, 10
syscall

