.data
animals: .space 1200 #  20 * 60 = 1200
lyrics: .space 1200 #  20 * 60 = 1200
number: .word 0 
end: .asciiz "END"
msg1: .asciiz "There was an old lady who swallowed a "
msg2: .asciiz "She swallowed the "
msg21: .asciiz " to catch the "
msg3: .asciiz "I don't know why she swallowed a "
msg31: .asciiz " - "
msg4: .asciiz ";"
.text
main:
	# int i = 0 we use $s0 for i 
	li $s0,0
while_loop:
	# fgets(animals[i], 60, stdin);
	mul $t0,$s0,60 # $t0 = $s0 * 60
	la $a0,animals
	addu $a0,$a0,$t0 # $a0 address of animals[i]
	li $v0,8
	li $a1,60
	syscall
loop_find_newline:
	lbu $t0,($a0)
	beq $t0,10, loop_find_newline_done
	addi $a0,$a0,1
	j loop_find_newline
loop_find_newline_done:
	li $t0,0
	sb $t0,($a0) # animals[i][strlen(animals[i]) - 1] = '\0';
	# if(strcmp(animals[i], "END") == 0) break ;
	mul $t0,$s0,60 # $t0 = $s0 * 60
	la $a0,animals
	addu $a0,$a0,$t0 # $a0 address of animals[i]
	la $a1,end
	jal strcmp
	beqz $v0,while_loop_done
	# update counter
	addi $s0,$s0,1 # i +=1;
	j while_loop
while_loop_done:
	# number = i + 1;
	addi $t0,$s0,1 # $t0 = i + 1
	la $a0,number
	sw $t0,($a0) # number = i + 1;
	# nurseryrhyme(0);
	li $a0,0
	jal nurseryrhyme
	
	# exit 
	li $v0,10
	syscall
	
# ============================================================================
strcmp: # we need jsut equalse case :) 
#description: 
#	compare two strings
#arguments:
#	$a0 address of str1
#	$a1 address of str2
#return value: $v0 0 if equalse -1 if not 
	sub $sp, $sp, 4	#push $ra  the stack
	sw $ra,($sp) #push ra
strcmp_loop:	
	lbu $t0,($a0)
	lbu $t1,($a1)
	bne $t0,$t1,strcmp_not_equals
	beqz $t0,strcmp_equals
	addi $a0,$a0,1
	addi $a1,$a1,1
	j strcmp_loop
strcmp_not_equals:
	li $v0,-1
	j strcmp_done
strcmp_equals:
	li $v0,0
strcmp_done:
	lw $ra,($sp) # pop ra
	add $sp, $sp, 4
	jr $ra		
# ============================================================================

# ============================================================================
nurseryrhyme: 
#description: 
#	
#arguments:
#	$a0 value of current
#return value: none
	sub $sp, $sp, 8
	sw $ra,($sp) #push ra
	sw $s0,4($sp) #push s0
	# we use $t0 as i 
	# for(i = 0; i < current/2; i++)
	# printf(" ");
	move $s0,$a0
	li $v0,11 # for print space character
	li $a0,' '
	li $t0,0 # i=0
	j nurseryrhyme_Spacing_Loop_check
nurseryrhyme_Spacing_Loop:
	syscall # printf(" ");
	addi $t0,$t0,1 # i++
nurseryrhyme_Spacing_Loop_check:
	blt $t0,$s0,nurseryrhyme_Spacing_Loop
	la $a0,number
	lw $a0,($a0)
	addi $a0,$a0,-2 # $a0 = number - 2
	bge $s0,$a0,nurseryrhyme_Recursive_Call
	# if(current < number - 2)
	li $v0,4 # for print string
	bnez $s0,nurseryrhyme_Swallowed_Lines_else
	#if(current == 0)
	# printf("There was an old lady who swallowed a %s;\n", animals[current]);
	la $a0,msg1
	syscall
	mulu $t1,$s0,60
	la $a0,animals
	addu $a0,$a0,$t1 # $a0 = address of animals[current]
	syscall 
	la $a0, msg4
	syscall
	li $v0,11
	li $a0,10
	syscall # newline
	j nurseryrhyme_Recursive_Call
nurseryrhyme_Swallowed_Lines_else:
	# printf("She swallowed the %s to catch the %s;\n", animals[current - 2],animals[current]);
	la $a0,msg2
	syscall
	addi $t1,$s0,-2
	mulu $t1,$t1,60
	la $a0,animals
	addu $a0,$a0,$t1 # $a0 = address of animals[current-2]
	syscall
	move $t1,$a0
	la $a0,msg21
	syscall
	move $a0,$t1
	addu $a0,$a0,120 # $a0 = address of animals[current]
	syscall
	la $a0, msg4
	syscall
	li $v0,11
	li $a0,10
	syscall # newline
nurseryrhyme_Recursive_Call:
	addi $t1,$s0,2 # $t1 = current + 2
	la $a0,number
	lw $a0,($a0)
	addi $a0,$a0,-1 # $a0 = number - 1
	bge $t1,$a0,nurseryrhyme_Recursive_Call_done
	# if(current + 2 < number - 1)
	move $a0,$t1 
	jal nurseryrhyme # nurseryrhyme(current + 2);
nurseryrhyme_Recursive_Call_done:
	# for(i = 0; i < current/2; i)
	# printf(" ");
	li $v0,11 # for print space character
	li $a0,' '
	li $t0,0 # i=0
	j nurseryrhyme_Spacing_Loop_check_2
nurseryrhyme_Spacing_Loop_2:
	syscall # printf(" ");
	addi $t0,$t0,1 # i++
nurseryrhyme_Spacing_Loop_check_2:
	blt $t0,$s0,nurseryrhyme_Spacing_Loop_2
	# printf("I don't know why she swallowed a %s - %s\n", animals[current],animals[current + 1]);
	li $v0,4
	la $a0,msg3
	syscall
	mulu $t1,$s0,60
	la $a0,animals
	addu $a0,$a0,$t1 # $a0 = address of animals[current]
	syscall 
	move $t1,$a0
	la $a0,msg31
	syscall
	move $a0,$t1
	addiu $a0,$a0,60 # $a0 = address of animals[current+1]
	syscall
	li $v0,11
	li $a0,10
	syscall # newline
	
	lw $ra,($sp) # pop ra
	lw $s0,4($sp) # pop s0
	add $sp, $sp, 8
	jr $ra		
# ============================================================================
