.data
	buffer: .space 2000
	type1: .space 2000
	type2: .space 2000
	
.text
	#TESTING NO. OF ITERATIONS
	li $t0, 0			#int i  = 0;
	li $t2, 3			#Max iterations = 3
	la $s0, buffer			#Load address of buffer
	la $s1, type1			#Load address of type1
	la $s2, type2			#Load address of type2
	
	addu $t3, $0, $s0		#Set $t3 to address of buffer
	addu $t4, $0, $s1		#Set $t4 to address of type1
	addu $t5, $0, $s2		#Set $t5 to address of type2
	addi $t6, $0, 1			#TEST
while_read: 
	beq $t0, $t2, exit		#if i == max_iterations {exit}
	
	addu $a0, $0, $t3		#Reading string from stdin
	li $v0, 8
	addi $a1, $0 ,30
	syscall
	
	
	#Some condition is met, add to type1 
	
	#sw $t3, 0($t4)			#Storing the string into type1	
	bne $t0, $t6, next
	addu $s5, $0, $t3		#Holds the address of the first element
next:		
	addu $t4, $t4, 30		#Increment type1 pointer by string length (30)
	addu $t3, $t3, 30		#Increment buffer pointer by string length (30)
			
	addi $t0, $t0, 1		# i += 1;
	j while_read
	
exit:
	#Eventually, Print strings from type1
	move $a0, $s5			#Load the first element
	li $v0, 4
	syscall
	
	addi $t3, $t3, -30
	move $a0, $t3
	li $v0, 4
	syscall
	
	
	
	li $v0, 10
	syscall	
