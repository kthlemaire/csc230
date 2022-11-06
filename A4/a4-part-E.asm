# Skeleton file provided to students in UVic CSC 230, Spring 2022 
# Original file copyright Mike Zastre, 2022

.include "a4support.asm"

.data

.eqv	MAX_ARRAY_SIZE 1024

.align 2
ARRAY_1:	.space MAX_ARRAY_SIZE
ARRAY_2:	.space MAX_ARRAY_SIZE
ARRAY_3:	.space MAX_ARRAY_SIZE
ARRAY_4:	.space MAX_ARRAY_SIZE
ARRAY_5:	.space MAX_ARRAY_SIZE
ARRAY_6:	.space MAX_ARRAY_SIZE
ARRAY_7:	.space MAX_ARRAY_SIZE
ARRAY_8:	.space MAX_ARRAY_SIZE

# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

FILENAME_1:	.asciiz "integers-200-42624.bin"
FILENAME_2:	.asciiz "integers-200-93238.bin"

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE



.globl main
.text 
main:

# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

	la $a0, FILENAME_1
	la $a1, ARRAY_1
	jal read_file_of_ints
	add $s1, $zero, $v0
	
	la $a0, FILENAME_2
	la $a1, ARRAY_2
	jal read_file_of_ints
	add $s2, $zero, $v0
	
	# WRITE YOUR SOLUTION TO THE PART E PROBLEM
	# HERE...
	
	la $a0, ARRAY_1
	la $a1, ARRAY_3
	add $a2, $zero, $s1
	jal accumulate_max
	
	
	la $a0, ARRAY_2
	la $a1, ARRAY_4
	add $a2, $zero, $s2
	jal accumulate_max
	
	la $a0, ARRAY_3
	la $a1, ARRAY_5
	add $a2, $zero, $s1
	jal reverse_array
	
	la $a0, ARRAY_4
	la $a1, ARRAY_5
	la $a2, ARRAY_6
	add $a3, $zero, $s1
	jal pairwise_max
	
	la $a0, ARRAY_6
	la $a1, ARRAY_7
	add $a2, $s1, $zero
	jal accumulate_sum
	
	add $a2, $s1, $zero
	la $a1, ARRAY_7
	
loop: 
	beq $a2, 1, end_loop
	addi $a1, $a1, 4
	addi $a2, $a2, -1
	b loop
	
end_loop:
	lw $a0, 0($a1)
	addi $v0, $zero, 1
	syscall
	
	
	# Get outta here.		
	add $v0, $zero, 10
	syscall	
	

	
# COPY YOUR PROCEDURES FROM PARTS A, B, C, and D BELOW
# THIS POINT.
# Accumulate sum: Accepts two integer arrays where the value to be
# stored at each each index in the *second* array is the sum of all
# integers from the index back to towards zero in the first
# array. The arrays are of the same size; the size is the third
# parameter.
#
accumulate_sum:

	# $s0 - stores the integer in $a0
	# $s1 - stores the sum of the integers in $a0
	
	addi $sp, $sp, -20
	sw $s0, 16($sp)
	sw $s1, 12($sp)
	sw $a0, 8($sp)
	sw $a1, 4($sp)
	sw $a2, 0($sp)
	
	add $s1, $zero, $zero
	
loop_as_array:
	beq $a2, $zero, end_accumulate_sum
	lw $s0, 0($a0)
	add $s1, $s1, $s0
	sw $s1, 0($a1)
	addi $a0, $a0, 4
	addi $a1, $a1, 4
	addi $a2, $a2, -1
	b loop_as_array
	
end_accumulate_sum:
	lw $a2, 0($sp)
	lw $a1, 4($sp)
	lw $a0, 8($sp)
	lw $s1, 12($sp)
	lw $s0, 16($sp)
	addi $sp, $sp, 20
	jr $ra


