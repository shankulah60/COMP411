.data
	newLine: .asciiz "\n"
	buffer:	.space 128
	stack:	.space 128
	
.text

#Set some values in the saved registers
la $s0, newLine
#Reserving $s1 for processing string (later)
li $s2, ' '							#Store the value of a space
li $s3, '+'							#Store the value of a +
li $s4, '-'							#Store the value of a -
li $s5, '*'							#Store the value of a *
li $s6, '/'							#Store the value of a /

read_in:
	li $v0, 8						#code for reading a string
	la $a0, buffer					#Load the pointer as argument
	li $a1, 32						#Max characters per line
	syscall							#Execute the command
	
	#check is string is == "0", then go to exit label
	
	#Variables for processing the line
	li $t0, 0						#int stack_size = 0;
	li $t1, 0						#int value = 0;
	li $t2, 0						#int i = 0;  //Loop Counter
	li $t3, 0						#int mult = 0;
	
	processing_while:
		#Set pointers to save registers
		la $s1, buffer				#Store the pointer to buffer in $s1
		la $s7, stack				#Store the pointer to stack in $s7
		#ONLY REGISTERS $t 4-7 are avaliable from here on!!!
		
		add $t7, $t2, $s1			#Update the memory location (pointer)
		lb $t5, 0($t7)				#Load the byte from the buffer
		beq $t5, $s0, exit_line		#if char == new line, done with line
		#*****REPLACE ONCE LOOP IS IMPLEMENTED!!!!!******
		beq $t5, $0, exit_line			#if char == '0' then done with line (program)
		addi $t2, $t2, 1			#Increment the loop counter
		
		if_space:
			beq $t5, $s2, processing_while	#if char == space, then next char
		
		if_add:
			bne $t5, $s3, if_sub	#if char != + , then go to next if
			addi $sp, $sp, -16		#Make room on stack for temps that need to be saved
			sw $t1, 12($sp)			#Store the value variable
			sw $t2, 8($sp)			#Store the loop counter
			sw $t3, 4($sp)			#Store the mult variable
			sw $ra, 0($sp)			#Store the return address
			
			add $a0, $0, $t0		#Set stack_size as argument to call
			jal add_stack			#Call the function add_stack
			
			add $t0, $0, $v0		#Save the return value
			
			lw $ra, 0($sp)			#Restore the return address
			lw $t3, 4($sp)			#Restore the mult variable
			lw $t2, 8($sp)			#Restore the loop counter
			lw $t1, 12($sp)			#Restore the value
			addi $sp, $sp, 16		#Delete the added stack (memory)
			
			j processing_while		#Done processing char, get next
		
		if_mult:
			bne $t5, $s5, if_div	#if char != * , then go to next if
			addi $sp, $sp , -16		#Make room on stack for temps that need to be saved
			sw $t1, 12($sp)			#Store the value variable
			sw $t2, 8($sp)			#Store the loop counter
			sw $t3, 4($sp)			#Store the mult variable 
			sw $ra, 0($sp)			#Store the return address
			
			add $a0, $0, $t0		#Set stack_size as argument to call
			jal mult_stack			#Call the function mult_stack
			
			add $t0, $0, $v0		#Save the return value
			
			lw $ra, 0($sp)			#Restore the return address
			lw $t3, 4($sp)			#Restore the mult variable
			lw $t2, 8($sp)			#Restore the loop counter
			lw $t3, 12($sp)			#Restore the value
			addi $sp, $sp, 16		#Delete the added stack (memory)
			
			j processing_while		#Done processing char, get next
		
		if_div:
			bne $t5, $s6, if_sub 	#if char != /, then go to next if
			addi $sp, $sp , -16		#Make room on stack for temps that need to be saved
			sw $t1, 12($sp)			#Store the value variable
			sw $t2, 8($sp)			#Store the loop counter
			sw $t3, 4($sp)			#Store the mult variable
			sw $ra, 0($sp)			#Store the return address
			
			add $a0, $0, $t0		#Set stack_size as argument to call
			jal div_stack			#Call the function div_stack
			
			add $t0, $0, $v0		#Save the return value
			
			lw $ra, 0($sp)			#Restore the return address
			lw $t3, 4($sp)			#Restore the mult variable
			lw $t2, 8($sp)			#Restore the loop counter
			lw $t3, 12($sp)			#Restore the value
			addi $sp, $sp, 16		#Delete the added stack (memory)
			
			j processing_while		#Done processing char, get next
			
		if_sub:
			beq $t5, $s4, bound_check_1		#if char == '-', then check the bounds
			j done_char						#Otherwise, put everything together
			
			bound_check_1:
				slti $t4, $t6, 1		#If $t6 > 1 then set to 1
				bgtz $t4, actual_sub	#if the number is >= 0 then do the subtraction
			bound_check_2:
				slti $t4, $t6, 9		#If $t6 < 9 set to 1
				bgtz $t4, done_char		#if the number is >= 9
			actual_sub:
				addi $sp, $sp, -16		#Make room on the stack
				sw $t1, 12($sp)			#Store the value variable
				sw $t2, 8($sp)			#Store the loop counter
				sw $t3, 4($sp)			#Store the mult variable
				sw $ra, 0($sp)			#Store the return address
				
				add $a0, $0, $t0		#Set stack_size as argument to call
				jal sub_stack
				
				add $t0, $0, $v0		#Save the returned value
				
				lw $ra, 0($sp)			#Restore the return address
				lw $t3, 4($sp)			#Restore the mult variable
				lw $t2, 8($sp)			#Restore the loop counter
				lw $t1, 12($sp)			#Restore the value variable
				addi $sp, $sp, 16		#Delete the added stack (memory)
				j processing_while
		done_char:
			li $t1, 0					#Set the value variable to 0
			li $t3, 1					#Set the mult variable to 1
		val_process_loop:
			beq $t5, $s2, calc_val		#if the char != space, then calc the value
			beq $t5, $0, calc_val		#if the char != 0, then calc the value
			beq $t5, $s0, calc_val		#if the char != newline, then calc the value
			
			sub_adjuster:
				bne $t5, $s4, adjustment_1		#if the char != sub, go to adjustment_1
				li $t3, -1						#Subtract 1 from the value
			adjustment_1:
				slti $t4, $t5, 0				#if the char < 0 then set to 1
				bgtz $t4, upgrade_char			#if > 0 then go to upgrade_char
				adjustment_2:
					#Formula: value = (value * 10) + (char - '0') <-- ascii values
					slti $t4, $t5, ':'			#if char < ':' (ascii val) then set to 1 
					beq $t4, $0, upgrade_char	#if the false ,then go to upgrade_char
					li $t9, 10					#Set $t9 to 10
					mult $t9, $t1				#Multiply the value by 10
					mflo $t9					#Save the result to $t9
					li $t8, '0'					#Set $t8 to '0' (ascii val)
					sub $t7, $t5, $t8			#subtract the ascii vals of the char and '0'
					add $t1, $t9, $t7			#add the subtraction result with the value multiplied by 10
			upgrade_char:
				add $t7, $t2, $t8				#Add the loop counter to the pointer 
				lb $t5, 0 ($t7)					#Load the byte as char
				addi $t2, $t2, 1				#Increment the loop counter
				j val_process_loop				#Loop through again
		calc_val:
			mult $t1, $t3						#value = value * mult (variable)
			mflo $t1							#Set the value as the result of the multiplication
			add $t7, $t0, $s7					#Set $t7 as the stack's address
			sb $t1, 0($t7)						#Store the value in the stack
			addi $t0, $t0, 1					#Increment the stack_size variable
			j processing_while
	#afterWhile (printing occurs)
	exit_line:
		addi $t9, $t0, -2						#Subtract 2 from the stack_size variable
		add $t8, $t9, $s7						#Get the address of the byte to be printed
		
		lb $a0, 0($t8)							#Load byte val as the argument to syscall
		addi $v0, $0, 1							#syscall code for printing an integer
		syscall								#Execute
		
		la $a0, newLine							#Print a newline before getting a newline of input
		li $v0, 4
		syscall	
		j read_in								#Do it again
