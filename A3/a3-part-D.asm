# This code assumes the use of the "Bitmap Display" tool.
#
# Tool settings must be:
#   Unit Width in Pixels: 32
#   Unit Height in Pixels: 32
#   Display Width in Pixels: 512
#   Display Height in Pixels: 512
#   Based Address for display: 0x10010000 (static data)
#
# In effect, this produces a bitmap display of 16x16 pixels.


	.include "bitmap-routines.asm"

	.data
TELL_TALE:
	.word 0x12345678 0x9abcdef0	# Helps us visually detect where our part starts in .data section
KEYBOARD_EVENT_PENDING:
	.word	0x0
KEYBOARD_EVENT:
	.word   0x0
BOX_ROW:
	.word	0x0
BOX_COLUMN:
	.word	0x0

	.eqv LETTER_a 97
	.eqv LETTER_d 100
	.eqv LETTER_w 119
	.eqv LETTER_s 115
    .eqv SPACE    32
	.eqv BOX_COLOUR 0x0099ff33
	
	.globl main
	
	.text	
main:
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
	
	la $s0, 0xffff0000	# control register for MMIO Simulator "Receiver"
	lb $s1, 0($s0)
	ori $s1, $s1, 0x02	# Set bit 1 to enable "Receiver" interrupts (i.e., keyboard)
	sb $s1, 0($s0)
	
	# $t8 - holds the colour of the box
	
	addi $t8, $zero, 0x0099ff33
	add $a2, $zero, $t8 		# sets box colour
	jal draw_bitmap_box 		# initialized the first box 
	
check_for_event:

	### Determines if a keyboard event has occured:
	# - takes action depending on which event occured 
	# - loops through if no event has occured
	
	# $s0 - holds the address of values throught the code
	# $s1 - loads the values in $s0
	# $a0 - loads value of BOX_ROW
	# $a1 - loads value for BOX_COLUMN
	# $a2 - holds colour of the box
	

	la $s0, KEYBOARD_EVENT_PENDING 	# $s0 - stores address of KEYBOARD_EVENT_PENDING
	lw $s1, 0($s0)			# $s1 - stores the value in KEYBOARD_EVENT_PENDING
	beq $s1, $zero, check_for_event	# determines if an event has occured - if not, branches back to check_for_events
	
	la $s0, KEYBOARD_EVENT		# $s0 - stores address of KEYBOARD_EVENT
	lw $s1, 0($s0)			# $s1 - stores the value in KEYBOARD_EVENT
	
	### Determines which key was pressed
	beq $s1, 'a', is_a
	beq $s1, 'd', is_d
	beq $s1, 'w', is_w
	beq $s1, 's', is_s
	beq $s1, ' ', is_space
	
	### if a different key was pressed, sets pending back to zero
	la $s0, KEYBOARD_EVENT_PENDING
	addi $s1, $zero, 0
	sw $s1, 0($s0)
	beq $zero, $zero, check_for_event
	
is_a:  

	# $a0 - loads value of BOX_ROW
	# $a1 - loads value for BOX_COLUMN
	# $a2 - holds colour of the box
	
	la $s0, BOX_ROW		# $s0 - holds address for BOX_ROW
	lw $a0, 0($s0)		
	la $s0, BOX_COLUMN	# $s0 - holds address for BOX_COLUMN
	lw $a1, 0($s0)	
	addi $a2, $zero, 0x00000000 
	jal draw_bitmap_box	# draws over box
	
	add $a2, $a2, $t8
	la $s0, BOX_ROW
	lw $a0, 0($s0)
	la $s0, BOX_COLUMN
	lw $a1, 0($s0)
	addi $a1, $a1, -1	# decreases $a1 by 1 to move box to the left
	la $s0, BOX_COLUMN	# $s0 - holds address for BOX_COLUMN
	sw $a1, 0($s0)		# stores new value of the box column
	jal draw_bitmap_box
	
	# unsets pending
	la $s0, KEYBOARD_EVENT_PENDING
	addi $s1, $zero, 0
	sw $s1, 0($s0)
	beq $zero, $zero, check_for_event
	
	
	
is_d: 

	la $s0, BOX_ROW
	lw $a0, 0($s0)
	la $s0, BOX_COLUMN
	lw $a1, 0($s0)
	addi $a2, $zero, 0x00000000
	jal draw_bitmap_box
	
	add $a2, $a2, $t8
	la $s0, BOX_ROW
	lw $a0, 0($s0)
	la $s0, BOX_COLUMN
	lw $a1, 0($s0)
	addi $a1, $a1, 1	# adds 1 to $a1 to move box one column to the left
	la $s0, BOX_COLUMN
	sw $a1, 0($s0)		# updates BOX_COLUMN
	jal draw_bitmap_box
	
	la $s0, KEYBOARD_EVENT_PENDING
	addi $s1, $zero, 0
	sw $s1, 0($s0)
	beq $zero, $zero, check_for_event
	
