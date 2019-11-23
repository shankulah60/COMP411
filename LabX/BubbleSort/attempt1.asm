.data
	newLine: .asciiz "\n"
.text:

	li $v0, 5							#syscall code for read an integer
	syscall								#Execute
	move $s0, $v0						#Store the number of strings (N) in $s0
	
	#Calculate the number of bytes required to read in strings
	addi $t0, $0, 100					#Each string has a max of 100 characters
	mult $t0, $s0						#Number of strings * length of each string
	mflo $a0							#Store the result as the 1st argument
	
	#Allocate memory (of calculated size)
	li $v0, 9							#syscall code for sbrk
	syscall
	
	#Set some variables for read_loop
	add $s1, $0, $v0					#Save the address of the allocated memory
	add $t1, $0, $s1					#Make copy of the pointer to the location
	add $t0, $0, $0						#int i  = 0; (loop counter)
	
	
read_loop:
	beq $t0, $s0, read_loop_exit
	
	move $a0, $t1						#Load the memory location into the 1st argument
	li $v0, 8							#syscall code for read a string
	addi $a1, $0, 100					#Max number of characters
	syscall								#Execute
	
	addi $t1, $t1, 100					#Add 100 to the memory location of allocated memory
	addi $t0, $t0, 1					#Add 1 to the loop counter
	j read_loop
	
read_loop_exit:
	li $v0, 10
	syscall
