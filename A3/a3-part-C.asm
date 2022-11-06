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
	
	.globl main
	.text	
main:
	addi $a0, $zero, 0
	addi $a1, $zero, 0
	addi $a2, $zero, 0x00ff0000
	jal draw_bitmap_box
	
	addi $a0, $zero, 11
	addi $a1, $zero, 6
	addi $a2, $zero, 0x00ffff00
	jal draw_bitmap_box
	
	addi $a0, $zero, 8
	addi $a1, $zero, 8
	addi $a2, $zero, 0x0099ff33
	jal draw_bitmap_box
	
	addi $a0, $zero, 2
	addi $a1, $zero, 3
	addi $a2, $zero, 0x00000000
	jal draw_bitmap_box

	addi $v0, $zero, 10
	syscall
	
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv


# Draws a 4x4 pixel box in the "Bitmap Display" tool
# $a0: row of box's upper-left corner
# $a1: column of box's upper-left corner
# $a2: colour of box
# $t4 - holds the initial column position
# $t5 - counter for the rows
# $t6 - counter for the columns

draw_bitmap_box:

	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	add $t4, $a1, $zero 
	add $t5, $zero, $zero 
	add $t6, $zero, $zero 
	
draw_box:
	### Draws four pixels for each row
	jal set_pixel
	beq $t6, 3, increment_row # if four pixels have been drawn - increments the row
	addi $t6, $t6, 1
	addi $a1, $a1, 1
	beq $zero, $zero, draw_box
	
increment_row:
	beq $t5, 3, end_draw_bitmap_box # ends if the box has been drawn 
	addi $a0, $a0, 1 # increments the row number
	addi $t5, $t5, 1 # increments the row counter
	add $a1, $t4, $zero	# sets $a0, the column, back to the initial column
	add $t6, $zero, $zero	# sets $t6 back to zero
	beq $zero, $zero, draw_box
	
end_draw_bitmap_box:
	lw $ra, 0($sp)
	addi $sp, $sp, 8
	jr $ra

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE
