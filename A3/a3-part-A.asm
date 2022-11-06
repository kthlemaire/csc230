
	.data
ARRAY_A:
	.word	21, 210, 49, 4
ARRAY_B:
	.word	21, -314159, 0x1000, 0x7fffffff, 3, 1, 4, 1, 5, 9, 2
ARRAY_Z:
	.space	28
NEWLINE:
	.asciiz "\n"
SPACE:
	.asciiz " "
		
	
	.text  
main:	
	la $a0, ARRAY_A
	addi $a1, $zero, 4
	jal dump_array
	
	la $a0, ARRAY_B
	addi $a1, $zero, 11
	jal dump_array
	
	la $a0, ARRAY_Z
	lw $t0, 0($a0)
	addi $t0, $t0, 1
	sw $t0, 0($a0)
	addi $a1, $zero, 9
	jal dump_array
		
	addi $v0, $zero, 10
	syscall

# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
	
	
dump_array:

	# $a3 - holds the address of the array
	add $a3, $a0, $zero

loop_integers:

	# $a0 - holds the values in the array
	beq $a1, $zero, end_dump_array
	lw $a0, 0($a3)
	addi $a1, $a1, -1
	addi $a3, $a3, 4
	addi $v0, $zero, 1
	syscall
	la $a0, SPACE
	addi $v0, $zero, 4
	syscall
	beq $zero, $zero, loop_integers

end_dump_array:

	la $a0, NEWLINE
	addi $v0, $zero, 4
	syscall
	jr $ra
	
	
	
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE
