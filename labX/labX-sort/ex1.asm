#Declaring some constants
.eqv MAX_STRING_SIZE 100
.eqv ARRAY_STRINGS_SIZE 10000 # 100 * 100 # 100 strings have size 100

.data
array_strings: .space ARRAY_STRINGS_SIZE
N: .word 0

.text

main:

	li $v0,5												#syscall code for read integer
	syscall			
	la $a0,N												#Get address of N
	sw $v0,($a0)											#Store the number of strings into N
	
	move $s0,$v0 											#Save value of N into $s0
	li $s1,0 												#int i = 0;
	j main_for_loop_check									#Check conditional for main (read)
	
main_for_loop:

	li $v0,8												#syscall code for read a string
	la $a0,array_strings									#Set pointer to array_strings as first argument
	mulu $t0,$s1,100										#i * 100
	addu $a0,$a0,$t0 										# $a0 = address of array_strings[i]
	li $a1,MAX_STRING_SIZE									#Set max char amount as 2nd argument
	syscall
	addi $s1,$s1,1 # i++									i += 1;
	
main_for_loop_check:	

	blt $s1,$s0,main_for_loop								#if($s1 < number of strings to be read) {main_for_loop}
	
	#Sorting the strings 
	la $a0,array_strings									#Load the address of array_strings into $a0
	la $a1,N												#Load the number of strings memory location into $a1
	lw $a1,($a1)											#Load the number of strings into $a1
	jal string_sort											#Call string_sort function
	
	#Printing the strings
	la $a0,array_strings									#Load the address of array_strings
	la $a1,N												#Load the address of the number of strings memory location
	lw $a1,($a1)											#Load the number of strings
	jal print_strings										#Call the print_stirngs function
	
	li $v0,10												#Exit the program nicely
	syscall
	
print_strings:
				#Assumes $a0 = address of array_strings, $a1 = number of strings (value)
	addi $sp, $sp, -8										#Make room in the stack
	sw $ra,($sp) 											#Store $ra									
	sw $s0,4($sp) 											#Store $s0
	li $v0,4 												#syscall code for printing a string
	move $s0,$a0 											#save the value of $a0 into $s0
	li $t0,0												#int i = 0; (counter)
	j print_strings_loop_check								#Call the print_string_loop_check function
	
print_strings_loop:
	move $a0,$s0 											#array_strings[i]
	syscall
	addiu $s0,$s0,100 										#Increment the array_strings pointer
	addi $t0,$t0,1 											#i += 1;
	
print_strings_loop_check:
	blt $t0,$a1,print_strings_loop							#if(i < number of strings) {print_strings_loop}
	
	lw $ra,($sp)											#Restore $ra
	lw $s0,4($sp)											#Restore $s0
	addi $sp, $sp, 8										#Delete the added stack
	jr $ra													#Return to the function call
	
	
	
string_sort:
					#Assumes $a0 = address of array_strings and $a1 = number of strings
	subi $sp, $sp,20										#Adding 5 spaces to the stack
	sw $ra,($sp) 											#Store $ra
	sw $s0,4($sp) 											#Store $s0
	sw $s1,8($sp) 											#Store $s1
	sw $s2,12($sp) 											#Store $s2
	sw $s3,16($sp) 											#Store $s3
	
	move $s0,$a0 											#store value of $a0 into $s0
	move $s1,$a1 											#store value of $a1 into $s1
	# we use s2 as i
	# we use s3 as j
	move $s2,$s1											#i = number of strings
	addi $s2,$s2,-1											#i = n - 1;
	j string_sort_for_loop_outer_check						#Go to the outer loop check (conditional)
	
string_sort_for_loop_outer:

	li $s3,0 												#int j = 0;
	j string_sort_for_loop_inner_check						#Go to the inner loop check (conditional)
	
