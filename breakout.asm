################ Assembly Breakout ##################
# This file contains My implementation of Breakout.
#
# By: Sheldon Dacon
######################## Bitmap Display Configuration ########################
# - Unit width in pixels:       8
# - Unit height in pixels:      8
# - Display width in pixels:    256
# - Display height in pixels:   256
# - Base Address for Display:   0x10008000 ($gp)
##############################################################################

    .data
##############################################################################
# Immutable Data
##############################################################################
# The address of the bitmap display. Don't forget to connect it!
ADDR_DSPL: .word 0x10008000
# The address of the keyboard. Don't forget to connect it!
ADDR_KBRD: .word 0xffff0000
MAX_D: .word 3672
MIN_D: .word 3584
OFF:   .word 3840

##############################################################################
# Mutable Data
##############################################################################
test1:		.word  3624 	# set rectangle location
ball:		.word 3392	#set ball location
lives:		.word 4		# set number of lives
ogball:		.word 3392	#store ball location archive
time:		.word 60000	# store time 
tally:		.word 0x10008000

# directions
up_left:	.word 1
up:		.word 0
up_right:	.word 1
down:		.word 1
down_right:	.word 1
down_left:	.word 1

# rng for new directions
up_leftr:	.word 1
upr:		.word 1
up_rightr:	.word 1
downr:		.word 1
down_rightr:	.word 1
down_leftr:	.word 1


##############################################################################
# Code
##############################################################################
	.text
	.globl main

	# Run the Brick Breaker game.
main:
    li $t1, 0xff0000        	# $t1 = red
    li $t2, 0x00ff00       	# $t2 = green
    li $t3, 0x0000ff     	# $t3 = blue
    add $t4, $t2, $t1		# $t4 is Yellow made from red and green
    add $t5, $t4, $t3		# $t5 stores white made by adding blue to yellow (white)
    li $s1, 0xff0000        	# $s1 = red
    li $s2, 0x00ff00       	# $s2 = green
    li $s3, 0x0000ff     	# $3 = blue
    li $s4, 0x000000		# $s4 = black pixel

    lw $t0, ADDR_DSPL       	# $t0 = base address for display
    
    
    
# Create rectangle

# horizontal top border
addi $a0, $zero, 2	# set height 
addi $a1, $zero, 32	# set width 
addi $a3, $zero, 768	# set start pixel location
add $a2, $zero, $t5
jal draw_rectangle

# left side border
addi $a0, $zero, 22	# set height 
addi $a1, $zero, 2	# set width 
addi $a3, $zero, 768	# set start pixel location
add $a2, $zero, $t5
jal draw_rectangle

# right side border
addi $a0, $zero, 22	# set height 
addi $a1, $zero, 2	# set width 
addi $a3, $zero, 888	# set start pixel location
add $a2, $zero, $t5
jal draw_rectangle

# paddle
addi $a0, $zero, 1	# set height 
addi $a1, $zero, 10	# set width 
addi $a3, $zero, 3624	# set start pixel location
add $a2, $zero, $t5
jal draw_rectangle

# ball
addi $a0, $zero, 1	# set height 
addi $a1, $zero, 1	# set width 
addi $a3, $zero, 3392	# set start pixel location
add $a2, $zero, $t5
jal draw_rectangle


#draw first row
addi $a0, $zero, 1	# set height 
addi $a1, $zero, 28	# set width 
addi $a3, $zero, 1032	# set start pixel location
add $a2, $zero, $s1
jal draw_rectangle

#draw second row
addi $a0, $zero, 1	# set height 
addi $a1, $zero, 28	# set width 
addi $a3, $zero, 1160	# set start pixel location
add $a2, $zero, $t4
jal draw_rectangle


#draw third row
addi $a0, $zero, 1	# set height 
addi $a1, $zero, 28	# set width 
addi $a3, $zero, 1288	# set start pixel location
add $a2, $zero, $s2
jal draw_rectangle


# wait for 3 seconds
li $v0, 32
li $a0, 3000
syscall

j game_loop





# Rectangle code
draw_rectangle:
lw $t0, ADDR_DSPL 	# $t0 stores the base address for display
add $t0, $t0, $a3 	# start drawing at the cordinates provided by $a3.

# Actually draw the Rectangle

add $t6, $zero, $zero	# Set index value ($t6) to zero
addi $t3, $t0, 0	# creates t3 that stores position of pointer to track
draw_rect_loop:
beq $t6, $a0, Ex  	# If $t6 == height ($a0), jump to end


#Draw a line

add $t7, $zero, $zero	# Set index value ($t7) to zero
draw_line_loop:
beq $t7, $a1, end_draw_line  # If $t7 == width ($a1), jump to end
sw $a2, 0($t0)		#   - Draw a pixel at memory location $ta0
addi $t0, $t0, 4	#   - Increment $t0 by 4
addi $t7, $t7, 1	#   - Increment $t5 by 1
j draw_line_loop
end_draw_line:

addi $t3, $t3, 128      # change to the pointer to next line
addi $t6, $t6, 1	# increase t6 by 1
add $t0, $zero, $t3	# make t0 that piont on the next line

j draw_rect_loop	# Jump to start of rectangle drawing loop

Ex:
jr $ra			# return back to originall function call line

# Blackout function
# resets all the uo down values to 1
blackout:
lw $t8, up			# gets the value of up
addi $t9, $zero, 1		# gets the nukber 1
sw $t9, up			# stores 1 for up

lw $t8, up_left			# gets the value of up_left
addi $t9, $zero, 1		# gets the nukber 1
sw $t9, up_left			# stores 1 for up_left

lw $t8, up_right		# gets the value of up_right
addi $t9, $zero, 1		# gets the nukber 1
sw $t9, up_right		# stores 1 for up_right


lw $t8, down			# gets the value of down
addi $t9, $zero, 1		# gets the nukber 1
sw $t9, down			# stores 1 for down


lw $t8, down_left		# gets the value of down_left
addi $t9, $zero, 1		# gets the nukber 1
sw $t9, down_left		# stores 1 for down_left

lw $t8, down_right		# gets the value of down_right
addi $t9, $zero, 1		# gets the nukber 1
sw $t9, down_right		# stores 1 for down_right

jr $ra				# return to call line

game_loop:
# 1a. Check if key has been pressed
li 	$v0, 32
li 	$a0, 1
	syscall

lw $t0, ADDR_KBRD               # $t0 = base address for keyboard
lw $t8, 0($t0)                  # Load first word from keyboard

beq $t8, 1, keyboard_input      # If first word 1, key is pressed

home:
# Check for Colisions



lw $t0, ADDR_DSPL 	# get start display address
lw $t1, ball		# get ball pixel value
add $t0, $t1, $t0	# get actual ball coordinate
addi $t3, $t0, -128	# make $t3 store the value of the pixel avove ball
addi $t6, $t0, 128	# make $t3 store the value of the pixel below ball
addi $t7, $t0, 0	# make $t3 store the value of the pixel to later check left and right

#0.5 check if we are off the map
lw $t8, OFF			# load value in which to quit the game
bge $t1, $t8, Done		# test to see if ball of the map
# 0.6 check if we are out of time
lw $t8, time
addi $t9 $zero, 0 # create the number zero
beq $t8, $t9, end_game	# check if time is zero

# incremnet timer by 1
addi $t8, $t8, -1	# decrease timer by 1
sw $t8, time		# store value in time


	


# 1. check if we can still go in same direction


# 2. if not reset test vals and see which spaces are clear
#3. rng test val numbers then  test to see if we can move
#4. if yes then make the move 



# move ball
lw $t8, up		# load up value
beqz $t8, move_up 	# if equal to zero move up

lw $t8, down		# down move down value
beqz $t8, move_down	# move down

lw $t8, up_left		# down move down value
beqz $t8, move_up_left	# move up left

lw $t8, up_right	# down move down value
beqz $t8, move_up_right	# move up left

lw $t8, down_right	# down move down value
beqz $t8, move_down_right 	# move down

lw $t8, down_left	# down move down value
beqz $t8, move_down_left 	# move down


err:

# come here if you couldnt move

# if the block is white do nothing else paint a black pixel directly above
# reset test and velocity values
# crate test values and store them then test one by one if they work
# c.1 we must store $t2 right away as we change it when entering rng


jal blackout	# reset all velocity values






# now we know which values we can move to pick a random number
rng:
# generate random number from 0-6
li $v0, 42
li $a0, 0
li $a1, 6
syscall
# assign values for each number

add $t8, $zero, 0	# make $t8 0
beq $t8, $a0, move_up_rng	# go to move_up_rng if rng is 0
add $t8, $zero, 1	# make $t8 1
beq $t8, $a0, move_down_rng	# go to move_down_rng if rng is 1
add $t8, $zero, 2	# make $t8 2
beq $t8, $a0, move_up_left_rng 	# go to move_up_left_rng if rng is 2
add $t8, $zero, 3	# make $t8 0
beq $t8, $a0, move_up_right_rng	# go to move_up_right_rng if rng is 0
add $t8, $zero, 4	# make $t8 1
beq $t8, $a0, move_down_right_rng	# go to move_down_right_rng if rng is 1
add $t8, $zero, 5	# make $t8 2
beq $t8, $a0, move_down_left_rng 	# go to move_down_left_rng if rng is 2

#############

# last part if the rng works make the move
# move_up_rng

move_up_rng:
lw  $t2, 0($t3)		# pull color value of the coodinate above the pixel
bne $t2, $s4, rng	# check if its black($s4) if not go to rng			
sw $s4, 0($t0)		# draw black pixel ball on spot
addi $t0, $t0, -128	# move pointer up 1 space
sw $t5, 0($t0)		# store pixel at new space
addi $t1, $t1, -128	#  move up 1 space in memory for $t1
sw $t1, ball		# store new value in ball

lw $t8, up		# gets the value of up
addi $t9, $zero, 0	# gets the nukber 0
sw $t9, up		# stores 0 for up

j endrng		# go to endrng



# move down_rng
move_down_rng:
lw  $t2, 0($t6)		# pull color value of the coodinate below the pixel
bne $t2, $s4, rng	# check if its black($s4) if not go to rng
sw $s4, 0($t0)		# draw black pixel ball on spot
addi $t0, $t0, 128	# move pointer down 1 space
sw $t5, 0($t0)		# store pixel at new space
addi $t1, $t1, 128	#  move down 1 space in memory for $t1
sw $t1, ball		# store new value in ball	

lw $t8, down		# gets the value of down
addi $t9, $zero, 0	# gets the nukber 0
sw $t9, down		# stores 0 for down

j endrng		# go to endrng

# move upleftrng
move_up_left_rng:
addi $t8, $t3, -4	# store value of pixel to the top left
lw  $t2, 0($t8)		# pull color value of the coodinate above the pixel to the left
bne $t2, $s4, rng	# check if its black($s4) if not go to rng
sw $s4, 0($t0)		# draw black pixel ball on spot
addi $t0, $t0, -132	# move pointer up 1 space to the left
sw $t5, 0($t0)		# store pixel at new space
addi $t1, $t1, -132	# move up 1 space in memory for $t1
sw $t1, ball		# store new value in ball


lw $t8, up_left		# gets the value of up_left
addi $t9, $zero, 0	# gets the nukber 0
sw $t9, up_left		# stores 0 for up_left

j endrng		# go to endrng


# move uprightrng
move_up_right_rng:
addi $t8, $t3, 4	# store value of pixel to the top right
lw  $t2, 0($t8)		# pull color value of the coodinate above the pixel to the right
bne $t2, $s4, rng	# check if its black($s4) if not go to rng
sw $s4, 0($t0)		# draw black pixel ball on spot
addi $t0, $t0, -124	# move pointer up 1 space to the right
sw $t5, 0($t0)		# store pixel at new space
addi $t1, $t1, -124	# move up 1 space in memory for $t1
sw $t1, ball		# store new value in ball

lw $t8, up_right	# gets the value of up_right
addi $t9, $zero, 0	# gets the nukber 0
sw $t9, up_right	# stores 0 for up_right

j endrng		# go to endrng



# movedownrightrng
move_down_right_rng:
addi $t8, $t6, 4	# store value of pixel to the bottom right
lw  $t2, 0($t8)		# pull color value of the coodinate below the pixel to the right
bne $t2, $s4, rng	# check if its black($s4) if not go to rng
sw $s4, 0($t0)		# draw black pixel ball on spot
addi $t0, $t0, 132	# move pointer down 1 space to the right
sw $t5, 0($t0)		# store pixel at new space
addi $t1, $t1, 132	#  move down 1 space in memory for $t1
sw $t1, ball		# store new value in ball	

lw $t8, down_right	# gets the value of down_right
addi $t9, $zero, 0	# gets the nukber 0
sw $t9, down_right	# stores 0 for down_right		

j endrng		# go to endrng


# move downleftrng
move_down_left_rng:
addi $t8, $t6, -4	# store value of pixel to the bottom left
lw  $t2, 0($t8)		# pull color value of the coodinate below the pixel to the left
bne $t2, $s4, rng	# check if its black($s4) if not go to rng
sw $s4, 0($t0)		# draw black pixel ball on spot
addi $t0, $t0, 124	# move pointer down 1 space to the right
sw $t5, 0($t0)		# store pixel at new space
addi $t1, $t1, 124	#  move down 1 space in memory for $t1
sw $t1, ball		# store new value in ball

		
lw $t8, down_left	# gets the value of down_left
addi $t9, $zero, 0	# gets the nukber 0
sw $t9, down_left	# stores 0 for down_left		
		

j endrng		# go to endrng


# at the end go back to game loop and add black pixel if not white
endrng:

lw  $t2, 0($s5)		# pull color value of the saved colision coordinate
beq $t2, $t5, finishrng # if its white then dont draw black pixel
beq $t2, $s3, finishrng # if its blue then dont draw black pixel
beq $t2, $s1, hitred # if its red then go to hitred and draw a yellow pixel
beq $t2, $t4, hityellow # if its yellow then go to hityellow and draw a green pixel

# make the pixel black
sw $s4, 0($s5)		# draw black pixel ball on spot
lw $t8, tally		# load up tally adress
sw $s1, 0($t8)		# store a red dot at the tally location
addi $t8, $t8, 8	# move cursor over by a spaces
sw $t8, tally		# store new value in tally


# wait 1 second and go back
li $v0, 32
li $a0, 100
syscall
b game_loop

finishrng:
# wait for 1 second and go back
li $v0, 32
li $a0, 100
syscall
b game_loop

hitred:
sw $t4, 0($s5)		# draw a yellow pixel on spot

# wait 1 second and go back
li $v0, 32
li $a0, 100
syscall
b game_loop


hityellow:
sw $s2, 0($s5)		# draw a green pixel on spot

# wait 1 second and go back
li $v0, 32
li $a0, 100
syscall
b game_loop







########################################################################################################################
# move up
move_up:
lw  $t2, 0($t3)		# pull color value of the coodinate above the pixel
addi $s5, $t3, 0	# store coordinate you want to go in $s5
bne $t2, $s4, err	# check if its black($s4) if not go to err
sw $s4, 0($t0)		# draw black pixel ball on spot
addi $t0, $t0, -128	# move pointer up 1 space
sw $t5, 0($t0)		# store pixel at new space
addi $t1, $t1, -128	#  move up 1 space in memory for $t1
sw $t1, ball		# store new value in ball

# wait for 1 second
li $v0, 32
li $a0, 100
syscall

b game_loop



# move down
move_down:
lw  $t2, 0($t6)		# pull color value of the coodinate below the pixel
addi $s5, $t6, 0	# store coordinate you want to go in $s5
bne $t2, $s4, err	# check if its black($s4) if not go to err
sw $s4, 0($t0)		# draw black pixel ball on spot
addi $t0, $t0, 128	# move pointer down 1 space
sw $t5, 0($t0)		# store pixel at new space
addi $t1, $t1, 128	#  move down 1 space in memory for $t1
sw $t1, ball		# store new value in ball		