# Accumulate max: Accepts two integer arrays where the value to be
# stored at each each index in the *second* array is the maximum
# of all integers from the index back to towards zero in the first
# array. The arrays are of the same size;  the size is the third
# parameter.
#
accumulate_max:

	# $s0 - stores the integer in $a0
	# $s1 - stores the maximum integer
	# $s2 - stores a set or unset bit to compare $s0 and $s1

	addi $sp, $sp, -24
	sw $s0, 20($sp)
	sw $s1, 16($sp)
	sw $s2, 12($sp)
	sw $a0, 8($sp)
	sw $a1, 4($sp)
	sw $a2, 0($sp)
	
	lw $s1, 0($a0)
	
loop_am_array:
	beq $a2, $zero, end_accumulate_max
	lw $s0, 0($a0)
	sgt $s2, $s0, $s1
	bne $s2, $zero, is_greater
	sw $s1, 0($a1)
	addi $a0, $a0, 4
	addi $a1, $a1, 4
	addi $a2, $a2, -1
	b loop_am_array
	
is_greater:
	add $s1, $s0, $zero
	sw $s1, 0($a1)
	addi $a0, $a0, 4
	addi $a1, $a1, 4
	addi $a2, $a2, -1
	b loop_am_array
	
end_accumulate_max:
	lw $a2, 0($sp)
	lw $a1, 4($sp)
	lw $a0, 8($sp)
	lw $s2, 12($sp)
	lw $s1, 16($sp)
	lw $s0, 20($sp)
	addi $sp, $sp, 24
	jr $ra
	
	
# Reverse: Accepts an integer array, and produces a new
# one in which the elements are copied in reverse order into
# a second array.  The arrays are of the same size; 
# the size is the third parameter.
#
reverse_array:
	# $s0 - stores the integer in $a0
	
	addi $sp, $sp, -16
	sw $s0, 12($sp)
	sw $a0, 8($sp)
	sw $a1, 4($sp)
	sw $a2, 0($sp)
	
go_to_end_of_array:
	beq $a2, 1, end_of_array
	addi $a1, $a1, 4
	addi $a2, $a2, -1
	b go_to_end_of_array
	
end_of_array:
	lw $a2, 0($sp)
	
loop_ra_array:
	beq $a2, $zero, end_reverse_array
	lw $s0, 0($a0)
	sw $s0, 0($a1)
	addi $a0, $a0, 4
	addi $a1, $a1, -4
	addi $a2, $a2, -1
	b loop_ra_array
	
end_reverse_array:

	lw $s0, 12($sp)
	lw $a0, 8($sp)
	lw $a1, 4($sp)
	lw $a2, 0($sp)
	addi $sp, $sp, 16
	jr $ra
	
	
# Reverse: Accepts three integer arrays, with the maximum
# element at each index of the first two arrays is stored
# at that same index in the third array. The arrays are 
# of the same size; the size is the fourth parameter.
#	
pairwise_max:

	# $s0 - stores value in $a0
	# $s1 - stores value in $a1
	# $s2 - set or unset for comparison of $s0 and $s1
	
	addi $sp, $sp, -28
	sw $s0, 24($sp)
	sw $s1, 20($sp)
	sw $s2, 16($sp)
	sw $a0, 12($sp)
	sw $a1, 8($sp)
	sw $a2, 4($sp)
	sw $a3, 0($sp)
	
loop_pm_array:
	beq $a3, $zero, end_pairwise_max
	lw $s0, 0($a0)
	lw $s1, 0($a1)
	sgt $s2, $s0, $s1
	bne $s2, $zero, s0_greater
	b s1_greater
	
s0_greater:
	sw $s0, 0($a2)
	addi $a0, $a0, 4
	addi $a1, $a1, 4
	addi $a2, $a2, 4
	addi $a3, $a3, -1
	b loop_pm_array
	
s1_greater:
	sw $s1, 0($a2)
	addi $a0, $a0, 4
	addi $a1, $a1, 4
	addi $a2, $a2, 4
	addi $a3, $a3, -1
	b loop_pm_array

end_pairwise_max:
	lw $s0, 24($sp)
	lw $s1, 20($sp)
	lw $s2, 16($sp)
	lw $a0, 12($sp)
	lw $a1, 8($sp)
	lw $a2, 4($sp)
	lw $a3, 0($sp)
	addi $sp, $sp, 28
	jr $ra

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE
