# a2-morse-encode.asm
#
# For UVic CSC 230, Spring 2022
#
# Original file copyright: Mike Zastre
#

.text


main:	



# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

	## Test code that calls procedure for part A
	# jal save_our_souls

	## flash_one_symbol test for part B
	# addi $a0, $zero, 0x42   # dot dot dash dot # 0b01000010
	# jal flash_one_symbol
	
	# flash_one_symbol test for part B
	# addi $a0, $zero, 0x37   # dash dash dash
	# jal flash_one_symbol
		
	## flash_one_symbol test for part B
	# addi $a0, $zero, 0x32  	# dot dash dot # 0b00110010
	# jal flash_one_symbol
			
	## flash_one_symbol test for part B
	# addi $a0, $zero, 0x11   # dash
	# jal flash_one_symbol	
	
	## flash_one_symbol test for part B
	# addi $a0, $zero, 0xff   
	# jal flash_one_symbol	
	
	# display_message test for part C
	# la $a0, test_buffer
	# jal display_message
	
	# char_to_code test for part D
	# the letter 'P' is properly encoded as 0x46.
	# addi $a0, $zero, 'P'
	# jal char_to_code
	
	# char_to_code test for part D
	# the letter 'A' is properly encoded as 0x21
	# addi $a0, $zero, 'A'
	# jal char_to_code
	
	# char_to_code test for part D
	# the space' is properly encoded as 0xff
	# addi $a0, $zero, ' '
	# jal char_to_code
	
	# encode_text test for part E
	# The outcome of the procedure is here
	# immediately used by display_message
	la $a0, message09
	la $a1, buffer01
	jal encode_text
	# la $a0, buffer01
	# jal display_message
	
	# la $a0, message06
	# la $a1, buffer02
	# jal encode_text
	# la $a0, buffer02
	# jal display_message		
	
	# Proper exit from the program.
	addi $v0, $zero, 10
	syscall

	
	
###########
# PROCEDURE
save_our_souls:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal seven_segment_on
	jal delay_short
	jal seven_segment_off
	jal delay_long
	jal seven_segment_on
	jal delay_short
	jal seven_segment_off
	jal delay_long
	jal seven_segment_on
	jal delay_short
	jal seven_segment_off
	jal delay_long
	jal seven_segment_on
	jal delay_long
	jal seven_segment_off
	jal delay_long
	jal seven_segment_on
	jal delay_long
	jal seven_segment_off
	jal delay_long
	jal seven_segment_on
	jal delay_long
	jal seven_segment_off
	jal delay_long
	jal seven_segment_on
	jal delay_short
	jal seven_segment_off
	jal delay_long
	jal seven_segment_on
	jal delay_short
	jal seven_segment_off
	jal delay_long
	jal seven_segment_on
	jal delay_short
	jal seven_segment_off
	jal delay_long
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $31


# PROCEDURE
flash_one_symbol:

	# $s0 - number of dots/dashes
	# $s1 - holds 0 or 1 to determine to flash dot or dash

	addi $sp, $sp, -12
	sw $s0, 8($sp)
	sw $s1, 4($sp)
	sw $ra, 0($sp)
	
	andi $a0, $a0, 0x0ff
	beq $a0, 0xff, ff_case
	
	srl $s0, $a0, 4
	
flash_dot_dash:

	beq $s0, 4, is_four
	beq $s0, 3, is_three
	beq $s0, 2, is_two
	beq $s0, 1, is_one
	beq $s0, 0, end_flash_one_symbol
	
is_four: # gets value at the fourth position and flashes a dot if 0 and dash if 1
	srl $s1, $a0, 3
	andi $s1, $s1, 1
	addi $s0, $s0, -1
	beq $s1, 0, flash_dot
	beq $s1, 1, flash_dash
	
is_three:
	srl $s1, $a0, 2
	andi $s1, $s1, 1
	addi $s0, $s0, -1
	beq $s1, 0, flash_dot
	beq $s1, 1, flash_dash
	
is_two:
	srl $s1, $a0, 1
	andi $s1, $s1, 1
	addi $s0, $s0, -1
	beq $s1, 0, flash_dot
	beq $s1, 1, flash_dash
	
is_one:
	andi $s1, $a0, 1
	addi $s0, $s0, -1
	beq $s1, 0, flash_dot
	beq $s1, 1, flash_dash
	
flash_dot:

	jal seven_segment_on
	jal delay_short
	jal seven_segment_off
	jal delay_long
	beq $zero, $zero, flash_dot_dash
	
flash_dash:

	jal seven_segment_on
	jal delay_long
	jal seven_segment_off
	jal delay_long
	beq $zero, $zero, flash_dot_dash
	
ff_case: # if the character is a space
	jal seven_segment_off
	jal delay_long
	jal delay_long
	jal delay_long
	
	
end_flash_one_symbol:

	lw $ra, 0($sp)
	lw $s1, 4($sp)
	lw $s0, 8($sp)
	addi $sp, $sp, 12
	jr $ra

###########
# PROCEDURE
display_message:

	# $s2 - holds a byte in $a0

	addi $sp, $sp, -12
	sw $s2, 8($sp)
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	
iterate_through_buffer: # iterates through each byte in the buffer and calls flash_one_symbol

	lb $s2, 0($a0)
	beq $s2, $zero, end_display_message
	addi $a0, $a0, 1
	sw $a0, 0($sp)
	add $a0, $s2, $zero
	jal flash_one_symbol
	jal seven_segment_off
	jal delay_long
	lw $a0, 0($sp)
	beq $zero, $zero, iterate_through_buffer
	
end_display_message: 

	lw $a0, 0($sp)
	lw $ra, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12
	jr $ra
	
	
###########
# PROCEDURE
char_to_code:
	
	# $s0 - stores codes
	# $s1 - loads the characters from codes
	# $s2 - holds position of $s0
	# $s3 - holds number of dots and dashes
	# $s5 - stores result
	addi $sp, $sp, -20
	sw $s0, 16($sp)
	sw $s1, 12($sp)
	sw $s2, 8($sp)
	sw $s3, 4($sp)
	sw $s5, 0($sp)
	
	la $s0, codes
	beq $a0, ' ', is_space
	
find_character: # determines the location of the character in $a0 in codes

	lb $s1, 0($s0)
	beq $s1, $a0, out
	addi $s0, $s0, 8
	beq $zero, $zero, find_character
	
out:

	addi $s0, $s0, 1
	add $s2, $s0, $zero
	
iterate_through_dots_dashes: # counts the number of dots and dashes of the given character

	lb $s1, 0($s0)
	beq $s1, 0, create_high_nibble
	addi $s3, $s3, 1
	addi $s0, $s0, 1
	beq $zero, $zero, iterate_through_dots_dashes
	
create_high_nibble:
	
	andi $s5, $s3, 0xf
	sll $s5, $s5, 4
	add $s0, $s2, $zero
	
create_low_nibble: # creates low nibble by determining position of dashes and setting the bit

	lb $s1, 0($s0)
	beq $s1, $zero, end_char_to_code
	beq $s1, '-', is_dash
	addi $s3, $s3, -1
	addi $s0, $s0, 1
	beq $zero, $zero, create_low_nibble
	
is_dash: 

	beq $s3, 4, four
	beq $s3, 3, three
	beq $s3, 2, two
	beq $s3, 1, one
	
four:	
	ori $s5, $s5, 8
	addi $s3, $s3, -1
	addi $s0, $s0, 1
	beq $zero, $zero, create_low_nibble
	
three:
	ori $s5, $s5, 4
	addi $s3, $s3, -1
	addi $s0, $s0, 1
	beq $zero, $zero, create_low_nibble
	
two:
	ori $s5, $s5, 2
	addi $s3, $s3, -1
	addi $s0, $s0, 1
	beq $zero, $zero, create_low_nibble
	
one:
	ori $s5, $s5, 1
	addi $s3, $s3, -1
	addi $s0, $s0, 1
	beq $zero, $zero, create_low_nibble
	
is_space:
	addi $s5, $zero, 0xff
	
end_char_to_code:	

	add $v0, $s5, $zero
	
	sw $s5, 0($sp)
	sw $s3, 4($sp)
	sw $s2, 8($sp)
	sw $s1, 12($sp)
	sw $s0, 16($sp)
	addi $sp, $sp, 20
	
	jr $ra	


