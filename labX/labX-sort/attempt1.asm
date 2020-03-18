.data
	buffer: .space 30
	space: .ascii " "
	end: .asciiz "0"
	newLine: .asciiz "\n"
	line: .asciiz "GOT LINE\n"
	
.text
	li $s2, ' '							#Store the value of a space
	li $s3, '+'							#Store the value of a +
	li $s4, '-'							#Store the value of a -
	li $s5, '*'							#Store the value of a *
	li $s6, '/'							#Store the value of a /
	add $t0, $0, $0				#int i  = 0;
	addi $t1, $0, 3				#3 iterations max
loop:
	beq $t0, $t1, end_loop
	
	read_in:
	
		#jal clean
	
		la $a0, buffer
		li $v0, 8
		addi $a1, $0, 30
		syscall
	
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
	
		la $a0, line
		li $v0, 4
		syscall
		
		addi $t0, $t0, 1
	
end_loop:
	j exit
	
clean:
		add $t0, $0, $0								#int i = 0;
		addi $t1, $0, 30							#Max characters in buffer
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
	
	
checker:
	#Assumes the input will look like: "0\n"
	la $t0, buffer				#Holds the line of user input
	la $t1, newLine				#New line (\n)
	la $t2, end				#Holds '0'
	bne $t0, $t2, end_check			#if(string[0] != '0') {NOT_EXIT_LINE}
	addi $t0, $t0, 2			#Add 1 to the pointer, get the next character from user input
	beq $t0, $t1, exit			#if(string[1] == '\n') {TERMINATE_PROGRAM //Found exit string	}
	end_check:
		jr $ra
	
exit: 
	li $v0, 10
	syscall	