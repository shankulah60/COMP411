.data
	space: .asciiz " "
	newline:  .asciiz "\n"
	END: .asciiz "END\n"
	
	#Arrays
	animals: .word 80
	phrases: .word 80
	
	#Single words
	animal: .word 15
	phrase: .word 60
	
.text

la $s0, animals					#Load the address of animals array into #$s0
la $s1, phrases					#Load the address of phrases array into #$s1
add $t6, $0, $s0				#Copy address of animlas into $t6
add $t7, $0, $s1				#Copy address of phrases into $t7

main:
		#Getting user input

		addi $v0, $0, 8			#syscall code for read user input
		#la $a0, animal			#Where to store read string (animal)
		addi $a0, $0, 15		#Max character allowance
		syscall				#Execute
		
		#la $a0, animal
		sw $a0, 0($t6)			#Load the address of animal into animals array
		addi $t6, $t6, 4		#Increment index of array for next element
		
		la $a0, END			#Load the address of END string
		la $a1, animal			#Load the address of the animal string
		jal strcmp			#Check if the strings are equal using strcmp function

		beq $v0, $0, end_main		#if read animal equals END, then stop reading in values
		
		addi $v0, $0, 8			#if syscall code for read user input
		la $a0, phrase			#Where to store read string (phrase)
		addi $a1, $0, 60		#Max character allowance
		syscall
		
		la $a0, phrase			
		sw $a0, 0($t7)			#Load the address of phrase into phrases array
		addi $t7, $t7, 4	 	#Increment index of array for next element
		

		j main				#Done reading one set loop back to test conditional
		
end_main:
	
	#Calculate the number of animals
	sub $t0, $t7, $s1			#Calculate the number 
	addi $t1, $0, 4				
	div $t2, $t0, $t1			#Divide the difference by 4 to get the number of elements
	mflo $s2				#$s2 Holds the number of elements read in
	
	#TEMP REMOVE AFTER TESTING
	add $a0, $0, $t6			#Send the number of elements
	add $a1, $0, $t7
	jal printer
	
	li $v0, 10				#Tells the system this is the end of the function
	syscall					#Execute
printer:
	add $t0, $0, $s0			
			
	print_loop:
		beq $t0, $t6, exit_printer	#if printer == max read then done printing, exit
		addi $v0, $0, 4			#Syscall code for printing a string
		lw $a0, 0($t0)
		#add $a0, $0, $t0			#Load address of array with index
		syscall
		
		addi $t0, $0, 4			#increment the array index
		j print_loop
exit_printer:
	jr $ra	
		
	
strcmp:
	add $t0,$0,$0				#int i = 0;
	add $t1,$0,$a0				#Address of string1
	add $t2,$0,$a1				#Address of string2
	loop:
		lb $t3($t1)			#Load a byte from string1
		lb $t4($t2)			#Load a byte from string2
		beqz $t3,check_str2 		#Reached end of string1, check if at end of string2
		beqz $t4,no_match		#No match, end function
		slt $t5,$t3,$t4  		#Comparing the bytes
		bnez $t5,no_match		#No match, end function
		addi $t1,$t1,1  		#Check the next byte of string1 (char)
		addi $t2,$t2,1			#Check the next byte of string2 (char)
		j loop				

	no_match: 
		addi $v0,$0,1			#Return the value 1 to indicate not equal
		j endfunction			#Go to function exit
	check_str2:
		bnez $t4,no_match		#if the value is not 0, then the strings are not equal
			add $v0,$0,$0		#Return the value 0 to indicate not equal

endfunction:
	jr $ra					#Return to the function call
