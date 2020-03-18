#############################################################################################
#												#
#		**NOTE: Input must be typed in for the program to work correctly	     	#
#												#
#############################################################################################

#Define some constants
.eqv true 1 # true = 1
.eqv false 0 #false = 0
.eqv MAX 640 #Max number of characters being read (total)

.data
maze: .space MAX
wasHere: .space MAX
correctPath: .space MAX
width: .word 0
height: .word 0
startX: .word 0
startY: .word 0
endX: .word 0
endY: .word 0

.text
main:
	# $t0 for y
	# $t1 for x
	# $t2 for tempchar
	
	# scanf("%d%d", &width, &height);
	# scanf("%d", &width);
	li $v0,5
	syscall
	la $a0,width
	sw $v0,($a0)
	# scanf("%d", &height);
	li $v0,5
	syscall
	la $a0,height
	sw $v0,($a0)
	# for(y=0; y < height; y++)
	# {
	# for(x=0; x < width; x++)
	# {
	li $t0,0 # y = 0
	j main_for1_loop_outer_check
	
main_for1_loop_outer:

	li $t1,0 # x = 0
	j main_for1_loop_inner_check
	
main_for1_loop_inner:

	# scanf("%c", &tempchar);
	li $v0,12
	syscall 
	move $t2,$v0
	# maze[y][x]=tempchar;
	la $a0,width
	lw $t3,($a0) # $t3 = width
	mulu $t3,$t3,$t0 # $t3 = y * width
	addu $t3,$t3,$t1 # $t3 = y * width + x
	sll $t3,$t3,2 # $t3 = (y * width + x)*4
	la $a0,maze
	addu $a0,$a0,$t3 # $a0 = address of maze[y][x]
	sw $t2,($a0) #  maze[y][x]=tempchar;
	
	# if(tolower(maze[y][x]) == 's')
	# {
	# startX = x;
	# startY = y;
	# }
	# else if( tolower(maze[y][x]) == 'f')
	# {
	# endX = x;
	# endY = y;
	# }
	# $t2 = tempchar = maze[y][x]
	or $t2,$t2,0x20 # convert to lowwer case
	li $t3,'s'
	li $t4,'f'
	beq $t2,$t3,main_for1_loop_inner_if
	beq $t2,$t4,main_for1_loop_inner_ifelse
	j main_for1_loop_inner_endif
	
main_for1_loop_inner_if:

	# startX = x;
	la $a0,startX
	sw $t1,($a0)
	# startY = y;
	la $a0,startY
	sw $t0,($a0)
	j main_for1_loop_inner_endif
	
main_for1_loop_inner_ifelse:

	# endX = x;
	la $a0,endX
	sw $t1,($a0)
	# endY = y;
	la $a0,endY
	sw $t0,($a0)
	
main_for1_loop_inner_endif:

	la $a0,width
	lw $t3,($a0) # $t3 = width
	mulu $t3,$t3,$t0 # $t3 = y * width
	addu $t3,$t3,$t1 # $t3 = y * width + x
	sll $t3,$t3,2 # $t3 = (y * width + x)*4	
	# wasHere[y][x] = false;
	la $a0, wasHere
	addu $a0,$a0,$t3 
	li $t4, false
	sw $t4,($a0) # wasHere[y][x] = false;
	# correctPath[y][x] = false;
	la $a0, correctPath
	addu $a0,$a0,$t3 
	li $t4, false
	sw $t4,($a0) # correctPath[y][x] = false;
	
	
	addi $t1,$t1,1 # x++
main_for1_loop_inner_check:
	la $a0,width
	lw $a0,($a0) # $a0 = width
	blt $t1,$a0,main_for1_loop_inner # x < width
	
	# scanf("%c", &tempchar);
	li $v0,12
	syscall 
	move $t2,$v0 # // This is used to "eat" the newline
	
	addi $t0,$t0,1 # y++
