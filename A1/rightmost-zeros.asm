# UVic CSC 230, Spring 2022
# Assignment #1, part A
# (Starter code copyright 2022 Mike Zastre)

# Determine the number of right-most zeros in register $12's value
# Store this number in register $15


.text

start:
	lw $12, testcase1  # STUDENTS MAY MODIFY THE TESTCASE GIVEN IN THIS LINE
	
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv


# Your work here.

	# $15 - counter 
	# $14 - stores least significant bit 
	# $4 - stores 1
	
	addi $4, $0, 1
	add $15, $15, $0
	
count_zeros:
	andi $14, $12, 1
	beq $14, $4, end
	addi $15, $15, 1
	srl $12, $12, 1
	beq $15, 32, end
	beq $14, $0, count_zeros
	
end:
	
	
	


# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE

# The three lines of code below will eventually be
# explained in a bit more detail in CSC 230. In
# essence, MARS provides something similar to the
# system-call interface provided by many operating
# systems -- and one very important task an OS
# must do is to stop/terminate a running job. In
# essence, the code below causes MARS to stop your
# program in a safe way. (And believe you me --
# throughout the term there will be times when you
# write programs that do *not* end safely because
# of a bug (or three!).


exit:
	add $2, $0, 10
	syscall
		


.data

# Note: These test cases are not exhaustive. The teaching team
# will use other test cases when evaluating student submissions
# for this part of the assignment.

testcase1:
	.word	0x00200020    # right-most zero bits is 5

testcase2:
	.word 	0xfacefade    # right-most zero bits is 1
	
testcase3:
	.word  0x12030400     # right-most zero bits is 10
	
testcase4:
	.word  0xc0000000    # right-most zero bits is 30
	
testcase5:
	.word  0x3000000a     # right-most zero bits is 1

