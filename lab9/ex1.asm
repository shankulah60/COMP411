.data
	#Store variables here
	newline: .asciiz "\n"
	space: .asciiz " "
.text
	#Code goes here

main:
	#Read in the n value
	addi $v0, $0, 5		#sys call code for read in integer
	syscall
	add $t0, $0, $v0	#Move read value (n) into $a0 (agrument1)
	
	#Dynamic memory allocation for array
	addi $s1, $0, 4		#Memory space increment
	mult $t0, $s1		#Calculating memory space needed
	mflo $a0
	
	addi $v0, $0, 9		#syscall code for sbrk
	syscall
	add $s0, $0, $v0	#Save the address of the array into $s0
	
	add $a0, $0, $t0	#Move n into the argument register
	add $s2, $0, $t0	#Save a copy of n
	
	add $a1, $0, $0		#Send argument i = 0;
	
	#Call the function
	jal binary
	
	j exit			#Exit/terminate the program
	
binary:
	#Function (Requires a n and an i value as argunments)
	#Setup stack
	addiu $sp, $sp, -12		#Adjust the stack pointer for 2 values to be stored
	sw $ra, 0($sp)			# $ra		<-- Stack pointer ($sp)
	sw $a0, 4($sp)			# n	
	sw $a1, 8($sp)			# i
	
	if:
		sub $t3, $a0, $a1	#Subtract n from i
		bne $t3, $0, recursive	#if n - i does not equal 0, then go to the recursive label
		#bge $a0, $a1, recursive #if (i >= n) {exit}
			jal printer	#Print what has been found
			j binary_exit	#Exit the function
		recursive:
			mult $a1, $s1		#i * 4 (Gets needed memory increment to access array value)
			mflo $t4		#Store the result into $t4
			#add $t5, $s0, $t4	#Add the memory increment to the array address
			
			#add $t5, $0, $0	#Store 0 into $t5
			addu $t5, $s0, $t4	#array address + memory offset into $t5
			sw $0, 0($t5)		#Store 0 into the array's element (calculated above)
			
			addi $a1, $a1, 1	# i += 1;
			jal binary		#call binary (recursive call)
			
			mult $a1, $s1		#i * 4 (Gets needed memory increment to access array value)
			mflo $t4		#Store the result into $t4
			
			add $s5, $0, 1 		#Store 1 into $t5
			add $t5, $s0, $t4	#array address + memory offset into $t5
			sw $s5, 0($t5)		#Store 1 into the array's element (calculated above)
			
			addi $a1, $a1, 1	#i += 1;
			jal binary		#call binary (recursive call)
	end_if:	
	
	binary_exit:
		#Restore values from stack
		lw $a1, 8($sp)		#Load i from stack
		#lw $a0, 4($sp)		#Load n from stack
		addi $a1, $a1, -1
		lw $ra, 0($sp)		#Load $ra from stack
		addi $sp, $sp, 12	#Get rid of the stack (delete it)
		jr $ra			#Return to function call
	
	
	
printer:
	#Prints values from array
	#Setup the stack
	addi $sp, $sp, -12		#Make space on stack for 3 values
	sw $ra, 0($sp)			# $ra 		<--- Stack Pointer ($sp)
	sw $a0, 4($sp)			# n (Not needed)
	sw $a1, 8($sp)			# i
	
	add $t6, $0, $0			#int j = 0; (loop counter)
	loop:
		beq $s2, $t6, loop_exit	#if( n == j) {exit_loop}
			mult $t6, $s1		#Calculate memory offset, j * 4
			mflo $t4		#Storing offset into $t4
			add $t5, $s0, $t4	#array address + memory offset
			lw $t7, 0($t5)		#Load integer from array at calculated index (memory index)
			
			add $v0, $0, 1		#Print an integer
			add $a0, $0, $t7	#Move the integer from $t7 to $a0
			syscall 		#Print the integer
			
			#add $v0, $0, 4		#syscall code for printing a string
			#la $a0, space		#Load the address of the space
			#syscall			#Print the space
			
			addi $t6, $t6, 1	# j += 1;
			
			j loop			#Do it again		
	
	loop_exit:
		#Newlinw
		add $v0, $0, 4	 #syscall code for printing a string
		la $a0, newline	 #Load address of newline
		syscall		 #Print the newline
		
		lw $a1, 8($sp)	 	#Load $a1 from stack
		lw $a0, 4($sp)	 	#Load $a0 from stack
		lw $ra, 0($sp)	 	#Load $ra from stack
		addi $sp, $sp, 12 	#Delete stack
		jr $ra		 	#Return to function call

	
exit:
	ori $v0, $0, 10		#sys call code for exit/terminate program
	syscall
