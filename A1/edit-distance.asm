# UVic CSC 230, Spring 2022
# Assignment #1, part B
# (Starter code copyright 2022 Mike Zastre)

# Determine the edit distance of values in registers $12 and $13
# Store this distance in register $20


.text

start:
	lw $12, testcase4_a  # STUDENTS MAY MODIFY THE TESTCASE GIVEN IN THIS LINE
	lw $13, testcase4_b  # STUDENTS MAY MODIFY THE TESTCASE GIVEN IN THIS LINE
	
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

# Your work here.

	# $20 - Result
	# $14 - Counter 
	# $15 - $12 bit 
	# $16 - $13 bit 
	
	addi $14, $0, 0

loop:	
	andi $15, $12, 1
	andi $16, $13, 1
	
	beq $15, $16, continue
	
	addi $20, $20, 1	
	
continue: 

	srl $12, $12, 1
	srl $13, $13, 1
	addi $14, $14, 1
	ble $14, 32, loop

	
		
	
	
	


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

# testcase1: edit distance is 32
testcase1_a:
	.word	0x00000000
testcase1_b:
	.word   0xffffffff
	    

# testcase2: edit distance is 11
testcase2_a:
	.word	0xfacefade
testcase2_b:
	.word   0xdeadbeef
	
	
# testcase3: edit distance is 0
testcase3_a:
	.word	0xaaaa5555
testcase3_b:
	.word   0xaaaa5555
	
	
# testcase4: edit distance is 20
testcase4_a:
	.word	0xc6c6c6c6
testcase4_b:
	.word   0x51515151