exit:	
		li $v0, 10
		syscall
		
add_stack:
	#Not calling other functions, no stack needed
	la $t0, stack								#Load the address of stack into $t0
	addi $t2, $a0, -2							#Set $t2 to stack_size - 2
	addi $t3, $a0, -1							#Set $t3 to stack_size - 1
	add $t2, $t2, $t0 							#Add the value of the stack to stack_size - 2
	add $t3, $t3, $t0							#Add the value of the stack to stack_size - 1
	lb $t4, 0($t2)								#Load the first number
	lb $t5, 0($t3)								#Load the second number
	add $t1, $t4, $t5							#Add the numbers together
	sb $t1, 0($t2)								#Store the result in stack (array)
	addi $a0, $a0, -1 							#Reduce the stack_size by 1
	move $v0, $a0								#Return the updated stack size
	jr $ra										#Go back to function call

mult_stack:
	#Not calling other functions, no stack needed
	la $t0, stack								#Load the address of stack into $t0
	addi $t2, $a0, -2							#Set $t2 to stack_size - 2
	addi $t3, $a0, -1							#Set $t3 to stack_size - 1
	add $t2, $t2, $t0 							#Add the value of the stack to stack_size - 2
	add $t3, $t3, $t0							#Add the value of the stack to stack_size - 1
	lb $t4, 0($t2)								#Load the first number
	lb $t5, 0($t3)								#Load the second number
	mult $t4, $t5								#Multiply the two numbers
	mflo $t1									#Store the result (temp.) in $t1
	sb $t1, 0($t2)								#Store the result in stack (array)
	addi $a0, $a0, -1 							#Reduce the stack_size by 1
	move $v0, $a0								#Return the updated stack size
	jr $ra										#Go back to function call
	
