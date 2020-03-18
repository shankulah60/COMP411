.data
	space: .asciiz " "
	newline: .asciiz "\n"
	END: .asciiz "END\n"
	
	buffer: .space 2000 	#More than enough space
	animals: .space 300
	phrases: .space 1200
	
.text
	#Max number of lines to read in = 20 * 2 + 1 = 41
	li $t0, 0				#Loop Counter
	li $s7, 41				#Max number of iterations
	li $t3, 0				#Animal or Phrase (boolean)
	
	la $s0, buffer				#$s0 is buffer pointer
	la $s1, animals				#$s1 is animals pointer
	la $s2, phrases				#s2 is phrases pointer
	
loop_read:
	beq $t0, $s7, loop_read_end
		move $a0, $s0			#Move the pointer into the argument
		li $a1, 60			#Max character limit for either
		li $v0, 8
		syscall				#Reads in a string from user input
		
		#Check if the string == "END\n", go to loop_read_end
		#If false, check if on animal or phrase
		beq $t3, $0, animal
	phrase:
		#Load into phrase array
		sw $s0, 0($s2)			#Store word into phrases array
		addi $s2, $s2, 60		#add the length og the animal name to pointer
		li $t3, 0			#Next, read an animal
	animal:
		sw $s0, 0($s1)			#Store word into animals array
		addi $s1, $s1, 15		#add the length of the animal name to pointer
		li $t3, 1			#Change to read a phrase next
		
		#Done storing, update buffer and continue
		addi $s0, $s0, 60		#Add the max character limit to pointer
		addi $t0, $t0, 1		#Add 1 to the loop counter
		j loop_read
loop_read_end:
		li $v0, 10			#Exit the function nicely
		syscall
		
		
		
			