string_sort_for_loop_inner:

	mulu $t0,$s3,100 										#$t0 = j * 100
	addiu $t1,$t0,100 										#$t1 = (j+1) * 100
	addu $a0,$s0,$t0 										#$a0 = arr[j]
	addu $a1,$s0,$t1 										#$a1 = arr[j+1]
	jal strcmp												#Call the strcmp function
	
	bltz $v0,string_sort_for_loop_inner_update				#if(return value < 0) {inner_loop_update}

	mulu $t0,$s3,100 										#$t0 = j * 100
	addiu $t1,$t0,100 										#$t1 = (j+1) * 100
	addu $a0,$s0,$t0 										#$a0 = arr[j]
	addu $a1,$s0,$t1 										#$a1 = arr[j+1]
	jal swap 												#Call the swap function, to switch the address of the elements
	
string_sort_for_loop_inner_update:

	addi $s3,$s3,1 											#j += 1;
	
string_sort_for_loop_inner_check:

	blt $s3,$s2,string_sort_for_loop_inner 					#if(j < 1) {inner_loop}
	addi $s2,$s2,-1 										#i -= 1;
	
string_sort_for_loop_outer_check:

	li $t0,1												#Hold for compare
	bgt $s2,$t0,string_sort_for_loop_outer 					#if( i > 1) {outer_loop}
	
	lw $ra,($sp) 											#Restore $ra
	lw $s0,4($sp) 											#Restore $s0
	lw $s1,8($sp) 											#Restore $s1
	lw $s2,12($sp) 											#Restore $s2
	lw $s3,16($sp) 											#Restore $s3
	addi $sp, $sp, 20										#Delete the added stack
	jr $ra													#Return to function call
	
	
swap:

		#Assumes $a0 = address of string1 and $a1  = address of string2
	addi $sp, $sp, -4										#Make stack larger
	sw $ra,($sp) 											#Store $ra
	li $t0,MAX_STRING_SIZE 									#set $t0 as counter
	
swap_loop:
	beqz $t0,swap_done										#if(counter == 0) {swap_done}
	lbu $t1,($a0)											#Load the byte of string1
	lbu $t2,($a1)											#Load the byte of string2
	#Note: NULL = 0 in ascii table
	bnez $t1,swap_loop_swap									#if(the byte != NULL) {swap_loop_swap}
	bnez $t2,swap_loop_swap									#if(the byte != NULL) {swap_loop_swap}
	j swap_done 											#Go to swap_done if NULL reached for both strings 
	
swap_loop_swap:	
	sb $t1,($a1)											#Swap the first byte (character) of the string
	sb $t2,($a0)											#Swap the first byte of the other string
	# update pointers and counter
	addi $t0,$t0,-1											#counter -= 1;
	addi $a0,$a0,1											#Increment the string1 pointer
	addi $a1,$a1,1											#Increment the string2 pointer
	j swap_loop												#Go to swap loop
	
swap_done:	
				
	lw $ra,($sp) 											#Restore $ra
	addi $sp, $sp, 4										#Delete the added store	
	jr $ra													#Return to function call

strcmp:

		#Assumes $a0 = address of string1 and $a1 = address of string2
	addi $sp, $sp, -4										#Add stack space
	sw $ra,($sp) 											#Store $ra
	li $v0,0 												#int r = 0;
	
strcmp_loop:

	lbu $t0,($a0) 											#Get char from string1
	lbu $t1,($a1) 											#Get char from string2
	sub $v0,$t0,$t1 										#$v0 (r) = character of str1 - character of str2 (will be returned)
	beqz $t0, strcmp_loop_done 								#if(char == NULL) {strcmp_loop_done}
	beqz $t1, strcmp_loop_done 								#if(char == NULL) {strcmp_loop_done}
	addi $a0,$a0,1 											#Increment the string1 pointer
	addi $a1,$a1,1 											#Increment the string2 pointer
	beqz $v0,strcmp_loop									#if(r == 0) {strcmp_loop} //They are equal
	
strcmp_loop_done:
	lw $ra,($sp) 											#Restore $ra
	addi $sp, $sp, 4										#Delete added stack
	jr $ra													#Return to function call