main_for1_loop_outer_check:
	la $a0,height
	lw $a0,($a0) # $a0 = height
	blt $t0,$a0,main_for1_loop_outer # y < height
	
	# recursiveSolve(startX, startY);
	la $a0, startX
	lw $a0,($a0) # $a0 = startX
	la $a1, startY
	lw $a1,($a1) # $a1 = startY
	jal recursiveSolve # recursiveSolve(startX, startY);
	
	# for(y=0; y < height; y++)
	# {
	# for(x=0; x < width; x++)
	# {
	li $t0,0 # y = 0
	j main_for2_loop_outer_check
main_for2_loop_outer:
	li $t1,0 # x = 0
	j main_for2_loop_inner_check
main_for2_loop_inner:
	la $a0,width
	lw $t3,($a0) # $t3 = width
	mulu $t3,$t3,$t0 # $t3 = y * width
	addu $t3,$t3,$t1 # $t3 = y * width + x
	sll $t3,$t3,2 # $t3 = (y * width + x)*4	
	la $a0,correctPath
	addu $a0,$a0,$t3
	lw $t4,($a0) # $t4 = correctPath[y][x]
	li $t5,true
	bne $t4,$t5,main_for2_loop_inner_endif
	# if(correctPath[y][x] == true)
	la $a0,maze
	addu $a0,$a0,$t3
	lw $t4,($a0) # $t4 = maze[y][x]
	li $t5,'S'
	beq $t4,$t5,main_for2_loop_inner_endif
	# if(maze[y][x] != 'S')
	li $t4,'.'
	sw $t4,($a0) # maze[y][x]='.';
main_for2_loop_inner_endif:
	# printf("%c", maze[y][x]);
	la $a0,maze
	addu $a0,$a0,$t3
	lw $a0,($a0) # $a0 = maze[y][x]
	li $v0,11
	syscall
	
	addi $t1,$t1,1 # x++
main_for2_loop_inner_check:
	la $a0,width
	lw $a0,($a0) # $a0 = width
	blt $t1,$a0,main_for2_loop_inner # x < width
	# printf("\n");
	li $v0,11
	li $a0,10
	syscall # printf("\n");
	
	addi $t0,$t0,1 # y++
main_for2_loop_outer_check:
	la $a0,height
	lw $a0,($a0) # $a0 = height
	blt $t0,$a0,main_for2_loop_outer # y < height
	
	# maze[startY][startX] = 'S';
	la $a0,width
	lw $t3,($a0) # $t3 = width
	la $a0,startY
	lw $t0,($a0) # $t0 = startY
	mulu $t3,$t3,$t0 # $t3 = startY * width
	la $a0,startX
	lw $t1,($a0) # $t1 = startX
	addu $t3,$t3,$t1 # $t3 = startY * width + startX
	sll $t3,$t3,2 # $t3 = (startY * width + startX)*4	
	la $a0,maze
	addu $a0,$a0,$t3
	li $t4,'S'
	sw $t4,($a0) # maze[startY][startX] = 'S';
	# exit 
	li $v0,10
	syscall

recursiveSolve: 
	
#arguments:
#	$a0 value of x
#	$a1 value of y
#return value: $v0 true or false

	sub $sp, $sp, 16
	sw $ra,($sp) #push ra
	sw $s0,4($sp) #push s0
	sw $s1,8($sp) #push s1
	sw $s2,12($sp) #push s2
	# we use $s0 for save value of $a0 x
	# we use $s1 for save value of $a1 y
	# we use $s2 for save (y * width + x)*4
	move $s0,$a0
	move $s1,$a1
	la $a0,width
	lw $s2,($a0) # $s2 = width
	mulu $s2,$s2,$s1 # $s2 = y * width
	addu $s2,$s2,$s0 # $s2 = y * width + x
	sll $s2,$s2,2 # $s2 = (y * width + x)*4	
	
	
	la $a0,endX
	lw $a0,($a0) # $a0 = endX
	bne $s0,$a0,recursiveSolve_endif1
	 la $a0,endY
	lw $a0,($a0) # $a0 = endY
	bne $s1,$a0,recursiveSolve_endif1 
	# if(x == endX && y == endY)
	li $v0,true # return true; //Reached end
	j recursiveSolve_done
