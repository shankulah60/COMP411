.data
	buffer: .space 2400
	type1: .space 300
	type2: .space 1200
	
.text:
	
	#Load some preliminary values into registers
	la $s0, buffer
	la $s1, type1
	la $s2, type2
	move $t0, $s0
	move $t1, $s1
	move $t2, $s2
	
	#TEMP VAIRIABLES FOR TESTING
	add $t3, $0, $0				#int i  = 0;
	addi $t4, $0, 2				#Max iterations

loop:	
	bge $t3, $t4, end_loop		#if( i >= 2) {end_loop}
	
	move $a0, $t0				#current buffer address
	li $v0, 8
	addi $a1, $0, 60			#60 character long string
	syscall
	
	#Potential: Call a function call checker, have it call strcmp
		#Send the address as the argument, load three bytes and check if they are equal to end.
	
		#if Flag == 0 then add to type1
		#else add to type2
	
	sw $t0, 0($t1)				#Store the address of the string in the type1 array
	addi $t1, $0, 4				#Increment the type1 array by 4 bytes of data
	
	addi $t0, $t0, 60			#Get to the next open space in buffer
	addi $t3, $t3, 1				#Increment the loop counter
	j loop
	
end_loop:
	
	
	#Print the strings
	add $t3, $0, $0				#i  = 0;
	move $t0, $s0				#buffer
	move $t1, $s1				#type1
	move $t2, $s2				#type2

print_loop:
		bge $t3, $t4, exit		#if( i >= 2) {exit}
			#print type1
			move $a0, $t1		#current value of type1 pointer
			li $v0, 4
			syscall
			
			addi $t1, $0, 4		#Increment to the start of the next pointer
			addi $t3, $0, 1		#Increment the loop counter
			j print_loop
			
exit:
	#Exit the program nicely
	li $v0, 10
	syscall
