# Starter file for ex1.asm

.data
	#...
	newline: .asciiz "\n"
        
.text 

main:
	#Getting the values
in_loop:
	addi $v0, $0, 5
	syscall
	add $a0, $0, $v0			#n saved to $a0
	
	beq $a0, $0, end			#if (n == 0) {Terminate the program}
	
	addi $v0, $0, 5
	syscall
	add $a1, $0, $v0			#k saved to $a1
	
	jal NchooseK				#Call the function
	
	add $a0, $0, $v0			#Get the return value
	addi $v0, $0, 1				#Code for printing an integer
	syscall					#Print the result
	
	add $v0, $0, 4				#Printing a string
	la $a0, newline				#Load the address of newline
	syscall					#Print it
	
	jal in_loop				#Go to the next iteration of the loop
	
end: 
	ori   $v0, $0, 10     # system call 10 for exit
	syscall               # we are out of here.



NchooseK: 
   #Setting up stack
     addiu $sp, $sp,-16				#Stack View
     sw $ra, 0($sp)     		#	$ra		<-- Stack Pointer ($sp)
     sw $s0, 4($sp)     		#	$s0
     sw $s1, 8($sp)     		#	$s1
     sw $s2, 12($sp)    		#	$s2
	 
	#Branches
    beq    $a1,$0,return_base_case
    beq    $a0,$a1,return_base_case
		#Following the formula: C(n,k) = C(n-1,k) + C(n-1,k-1)
		addi    $a0,$a0,-1  		# n - 1;   
		add $s0, $0, $a0		#Move $a0 into $s0
		add $s1, $0, $a1		#Move $a1 into $s1
		jal    NchooseK			#Recursive Call
		#Second part of formula
		add $s2, $0, $v0		#Move $v0 into $s2
		add $a0, $0, $s0		#Move $s0 into $a0
		addi    $a1,$s1,-1		# k - 1;
		jal    NchooseK			#Recursive Call
		add    $v0,$v0,$s2		#Sum the results into $v0
		j    return				#Go to return of function

return_base_case:
    addi    $v0,$0,1
return:       			#For the function (NchooseK)
     lw $s2, 12($sp)    	#Restoring $s2 from stack
     lw $s1, 8($sp)    	#Restoring $s1 from stack
     lw $s0, 4($sp)     	#Restoring $s0 from stack
     lw $ra, 0($sp)     	#Restoring $ra (return address) from stack
     addiu $sp, $sp, 16 	#Deleting the stack
     jr $ra		 	#Go back to function call
