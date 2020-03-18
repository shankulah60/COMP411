.eqv MAX_STRING_SIZE 32

.data 
	myStack:		.space 80					
	inLine:	.space MAX_STRING_SIZE

.text 

main:

	
	la $a0, inLine				#Load the address of inLine into $a0
	ori $a1, $0, MAX_STRING_SIZE		#Max line size	
	li $v0, 8				#syscall code for read string
	syscall
	
	lbu $t1, inLine($0)			#Load the first byte of inLine
	addi $t0, $0, '0'
	beq $t0, $t1, exit			#if(char == terminating_char) {terminate program}
		
	add $s0, $0, $0
	add $s1, $0, $0

breaking:

	jal		get
	slt		$t0, $v0, $0				#Set $t0 to 1 if $v0 is < 0
	bne		$t0, $0, operator			#If ^ = true, then go to operator (Found an operator)
	
number:

	sw $v0, myStack($s0)					#Store number on myStack
	addiu $s0, $s0, 4
	j breaking

operator:

	addi $t0, $0, -1					
	beq $t0, $v0, addition					#Found a plus sign	
	addi $t0, $0, -2					
	beq $t0, $v0, subtraction				#Found a subtraction sign	
	addi $t0, $0, -3					
	beq $t0, $v0, multiplication				#Found a multiplication sign	
	addi $t0, $0, -4					
	beq $t0, $v0, division					#Found a division sign
	addi $t0, $0, -5					
	beq $t0, $v0, new_line					#Found a newline sign
	
addition:

	addiu $s0, $s0, -4					#Add space to myStack (calcultion stack)	
	lw $t2, myStack($s0)					#Load the number in myStack into $s2
	addiu $s0, $s0, -4					#Decrement myStack by 1, to represent the adder that was loaded
	lw $t1, myStack($s0)					#Load the next number in the stack (to be added)
	add $t0, $t1, $t2					#Add the two numbers
	sw $t0, myStack($s0)					#Store the result back onto myStack for other calculations or to be written
	addiu $s0, $s0, 4					#Delete the added stack space on myStack
	j breaking						#Go to breaking function

subtraction:

	addiu $s0, $s0, -4					
	lw $t2, myStack($s0)					
	addiu $s0, $s0, -4					
	lw $t1, myStack($s0)					
	sub $t0, $t1, $t2					
	sw $t0, myStack($s0)					
	addiu $s0, $s0, 4					
	j breaking					

multiplication:

	addiu $s0, $s0, -4					
	lw $t2, myStack($s0)					
	addiu $s0, $s0, -4					
	lw $t1, myStack($s0)					
	mult $t1, $t2					
	mflo $t0					
	sw $t0, myStack($s0)					
	addiu $s0, $s0, 4					
	j breaking					

division:

	addiu $s0, $s0, -4					
	lw $t2, myStack($s0)					
	addiu $s0, $s0, -4					
	lw $t1, myStack($s0)					
	div $t1, $t2					
	mflo $t0					
	sw $t0, myStack($s0)					
	addiu $s0, $s0, 4					
	j breaking					
	
new_line:

	addiu $s0, $s0, -4					
	lw $a0, myStack($s0)					
	ori $v0, $0, 1					
	syscall
	addi $a0, $0, '\n'					
	ori $v0, $0, 11					
	syscall

end_breaking:
	j main					
	
get:

	lbu $t1, inLine($s1)					
	addi $t0, $0, ' '					
	bne $t0, $t1, start				#if(char != ' ') {start}		
	addiu $s1, $s1, 1
	j get					
	
start:

	lbu $t1, inLine($s1)					

	addi	$t0, $0, '+'					
	beq $t0, $t1, rtn_add				#Found add			
	
	addi $t0, $0, '-'					
	beq $t0, $t1, rtn_sub				#Found sub	
		
	addi $t0, $0, '*'					
	beq $t0, $t1, rtn_mult				#Found mult	
	
	addi $t0, $0, '/'					
	beq $t0, $t1, rtn_div				#Found div	
	
	addi $t0, $0, '\n'					
	beq $t0, $t1, rtn_nl				#Found newline	
	
	add $t2, $0, $0					#int temp = 0;
	
number_loop:

	lbu $t1, inLine($s1)					
	
	addiu $t3, $0, '0'					
	addiu $t3, $t3, -1					
	slt $t0, $t3, $t1					
	beq $t0, $0, return_none				#Less than 0? not supported			
	
	addiu $t3, $0, '9'					
	addiu $t3, $t3, 1					
	slt $t0, $t1, $t3					
	beq $t0, $0, return_none				#Greater than 9? Not supported	
	
	addi $t0, $0, 10					
	mult $t0, $t2					
	mflo $t2					
	
	addi	$t0, $0, '0'					
	subu $t0, $t1, $t0					
	add $t2, $t2, $t0					
	
	addiu	$s1, $s1, 1					
	j number_loop					

return_none:

	add $v0, $0, $t2					
	jr $ra					

rtn_add:

	addiu	$s1, $s1, 1					
	addi	$v0, $0, -1					
	jr		$ra					

rtn_sub:

	addiu	$s1, $s1, 1					
	addi	$v0, $0, -2					
	jr $ra					

rtn_mult:
	addiu	$s1, $s1, 1					
	addi	$v0, $0, -3					
	jr $ra
	
rtn_div:

	addiu	$s1, $s1, 1					
	addi	$v0, $0, -4					
	jr $ra
	
rtn_nl:

	addiu	$s1, $s1, 1					
	addi	$v0, $0, -5					
	jr $ra


exit:

	ori $v0, $0, 10					
	syscall