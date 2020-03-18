.data
	buffer: .space 40
	mem: .space 8
	bad: .asciiz "String2 < String1\n"
	good: .asciiz "No Change\n"
	
.text
	
	#Load the addresses 
	#Read in the strings
	#Call the function
	#Print the result 		<-- Gets strcmp working
	
	la $s0, buffer
	la $s1, mem
	
	la $t1, 0($s0)				#Copy of buffer addresses
	la $t2, 0($s1)				#Copy of mem address
	
	add $t0, $0, $0				#Element counter
	
	la $a0, 0($t1)				#Buffer address loaded
	li $v0, 8
	addi $a1, $0, 20
	syscall
	
	sw $t1, 0($t2)				#Store pointer into mem. location of mem array
	addu $t2, $t2, 4
	addu $t1, $t1, 20
	addi $t0, $t0, 1
	
	la $a0, 0($t1)				#Buffer address loaded
	li $v0, 8
	addi $a1, $0, 20
	syscall
	
	sw $t1, 0($t2)				#Store pointer into mem. location of mem array
	addu $t2, $t2, 4
	addu $t1, $t1, 20
	addi $t0, $t0, 1
	
	#Load the pointers that are going to be compared (strings)
	la $a0, 0($s1)
	la $a1, 4($s1)
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
		
		jal strcmp
		
		lw $t0, 32($sp)				#Restore $t0
		lw $t1, 28($sp)				#Restore $t1
		lw $t2, 24($sp)				#Restore $t2
		lw $t3, 20($sp)				#Restore $t3
		lw $t4, 16($sp)				#Restore $t4
		lw $t5, 12($sp)				#Restore $t5
		lw $t6, 8($sp)				#Restore $t6
		lw $t7, 4($sp)				#Restore $t7
		lw $ra, 0($sp)				#Restore $ra
		addi $sp, $sp, 36			#Delete the added stack
	

		bne $v0, $0, print			#if the returned value is 1, then needs to swap order of strings
		
		la $a0, 0($t2)				#Address of strings
		move $a1, $0				#Sending the 0th element
		jal swap
		
print:		la $a0, 0($t2)
		li $v0, 4
		syscall
		
		la $a0, 4($t2)
		li $v0, 4
		syscall
	
		li $v0, 10
		syscall
	
	#Write a swap function:
	#swap(start of array, element number)
	#{
	#	//Preform a swap like before (example online)
	#}
	
	
	
strcmp:
	add $t0, $0, $0			#int i  = 0;
	addi $t1, $0, 20		#Max each string
	la $t6, 0($a0)			#Copy of $a0, for incrementation
	la $t7, 0($a1)			#Copy of $a1 for incrementation
	addi $s3, $0, 1			#For comparisons (later)
	cmp_loop:
		beq $t0, $t1, done
		lb $t3, 0($t6)		#First char of string1
		lb $t4, 0($t7)		#First char of string2
		beq $t3, $t4, next_char	#if(char1 ==  char2) {next_char}
		slt $t5, $t4, $t3	#if (char2 < char1) {$t5 = 1;}
		j done
	next_char:
		addi $t6, $t6, 1	#Next char of string1
		addi $t7, $t7, 1	#Next char of string2
		addi $t0, $t0, 1	#i += 1;
		j cmp_loop
	done:
		add $v0, $0, $t5	#retrns 1 if string2 < string1 and 0 if it is already in right order
		jr $ra
		

swap:
	sll $t1, $a1, 2			#Multiply the index by 4
	add $t1, $t1, $a0		#Add the offest to the memory location
	lw $t0, 0($t1)			#Load the address of 
	lw $t2, 4($t1)
	sw $t2, 0($t1)
	sw $t0, 4($t1)
	jr $ra
	