recursiveSolve_endif1:
	la $a0,maze
	addu $a0,$a0,$s2
	lw $t0,($a0) # $t0 = maze[y][x]
	la $a0,wasHere
	addu $a0,$a0,$s2
	lw $t1,($a0) # $t1 = wasHere[y][x]
	li $t2,2
	li $t3,true
	beq $t0,$t2,recursiveSolve_if2
	beq $t1,$t3,recursiveSolve_if2
	j recursiveSolve_endif2
recursiveSolve_if2: # if(maze[y][x] == 2 || wasHere[y][x])
	li $v0,false
	j recursiveSolve_done# return false;
recursiveSolve_endif2:
	# wasHere[y][x] = true;
	la $a0,wasHere
	addu $a0,$a0,$s2
	li $t0,true
	sw $t0,($a0) # wasHere[y][x] = true;
	la $a0,maze
	addu $a0,$a0,$s2
	lw $t0,($a0) # $t0 = maze[y][x]
	li $t1,'*'
	bne $t0,$t1,recursiveSolve_endif3
	# if(maze[y][x]=='*') 
	li $v0,false
	j recursiveSolve_done# return false;
recursiveSolve_endif3:
	
	beqz $s0,recursiveSolve_endif4
	# if( x != 0) //Left edge
	move $a0,$s0
	addi $a0,$a0,-1 # $a0 = x-1
	move $a1,$s1 # $a1 = y
	jal recursiveSolve
	li $t0,true
	bne $v0,$t0,recursiveSolve_endif4
	# if(recursiveSolve(x-1, y))
	la $a0,correctPath
	addu $a0,$a0,$s2
	li $v0,true
	sw $v0,($a0) # correctPath[y][x] = true;
	j recursiveSolve_done# return true;
recursiveSolve_endif4:
	la $a0,width
	lw $t0,($a0)
	addi $t0,$t0,-1 # $t0 = width - 1
	beq $s0,$t0,recursiveSolve_endif5
	# if(x != width - 1) //Right edge
	move $a0,$s0
	addi $a0,$a0,1 # $a0 = x+1
	move $a1,$s1 # $a1 = y
	jal recursiveSolve
	li $t0,true
	bne $v0,$t0,recursiveSolve_endif5
	# if(recursiveSolve(x + 1, y))
	la $a0,correctPath
	addu $a0,$a0,$s2
	li $v0,true
	sw $v0,($a0) # correctPath[y][x] = true;
	j recursiveSolve_done# return true;
	
recursiveSolve_endif5:
	
	beqz $s1,recursiveSolve_endif6
	# if(y != 0) //Top edge
	move $a0,$s0 # $a0 = x
	move $a1,$s1
	addi $a1,$a1,-1 # $a1 = y - 1
	jal recursiveSolve
	li $t0,true
	bne $v0,$t0,recursiveSolve_endif6
	# if(recursiveSolve(x, y - 1))
	la $a0,correctPath
	addu $a0,$a0,$s2
	li $v0,true
	sw $v0,($a0) # correctPath[y][x] = true;
	j recursiveSolve_done# return true;
	
recursiveSolve_endif6:
	la $a0,height
	lw $t0,($a0)
	addi $t0,$t0,-1 # $t0 = height - 1
	beq $s1,$t0,recursiveSolve_endif7
	# if(y != height - 1) //Bottom edge
	move $a0,$s0 # $a0 = x
	move $a1,$s1
	addi $a1,$a1,1 # $a1 = y + 1
	jal recursiveSolve
	li $t0,true
	bne $v0,$t0,recursiveSolve_endif7
	# if( recursiveSolve(x, y + 1))
	la $a0,correctPath
	addu $a0,$a0,$s2
	li $v0,true
	sw $v0,($a0) # correctPath[y][x] = true;
	j recursiveSolve_done# return true;
recursiveSolve_endif7:
	li $v0,false
recursiveSolve_done:
	lw $ra,($sp) # Restore $ra
	lw $s0,4($sp) # Restore $s0
	lw $s1,8($sp) # Restore $s1
	lw $s2,12($sp) # Restore $s2
	add $sp, $sp, 16
	jr $ra		
