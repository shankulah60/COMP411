.eqv MAX_STRING_SIZE 32
.data
	myStack: .space 80
	inLine: .space MAX_STRING_SIZE
	
.text

main:
	la $a0, inLine				#Load the address of inLine into $a0
	li $v0, 8				#syscall code for read string
	addi $a1, $0, MAX_STRING_SIZE		#Load max string size as $a1
	syscall
	
	lbu $t1, inLine($0)			#Load the first byte of inLine
	addi $t0, $0, '0'			#Add the terminating character
	beq $t0, $t1, exit			#if(char == terminating_char) {terminate program}
	
	add $s0, $0, $0				#Set $s0 to 0
	add $s1, $0, $0				#Set $s0 to 0

breaking:

	jal get					#Call the get function
	slt $t0, $v0, $0			#Set $t0 to 1 if $v0 is < 0
	bne $t0, $0, operator			#If ^ = true, then go to operator (Found an operator)
	
number:

	sw $v0, myStack($s0)			#Store the number on the calculation stack (myStack)
	addiu $s0, $s0, 4			#Remove the space on the stack
	j breaking				#Make sure not an operator

operator:
	
	addi $t0, $0, -1			#For comparison
	beq $t0, $v0, addition			#Found a plus sign
	addi $t0, $0, -2			#For comparison
	beq $t0, $v0, subtraction		#Found a subtraction sign
	addi $t0, $0, -3			#For comparison
	beq $t0, $v0, multiplication		#Found a multiplication sign
	addi $t0, $0, -4			#For comparison
	beq $t0, $v0, division			#Found a division sign
	addi $t0, $0, -5			#For comparison
	beq $t0, $v0, new_line			#Found a new line (\n)

addition:

	addiu $s0, $s0, -4 			#Add space to myStack (calcultion stack)
	lw $t2, myStack($s0)			#Load the number in myStack into $s2
	addiu $s0, $s0, -4			#Decrement myStack by 1, to represent the adder that was loaded
	lw $t1, myStack($s0)			#Load the next number in the stack (to be added)
	add $t0, $t1, $t2			#Add the two numbers
	sw $t0, myStack($s0)			#Store the result back onto myStack for other calculations or to be written
	addiu $s0, $s0, 4			#Delete the added stack space on myStack
	j breaking				#Go to breaking function
	
subtraction:

	addiu $s0, $s0, -4 			#Add space to myStack (calcultion stack)
	lw $t2, myStack($s0)			#Load the number in myStack into $s2
	addiu $s0, $s0, -4			#Decrement myStack by 1, to represent the number that was loaded
	lw $t1, myStack($s0)			#Load the next number in the stack (to be subtracted)
	sub $t0, $t1, $t2			#Subtract the two numbers
	sw $t0, myStack($s0)			#Store the result back onto myStack for other calculations or to be written
	addiu $s0, $s0, 4			#Delete the added stack space on myStack
	j breaking	
	
multiplication:

	addiu $s0, $s0, -4 			#Add space to myStack (calcultion stack)
	lw $t2, myStack($s0)			#Load the number in myStack into $s2
	addiu $s0, $s0, -4			#Decrement myStack by 1, to represent the factor that was loaded
	lw $t1, myStack($s0)			#Load the next number in the stack (to be multiplied)
	mult $t1, $t2				#Multiply the two numbers
	mflo $t0				#Store the result in $t0
	sw $t0, myStack($s0)			#Store the product back onto myStack for other calculations or to be written
	addiu $s0, $s0, 4			#Delete the added stack space on myStack
	j breaking	
	
division:
	
	addiu $s0, $s0, -4 			#Add space to myStack (calcultion stack)
	lw $t2, myStack($s0)			#Load the number in myStack into $s2
	addiu $s0, $s0, -4			#Decrement myStack by 1, to represent the number that was loaded
	lw $t1, myStack($s0)			#Load the next number in the stack (to be divided)
	div $t1, $t2				#Divide the two numbers
	mflo $t0				#Store the result in $t0
	sw $t0, myStack($s0)			#Store the product back onto myStack for other calculations or to be written
	addiu $s0, $s0, 4			#Delete the added stack space on myStack
	j breaking	
	