div_stack:
	#Not calling other functions, no stack needed
	la $t0, stack								#Load the address of stack into $t0
	addi $t2, $a0, -2							#Set $t2 to stack_size - 2
	addi $t3, $a0, -1							#Set $t3 to stack_size - 1
	add $t2, $t2, $t0 							#Add the value of the stack to stack_size - 2
	add $t3, $t3, $t0							#Add the value of the stack to stack_size - 1
	lb $t4, 0($t2)								#Load the first number
	lb $t5, 0($t3)								#Load the second number
	#add $t1, $t4, $t5							#Add the numbers together
	div $t4, $t5								#Divide $t4 by $t5
	mflo $t1									#Store the result in #t1
	sb $t1, 0($t2)								#Store the result  ($t1) in stack (array)
	addi $a0, $a0, -1 							#Reduce the stack_size by 1
	move $v0, $a0								#Return the updated stack size
	jr $ra										#Go back to function call
	
sub_stack:
	#Not calling other functions, no stack needed
	la $t0, stack								#Load the address of stack into $t0
	addi $t2, $a0, -2							#Set $t2 to stack_size - 2
	addi $t3, $a0, -1							#Set $t3 to stack_size - 1
	add $t2, $t2, $t0 							#Add the value of the stack to stack_size - 2
	add $t3, $t3, $t0							#Add the value of the stack to stack_size - 1
	lb $t4, 0($t2)								#Load the first number
	lb $t5, 0($t3)								#Load the second number
	sub $t1, $t4, $t5							#Add the numbers together
	sb $t1, 0($t2)								#Store the result in stack (array)
	addi $a0, $a0, -1 							#Reduce the stack_size by 1
	move $v0, $a0								#Return the updated stack size
	jr $ra										#Go back to function call	