# wait for 1 second
li $v0, 32
li $a0, 100
syscall						
b game_loop

# move upleft
move_up_left:
addi $t8, $t3, -4	# store value of pixel to the top left
addi $s5, $t8, 0	# store coordinate you want to go in $s5
lw  $t2, 0($t8)		# pull color value of the coodinate above the pixel to the left
bne $t2, $s4, err	# check if its black($s4) if not go to err
sw $s4, 0($t0)		# draw black pixel ball on spot
addi $t0, $t0, -132	# move pointer up 1 space to the left
sw $t5, 0($t0)		# store pixel at new space
addi $t1, $t1, -132	# move up 1 space in memory for $t1
sw $t1, ball		# store new value in ball

# wait for 1 second
li $v0, 32
li $a0, 100
syscall
b game_loop

# move upright
move_up_right:
addi $t8, $t3, 4	# store value of pixel to the top right
addi $s5, $t8, 0	# store coordinate you want to go in $s5
lw  $t2, 0($t8)		# pull color value of the coodinate above the pixel to the right
bne $t2, $s4, err	# check if its black($s4) if not go to err
sw $s4, 0($t0)		# draw black pixel ball on spot
addi $t0, $t0, -124	# move pointer up 1 space to the right
sw $t5, 0($t0)		# store pixel at new space
addi $t1, $t1, -124	# move up 1 space in memory for $t1
sw $t1, ball		# store new value in ball

# wait for 1 second
li $v0, 32
li $a0, 100
syscall

b game_loop

# move downright
move_down_right:
addi $t8, $t6, 4	# store value of pixel to the bottom right
addi $s5, $t8, 0	# store coordinate you want to go in $s5
lw  $t2, 0($t8)		# pull color value of the coodinate below the pixel to the right
bne $t2, $s4, err	# check if its black($s4) if not go to err
sw $s4, 0($t0)		# draw black pixel ball on spot
addi $t0, $t0, 132	# move pointer down 1 space to the right
sw $t5, 0($t0)		# store pixel at new space
addi $t1, $t1, 132	#  move down 1 space in memory for $t1
sw $t1, ball		# store new value in ball		

# wait for 1 second
li $v0, 32
li $a0, 100
syscall
b game_loop

# move downleft
move_down_left:
addi $t8, $t6, -4	# store value of pixel to the bottom left
addi $s5, $t8, 0	# store coordinate you want to go in $s5
lw  $t2, 0($t8)		# pull color value of the coodinate below the pixel to the left
bne $t2, $s4, err	# check if its black($s4) if not go to err
sw $s4, 0($t0)		# draw black pixel ball on spot
addi $t0, $t0, 124	# move pointer down 1 space to the right
sw $t5, 0($t0)		# store pixel at new space
addi $t1, $t1, 124	#  move down 1 space in memory for $t1
sw $t1, ball		# store new value in ball		

# wait for 1 second
li $v0, 32
li $a0, 100
syscall
b game_loop



########################################################################################################################

 # 1b. Check which key has been pressed
 
keyboard_input:                  # A key is pressed



lw $a0, 4($t0)                  # Load second word from keyboard
beq $a0, 0x71, respond_to_Q     # Check if the key q was pressed
beq $a0, 0x61, respond_to_A	#Check if the key q was pressed
beq $a0, 0x64, respond_to_D	#Check if the key q was pressed
beq $a0, 0x70, respond_to_P	#Check if the key 0 was pressed



j game_loop


respond_to_Q:
li $v0, 10                      # Quit gracefully
syscall
	
   
respond_to_P:			# we want to pause the game
li 	$v0, 32			# Load keyboard
li 	$a0, 1
	syscall

lw $t0, ADDR_KBRD               # $t0 = base address for keyboard
lw $t8, 0($t0)                  # Load first word from keyboard