new_line:

	addiu $s0, $s0, -4			#Add space to myStack (calculation stack)
	lw $a0, myStack($s0)			#Load the number in myStack
	ori $v0, $0, 1				#ori 1 with 0 and store the result in $v0
	syscall
	addi $a0, $0, '\n'			#Load the newline character
	ori $v0, $0, 11				#Checking for vertical tab (newline) ascii
	syscall
	
end_breaking:
	
	j main					#Return to main, no value to return

get:
	lbu $t1, inLine($s1)			#Load the char from the inLine
	addi $t0, $0, ' ' 			#For comparison
	bne $t0, $t1, start			#if(char != ' ') {start}
	
start:
	
	lbu $t1, inLine($s1)			#Load the char
	#Checking for an operator, then returning value
	addi $t0, $0, '+'			#For comparison
	beq $t0, $t1, rtn_add			#Found a plus sign, return the added result
	addi $t0, $0, '-'			#For comparison
	beq $t0, $t1, rtn_sub			#Found a subtraction sign, retun the subtracted result
	addi $t0, $0, '*'			#For comparison
	beq $t0, $t1, rtn_mult			#Found a multiplication sign, reutn the product result
	addi $t0, $0, '/'			#For comparison
	beq $t0, $t1, rtn_div			#Found a division sign, return the result
	addi $t0, $0, '\n'			#For comparison
	beq $t0, $t1, rtn_nl			#Found a newline, return the end of line result
	
add $t2, $0, $0					#int temp = 0;
number_loop:

	lbu $t1, inLine($s1)			#Load the char (int)
	
	addiu $t3, $0, '0'			#For comparison
	addiu $t3, $t3, -1			#Subtract 1 form the ascii value of '0'
	slt $t0, $t3, $t1			#Set true if $t3 < $t1
	beq $t0, $0, return_none		#Less than 0, not supported by program
	addiu $t3, $0, '9'			#For comparison
	addiu $t3, $t3, 1			#Add 1 to the ascii value of '9'
	slt $t0, $t1, $t3			#Set true if $t1 is less than $t3
	beq $t0, $0, return_none		#Higher than 9, not supported by program
	addi $t0, $0, 10			#Load 10 into $t0
	mul $t2, $t0, $t2			#Multiply $t0 and $t2, store in $t2
	addi $t0, $0, '0'			#Load '0' ascii value into $t0
	subu $t0, $t1, $t0			#Subtract the value of '0' from $t1
	add $t2, $t2, $t0			#Increment the value of $t2 by $t0
	addiu $s1, $s1, 1			#Increment the character counter
	j number_loop
	
return_none:
	
	add $v0, $0, $t2			#Return the value of $t2
	jr $ra

rtn_add:
	
	addiu $s1, $s1, 1			#Increment the character counter by 1
	addi $v0, $0, -1 			#Return negative one
	jr $ra					#Return to function call
	
rtn_sub:
	
	addiu $s1, $s1, 1			#Increment the character counter by 1
	addi $v0, $0, -2			#Return negative two 
	jr $ra					#Return to function call
	
					
rtn_mult:
	
	addiu $s1, $s1, 1			#Increment the character counter by 1
	addi $v0, $0, -3			#Return negative three 
	jr $ra					#Return to function call
		
rtn_div:
	addiu $s1, $s1, 1			#Increment the character counter by 1
	addi $v0, $0, -4 			#Return negative four
	jr $ra					#Return to function call
	
rtn_nl:
	
	addiu $s1, $s1, 1			#Increment the character counter by 1
	addi $v0, $0, -5			#Return negative five 
	jr $ra					#Return to the function call
	
exit:
	
	li $v0, 10				#Exit the program nicely
	syscall	
					