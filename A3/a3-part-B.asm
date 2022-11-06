	.data
KEYBOARD_EVENT_PENDING:
	.word	0x0
KEYBOARD_EVENT:
	.word   0x0
KEYBOARD_COUNTS:
	.space  128
NEWLINE:
	.asciiz "\n"
SPACE:
	.asciiz " "
	
	
	.eqv 	LETTER_a 97
	.eqv	LETTER_b 98
	.eqv	LETTER_c 99
	.eqv 	LETTER_D 100
	.eqv 	LETTER_space 32
	
	
	.text  
main:
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

	la $s0, 0xffff0000	# control register for MMIO Simulator "Receiver"
	lb $s1, 0($s0)
	ori $s1, $s1, 0x02	# Set bit 1 to enable "Receiver" interrupts (i.e., keyboard)
	sb $s1, 0($s0)
	
	la $s0, KEYBOARD_COUNTS # initialized KEYBOARD_COUNTS to be 0 0 0 0
	add $s1, $zero, $zero
	sw $s1, 0($s0)
	sw $s1, 4($s0)
	sw $s1, 8($s0)
	sw $s1, 16($s0)
	


check_for_event:

	### Determines if a keyboard event has occured:
	# - takes action depending on which event occured 
	# - loops through if no event has occured
	
	# $s0 - holds the addresses of values (changed throughout the code) 
	# $s1 - loads the values of the addresses in $s0

	la $s0, KEYBOARD_EVENT_PENDING 	# $s0 - stores address of KEYBOARD_EVENT_PENDING
	lw $s1, 0($s0)			# $s1 - stores the value in KEYBOARD_EVENT_PENDING
	beq $s1, $zero, check_for_event # determines if an event has occured - if not, branches back to check_for_events
	
	la $s0, KEYBOARD_EVENT		# $s0 - stores address of KEYBOARD_EVENT
	lw $s1, 0($s0)			# $s1 - stores the value in KEYBOARD_EVENT
	
	### Determines which key was pressed
	beq $s1, 'a', is_a
	beq $s1, 'b', is_b
	beq $s1, 'c', is_c
	beq $s1, 'd', is_d
	beq $s1, ' ', is_space
	
	### if a different key was pressed, sets pending back to zero
	la $s0, KEYBOARD_EVENT_PENDING
	addi $s1, $zero, 0
	sw $s1, 0($s0)
	beq $zero, $zero, check_for_event
	
is_a: 
	### If keyboard event was an 'a', adds one to the keyboard count of a
	la $s0, KEYBOARD_COUNTS		# $s0 - stores address of KEYBOARD_COUNTS
	lw $s1, 0($s0)			# $s1 - loads address in KEYBOARD_COUNTS at 0
	addi $s1, $s1, 1
	sw $s1, 0($s0)
	
	### if a different key was pressed, sets pending back to zero
	la $s0, KEYBOARD_EVENT_PENDING
	addi $s1, $zero, 0
	sw $s1, 0($s0)
	beq $zero, $zero, check_for_event
	
is_b: 
	la $s0, KEYBOARD_COUNTS
	lw $s1, 4($s0)
	addi $s1, $s1, 1
	sw $s1, 4($s0)
	
	la $s0, KEYBOARD_EVENT_PENDING
	addi $s1, $zero, 0
	sw $s1, 0($s0)
	beq $zero, $zero, check_for_event
	
is_c: 
	la $s0, KEYBOARD_COUNTS
	lw $s1, 8($s0)
	addi $s1, $s1, 1
	sw $s1, 8($s0)
	
	la $s0, KEYBOARD_EVENT_PENDING
	addi $s1, $zero, 0
	sw $s1, 0($s0)
	beq $zero, $zero, check_for_event
	
is_d: 
	la $s0, KEYBOARD_COUNTS
	lw $s1, 12($s0)
	addi $s1, $s1, 1
	sw $s1, 12($s0)
	
	la $s0, KEYBOARD_EVENT_PENDING
	addi $s1, $zero, 0
	sw $s1, 0($s0)
	beq $zero, $zero, check_for_event
	
	
is_space: 

	la $s0, KEYBOARD_COUNTS
	addi $s1, $zero, 0
	
	
is_space_loop:	

	# $a0 - stores the values in KEYBOARD_COUNTS

	lw $a0, 0($s0)
	addi $v0, $zero, 1
	syscall
	
	la $a0, SPACE
	addi $v0, $zero, 4
	syscall
	
	addi $s0, $s0, 4
	addi $s1, $s1, 1
	
	bne $s1, 4, is_space_loop
	
	la $a0, NEWLINE
	addi $v0, $zero, 4
	syscall
	
	la $s0, KEYBOARD_EVENT_PENDING
	addi $s1, $zero, 0
	sw $s1, 0($s0)
	
	beq $zero, $zero, check_for_event
	


	.kdata
	
	# No data in the kernel-data section (at present)

	.ktext 0x80000180	# Required address in kernel space for exception dispatch
__kernel_entry:
	mfc0 $k0, $13		# $13 is the "cause" register in Coproc0
	andi $k1, $k0, 0x7c	# bits 2 to 6 are the ExcCode field (0 for interrupts)
	srl  $k1, $k1, 2	# shift ExcCode bits for easier comparison
	beq $zero, $k1, __is_interrupt
	
__is_exception:
	beq $zero, $zero, __exit_exception
	
__is_interrupt:
	andi $k1, $k0, 0x0100	# examine bit 8
	bne $k1, $zero, __is_keyboard_interrupt	 # if bit 8 set, then we have a keyboard interrupt.
	
	beq $zero, $zero, __exit_exception	# otherwise, we return exit kernel
	
__is_keyboard_interrupt:

	### Sets the value of KEYBOARD_EVENT_PENDING
	addi $k1, $zero, 1
	la $k0, KEYBOARD_EVENT_PENDING
	sw $k1, 0($k0)
	
	# $k0 - stores the address of the keyboard value
	# $k1 - stores the keyboard value
	la $k0, 0xffff0004
	lw $k1, 0($k0)	
	
	# $k0 - stores the keyboard value in KEYBOARD_EVENT
	la $k0, KEYBOARD_EVENT
	sw $k1, 0($k0)
	
	beq $zero, $zero, __exit_exception
	
__exit_exception:
	eret
	
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE

	