beq $t8, 1, load      		# If first word 1, key is pressed
j respond_to_P
load:
lw $a0, 4($t0)                  # Load second word from keyboard
beq $a0, 0x70, exit_p		#Check if the key 0 was pressed
j respond_to_P			# go back to the loop

exit_p:
j home

 
 
 # 2b. Update locations (paddle, ball)
 respond_to_D:

lw $t0, ADDR_DSPL 	# get start display address
lw $t1, test1		# $t1 has the address of test1
li $t2, 0x0000000       # load the color black into t2
add $t0, $t0, $t1	# start drawing at the cordinates provided by test1
lw $t7, MAX_D		# check if paddle is at max right value
beq  $t1, $t7, Max	# if we at the most right possbile, we then must stop and not draw

# move start pixel to draw new paddle
sw $t2, 0($t0)		# draw black pixel over start point
addi $t1, $t1, 4	# move the pixel by 1 space
sw $t1, test1		# store value at test1

# draw  paddle
addi $a0, $zero, 1	# set height 
addi $a1, $zero, 10	# set width 
add $a3, $zero, $t1	# set start pixel location
add $a2, $zero, $t5	# color
jal draw_rectangle
j game_loop

# draw same paddle
Max:
addi $a0, $zero, 1	# set height 
addi $a1, $zero, 10	# set width 
add $a3, $zero, $t1	# set start pixel location
add $a2, $zero, $t5	#color
jal draw_rectangle
j game_loop


respond_to_A:		
lw $t0, ADDR_DSPL 	# get start display address
lw $t1, test1		# $t1 has the address of test1
li $t2, 0x0000000       # load the color black into t2
add $t0, $t0, $t1	# start drawing at the cordinates provided by test1
lw $t7, MIN_D		# get min value
beq  $t1, $t7, Min	# if we at the most left possbile, we then must stop and not draw

# Make the last Pixel black
#addi $t6, $zero, 36	# stores 36
addi $t7, $t0, 36	# stores cordinate of last pixel
sw $t2, 0($t7)		# draw black pixel over last pixel
addi $t1, $t1, -4	#  the start pixel left by 1 space
sw $t1, test1		# store value at test1	


# draw  paddle
addi $a0, $zero, 1	# set height 
addi $a1, $zero, 10	# set width 
add $a3, $zero, $t1	# set start pixel location
add $a2, $zero, $t5	# color
jal draw_rectangle
j game_loop

Min:
# draw same paddle
addi $a0, $zero, 1	# set height 
addi $a1, $zero, 10	# set width 
add $a3, $zero, $t1	# set start pixel location
add $a2, $zero, $t5	# color
jal draw_rectangle
j game_loop



# to add multiple lives we must delete the brick and then jump back to main
#
Done: 
addi, $t8, $zero, 0		# set $t8 to zero
lw $t9, lives			# load lives into $t9
beq $t9, $t8, end_game		# check if have any lives left (4 lives) if so quit
# else draw a black pixel at location and jump back to game_loop and decrease lives
# we also need to reset and draw a new ball at starting point 

lw $t0, ADDR_DSPL 	# get start display address
lw $t1, ball		# get ball pixel value
add $t0, $t1, $t0	# get actual ball coordinate				
sw $s4, 0($t0)		# draw black pixel ball on spot
jal blackout		# blackout velcoity values
addi $a0, $zero, 1	# set height 
addi $a1, $zero, 1	# set width 
addi $a3, $zero, 3392	# set start pixel location
add $a2, $zero, $t5	# set color
jal draw_rectangle

lw $t9, lives		# load lives into $t9
addi $t9, $t9, -1	# decrease lives value by 1
sw $t9, lives		# store new lives value
addi $t8, $zero, 0	# store zero into $t8
sw $t8, up 		#set value to up
add $t9, $zero, 3392	# load 3392 for $t9
sw $t9, ball		# reset ball value 
# wait for 3 seconds
li $v0, 32
li $a0, 3000
syscall

j game_loop	

				
								
															
end_game:																
li $v0, 10                      # Quit gracefully if ball is off the map
syscall

    
