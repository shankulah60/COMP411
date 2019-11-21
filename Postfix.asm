.data
	newLine: .asciiz "\n"
	buffer:	.space 128
	stack:	.space 128
	
.text

#Set some values in the saved registers
li $s0, newLine
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
		beq $t5, $0, exit_line		#if char == '0' then done with line (program)
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
			addi $s-, $sp , -16		#Make room on stack for temps that need to be saved
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
			addi $s-, $sp , -16		#Make room on stack for temps that need to be saved
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
			