###########
# PROCEDURE
encode_text:

	# $s0 - holds the characters in $a0
	
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	
get_letter: # iterates through $a0, calls char_to_code and adds the returned value to $a1
	
	lb $s0, 0($a0)
	beq $s0, $zero, end_encode_text
	addi $a0, $a0, 1
	sw $a0, 0($sp)
	add $a0, $s0, $zero
	
	jal char_to_code
	
	sb $v0, 0($a1)
	addi $a1, $a1, 1
	lw $a0, 0($sp)
	beq $zero, $zero, get_letter
	
end_encode_text:

	lw $ra, 4($sp)
	addi $sp, $sp, 8
	jr $ra

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE

#############################################
# DO NOT MODIFY ANY OF THE CODE / LINES BELOW

###########
# PROCEDURE
seven_segment_on:
	la $t1, 0xffff0010     # location of bits for right digit
	addi $t2, $zero, 0xff  # All bits in byte are set, turning on all segments
	sb $t2, 0($t1)         # "Make it so!"
	jr $31


###########
# PROCEDURE
seven_segment_off:
	la $t1, 0xffff0010	# location of bits for right digit
	sb $zero, 0($t1)	# All bits in byte are unset, turning off all segments
	jr $31			# "Make it so!"
	

###########
# PROCEDURE
delay_long:
	add $sp, $sp, -4	# Reserve 
	sw $a0, 0($sp)
	addi $a0, $zero, 600
	addi $v0, $zero, 32
	syscall
	lw $a0, 0($sp)
	add $sp, $sp, 4
	jr $31

	
###########
# PROCEDURE			
delay_short:
	add $sp, $sp, -4
	sw $a0, 0($sp)
	addi $a0, $zero, 200
	addi $v0, $zero, 32
	syscall
	lw $a0, 0($sp)
	add $sp, $sp, 4
	jr $31




#############
# DATA MEMORY
.data
codes:
	.byte 'A', '.', '-', 0, 0, 0, 0, 0
	.byte 'B', '-', '.', '.', '.', 0, 0, 0
	.byte 'C', '-', '.', '-', '.', 0, 0, 0
	.byte 'D', '-', '.', '.', 0, 0, 0, 0
	.byte 'E', '.', 0, 0, 0, 0, 0, 0
	.byte 'F', '.', '.', '-', '.', 0, 0, 0
	.byte 'G', '-', '-', '.', 0, 0, 0, 0
	.byte 'H', '.', '.', '.', '.', 0, 0, 0
	.byte 'I', '.', '.', 0, 0, 0, 0, 0
	.byte 'J', '.', '-', '-', '-', 0, 0, 0
	.byte 'K', '-', '.', '-', 0, 0, 0, 0
	.byte 'L', '.', '-', '.', '.', 0, 0, 0
	.byte 'M', '-', '-', 0, 0, 0, 0, 0
	.byte 'N', '-', '.', 0, 0, 0, 0, 0
	.byte 'O', '-', '-', '-', 0, 0, 0, 0
	.byte 'P', '.', '-', '-', '.', 0, 0, 0
	.byte 'Q', '-', '-', '.', '-', 0, 0, 0
	.byte 'R', '.', '-', '.', 0, 0, 0, 0
	.byte 'S', '.', '.', '.', 0, 0, 0, 0
	.byte 'T', '-', 0, 0, 0, 0, 0, 0
	.byte 'U', '.', '.', '-', 0, 0, 0, 0
	.byte 'V', '.', '.', '.', '-', 0, 0, 0
	.byte 'W', '.', '-', '-', 0, 0, 0, 0
	.byte 'X', '-', '.', '.', '-', 0, 0, 0
	.byte 'Y', '-', '.', '-', '-', 0, 0, 0
	.byte 'Z', '-', '-', '.', '.', 0, 0, 0
	
message01:	.asciiz "A A A"
message02:	.asciiz "SOS"
message03:	.asciiz "WATERLOO"
message04:	.asciiz "DANCING QUEEN"
message05:	.asciiz "CHIQUITITA"
message06:	.asciiz "THE WINNER TAKES IT ALL"
message07:	.asciiz "MAMMA MIA"
message08:	.asciiz "TAKE A CHANCE ON ME"
message09:	.asciiz "KNOWING ME KNOWING YOU"
message10:	.asciiz "FERNANDO"

buffer01:	.space 128
buffer02:	.space 128
test_buffer:	.byte 0x21 0xff 0x21 # This is SOS