is_w: 

	la $s0, BOX_ROW
	lw $a0, 0($s0)
	la $s0, BOX_COLUMN
	lw $a1, 0($s0)
	addi $a2, $zero, 0x00000000
	jal draw_bitmap_box
	
	add $a2, $a2, $t8
	la $s0, BOX_ROW
	lw $a0, 0($s0)
	la $s0, BOX_COLUMN
	lw $a1, 0($s0)
	addi $a0, $a0, -1		# subtracts 1 from $a0 to move box up by one row
	la $s0, BOX_ROW
	sw $a0, 0($s0)
	jal draw_bitmap_box
	
	la $s0, KEYBOARD_EVENT_PENDING
	addi $s1, $zero, 0
	sw $s1, 0($s0)
	beq $zero, $zero, check_for_event
	
	
is_s: 

	la $s0, BOX_ROW
	lw $a0, 0($s0)
	la $s0, BOX_COLUMN
	lw $a1, 0($s0)
	addi $a2, $zero, 0x00000000
	jal draw_bitmap_box
	
	add $a2, $a2, $t8
	la $s0, BOX_ROW
	lw $a0, 0($s0)
	la $s0, BOX_COLUMN
	lw $a1, 0($s0)
	addi $a0, $a0, 1		# adds 1 to $a0 to move box down by one column
	la $s0, BOX_ROW
	sw $a0, 0($s0)
	jal draw_bitmap_box
	
	la $s0, KEYBOARD_EVENT_PENDING
	addi $s1, $zero, 0
	sw $s1, 0($s0)
	beq $zero, $zero, check_for_event
	
is_space:

	la $s0, BOX_ROW
	lw $a0, 0($s0)
	la $s0, BOX_COLUMN
	lw $a1, 0($s0)
	add $a2, $zero, $t8
	
	beq $a2, 0x00953462, is_v_number	# determines the colour of the box
	
	addi $t8, $zero, 0x00953462		# sets box colour to be v number
	add $a2, $zero, $t8
	jal draw_bitmap_box
	
	la $s0, KEYBOARD_EVENT_PENDING
	addi $s1, $zero, 0
	sw $s1, 0($s0)
	beq $zero, $zero, check_for_event
	
	
is_v_number:
	addi $t8, $zero, 0x0099ff33		# if box colour is already v number, returns it to its origional colour
	add $a2, $zero, $t8
	jal draw_bitmap_box
	
	la $s0, KEYBOARD_EVENT_PENDING
	addi $s1, $zero, 0
	sw $s1, 0($s0)
	beq $zero, $zero, check_for_event
	
	

	
	
	
	# Should never, *ever* arrive at this point
	# in the code.	

	addi $v0, $zero, 10

.data
    .eqv BOX_COLOUR_BLACK 0x00000000
.text

	addi $v0, $zero, BOX_COLOUR_BLACK
	syscall



# Draws a 4x4 pixel box in the "Bitmap Display" tool
# $a0: row of box's upper-left corner
# $a1: column of box's upper-left corner
# $a2: colour of box


#
# You can copy-and-paste some of your code from part (c)
# to provide the procedure body.
#
draw_bitmap_box:

	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	add $t4, $a1, $zero
	add $t5, $zero, $zero # $t5 - counter for the rows
	add $t6, $zero, $zero # $t6 - counter for the columns
	
draw_box:
	jal set_pixel
	beq $t6, 3, increment_row
	addi $t6, $t6, 1
	addi $a1, $a1, 1
	beq $zero, $zero, draw_box
	
increment_row:
	beq $t5, 3, end_draw_bitmap_box
	addi $a0, $a0, 1
	addi $t5, $t5, 1
	add $a1, $t4, $zero
	add $t6, $zero, $zero
	beq $zero, $zero, draw_box
	
end_draw_bitmap_box:
	lw $ra, 0($sp)
	addi $sp, $sp, 8
	jr $ra


	.kdata

	.ktext 0x80000180
#
# You can copy-and-paste some of your code from part (a)
# to provide elements of the interrupt handler.
#
	
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

	addi $k1, $zero, 1			# sets KEYBOARD_EVENT_PENDING
	la $k0, KEYBOARD_EVENT_PENDING
	sw $k1, 0($k0)
	
	la $k0, 0xffff0004			# $k0 - gets the address of the value of the key pressed
	lw $k1, 0($k0)				# $k1 - loads the value of the key pressed
	
	la $k0, KEYBOARD_EVENT			# $k0 - gets the address of KEYBOARD_EVENT
	sw $k1, 0($k0)				# $k1 - sets the KEYBOARD_EVENT
	
	beq $zero, $zero, __exit_exception
	
__exit_exception:
	eret

.data

# Any additional .text area "variables" that you need can
# be added in this spot. The assembler will ensure that whatever
# directives appear here will be placed in memory following the
# data items at the top of this file.

	
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE


.eqv BOX_COLOUR_WHITE 0x00FFFFFF
	
