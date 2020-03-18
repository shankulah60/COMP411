.data
	newLine: .asciiz "\n"
	space: .asciiz " "
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
	
	#jal clear						#Clear the entire buffer array
	
	li $v0, 8						#code for reading a string
	la $a0, buffer					#Load the pointer as argument
	li $a1, 32						#Max characters per line
	syscall							#Execute the command
	
	
	#Variables for processing the line
	li $t0, 0						#int stack_size = 0;
	li $t1, 0						#int value = 0;
	li $t2, 0						#int i = 0;  //Loop Counter
	li $t3, 0						#int mult = 0;
	
	
	#All temp registers are in use, back them up and call the function, then restore when back from function
		#add $a0, $0, $t7			#Load the pointer of line into 
		la $a0, buffer
		addi $sp, $sp, -36			#Make room for all temp. registers on the stack
		sw $t0, 32($sp)				#Store $t0
		sw $t1, 28($sp)				#Store $t1
		sw $t2, 24($sp)				#Store $t2
		sw $t3, 20($sp)				#Store $t3
		sw $t4, 16($sp)				#Store $t4
		sw $t5, 12($sp)				#Store $t5
		sw $t6, 8($sp)				#Store $t6
		sw $t7, 4($sp)				#Store $t7
		sw $ra, 0($sp)				#Store $ra
		
		jal checker
		
		lw $t0, 32($sp)				#Restore $t0
		lw $t1, 28($sp)				#Restore $t1
		lw $t2, 24($sp)				#Restore $t2
		lw $t3, 20($sp)				#Restore $t3
		lw $t4, 16($sp)				#Restore $t4
		lw $t5, 12($sp)				#Restore $t5
		lw $t6, 8($sp)				#Restore $t6
		lw $t7, 4($sp)				#Restore $t7
		lw $ra, 0($sp)				#Restore $ra
		addi $sp, $sp, 16			#Delete the added stack
	
	processing_while:
		#Set pointers to save registers
		la $s1, buffer				#Store the pointer to buffer in $s1
		la $s7, stack				#Store the pointer to stack in $s7
		#ONLY REGISTERS $t 4-7 are avaliable from here on!!!
		
		add $t7, $t2, $s1			#Update the memory location (pointer)
		lb $t5, 0($t7)				#Load the byte from the buffer
		beq $t5, $s0, exit_line		#if char == new line, done with line
		#*****REPLACE ONCE LOOP IS IMPLEMENTED!!!!!******
		#Load $t7 (mem. address (pointer)) as $a0, call checker function
		
		
		
		beq $t5, $0, exit		#if char == '0' then done with line (program)
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
		syscall									#Execute
		la $a0, newLine							#Load the newline as the first argument
		li $v0, 4								#syscall code for printing a string
		syscall									#Execute
		
		
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

	
checker:
	add $t0, $0, $0								#int i  = 0; (loop counter)
	addi $t1, $0, 128							#Number of char's in buffer 
	la $t2, 0($a0)							#The memory location of the line
	add $t4, $0, $0								#int operator = 0;
	
	#buffer is composed of all strings, so numbers will be represented by chars (1 byte)
	chk_loop:
		beq $t0, $t1, end_chk_loop				#if(i == 128) {end_loop}
		
		lb $t3, 0($t2)								#Load the character into $t3
		
		beq $t3, $s3, op_found						#if (char == '+') {exit_function}
		beq $t3, $s5, op_found						#if (char == '*') {exit_function}
		beq $t3, $s6, op_found						#if (char == '/') {exit_function}
		beq $t3, $s4, op_found						#if (char == '-') {exit_function}
		
		addi $t2, $t2, 1							#Increment the memory location
		addi $t0, $t0, 1							#Increment the loop counter (i)
		
		j chk_loop									#Not this char, look at next
		
	op_found:
			addi $t4, $0, 1							#operator = 1;
			j end_chk_loop							#break;  (Found an operator, not a program exit line, exit the function)
		
	end_chk_loop:
		#if operator...
		addi $t5, $0, 1								#Load the integer 1 into $t5
		beq $t4, $0, exit 									#if (operator == 0) {terminate_program}
		jr $ra										#else, return to the function call
	
clear:
		add $t0, $0, $0								#int i = 0;
		addi $t1, $0, 128							#Max characters in buffer
		la $t2, buffer								#Load the address of buffer into $t2
		la $t3, space								#Load the address of the space character into $t3
		
		clean_loop:
			beq $t0, $t1, exit_clean_loop			#if (i == 128) {exit_loop}
			sb $t3, 0($t2)							#Store a space at the index of buffer
			addi $t2, $t2, 1						#Increment the memory location of buffer
			addi $t0, $t0, 1						#Increment the loop counter
			j clean_loop							#Loop (do it again)
		exit_clean_loop:
			jr $ra