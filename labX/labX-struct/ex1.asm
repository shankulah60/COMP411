.data
	newline: .asciiz "\n"
	space: .asciiz " "
.text
	
make_memory:

	#Getting user input
	li $v0, 5				#syscall code for read an integer
	syscall
	move $s0, $v0			#Store number of records to read into $s0
	
	#Calculate and make the amount of space required
	addi $t0, $0, 16		#4*4 = 16 bytes per record		
	mul $a0, $t0, $s0		#16 * number of records = amount of space
	
	li $v0, 9				#Dynamic memory allocation
	syscall
	addu $s1, $0, $v0		#Store the address into $s1 (buffer)
	
	addi $t0, $0, 4			#4 bytes per address (pointer)
	mul $a0, $t0, $s0		#4 * number of records = amount of space for pointers
	
	li $v0, 9				#Dynamic memory allocation
	syscall
	addu $s2, $0, $v0		#Store the pointers array in $s2 (pointers)
	
read_in:
	
	#Set up some looping variabless
	add $t0, $0, $0 		#int i  = 0;
	addu $t1, $0, $s1		#buffer pointer
	addu $t2, $0, $s2		#pointer array pointer
	
loop_1:
	
	beq $t0, $s0, end_loop	#if(i >= number of records) {end_loop}
	
	sw $t1, 0($t2)
	li $v0, 5				#syscall for read int
	syscall
	sw $v0, 0($t1)			#Store in buffer's pointer
	li $v0, 5				#Syscall for read int
	syscall
	sw $v0, 4($t1)			#Store in buffer's pointer
	li $v0, 5				#Syscall for read int
	syscall
	sw $v0, 8($t1)			#Store in buffer's pointer
	li $v0, 5				#Syscall for read int
	syscall
	sw $v0, 12($t1)			#Store in buffer's pointer
	
	#Done reading one record in
	addiu $t1, $t1, 16		#Update buffer pointer by length of one record
	addiu $t2, $t2, 4		#Update by the length of one address
	addi $t0, $t0, 1
	j loop_1
	
end_loop:


bubble_sort:
	add $t0, $0, $0			#int i  = 0;
	addi $s3, $s0, -1		#max_outer_loop = number of records - 1 (n - 1)
outer_loop:
	beq $t0, $s3, end_bubble_sort
	add $t1, $0, $0			#int j = 0;
	add $s4, $0, $s3		#max_inner_loop = number of records - 1 (n-1)
	sub $s4, $s4, $t0		#max_inner_loop = number of records - 1 - i (n - 1- i)
inner_loop:
	beq $t1, $s4, end_outer_loop		#if(j >= (n-1-i)) {end_inner_loop}
	addi $t2, $0, 4			#Load 4 into $t2
	mul $t3, $t1, $t2		# $t3 = j * 4
	addu $t3, $t3, $s2		#$t3 = $t3 + $s2 (j*4 plus the memory location of the pointers array)
	addu $a0, $0, $t3
	#lw $a0, 0($t3)			#Load the memory location of the pointer from pointers array
	jal int_cmp				#Compare the records and swap if needed
end_inner_loop:
	addi $t1, $t1, 1		#j += 1;
	j inner_loop
end_outer_loop:
	addi $t0, $t0, 1		#i += 1;
	j outer_loop
end_bubble_sort:
	j printer
	#jr $ra					#Might not need this





int_cmp:
	#Assumes that you are sending pointer to pointers array in $a0
	lw $s5, 0($a0)			#Load record #1's pointer
	lw $s6, 4($a0)			#Load record #2's pointer
	#addu $s5, $0, $a0		#Record #1'a pointer
	#addiu $s6, $a0, 16		#Record #2'a pointer
	
	
year_if:	
	lw $t5, 0($s5)			#Load Year #1
	lw $t6, 0($s6)			#Load Year #2
	beq $t5, $t6, month_if	#if(Year1 == Year2) {Go to month_if}
	sgt $t7, $t5, $t6		#set true if $t5 > $t6
	beq $t7, 1, swap		#if ^ == 1 then swap order
	j done_cmp				#else, already in order, done with function
	
month_if:
	lw $t5, 4($s5)			#Load Month #1
	lw $t6, 4($s6)			#Load Month #2
	beq $t5, $t6, day_if	#if(Month1 == Month2) {Go to day_if}
	sgt $t7, $t5, $t6		#Set true if $t5 > $t6
	beq $t7, 1, swap		#if ^ == 1, then swap order
	j done_cmp

day_if:
	lw $t5, 8($s5)			#Load Day #1
	lw $t6, 8($s6)			#Load Day #2
	beq $t5, $t6, id_if		#if(Day1 == Day2) {Go to id_if}
	sgt $t7, $t5, $t6		#Set true if $t5 > $t6
	beq $t7, 1, swap		#If ^ == 1, then swap order
	j done_cmp
	
id_if:
	lw $t5, 12($s5)			#Load ID #1
	lw $t6, 12($s6)			#Load ID #2
	sgt $t7, $t5, $t6		#Set true if $t5 > $t6
	beq $t7, 1, swap		#if ^ , then go to swap
	j done_cmp			

swap:
	addu $s7, $0, $s5			#Temp, hold value of Record #1
	sw $s6, 0($a0)			#Store value of Record #2 (it's memory address) to $s5 position in the pointers array
	sw $s7, 4($a0)			#Store value of Recors #1 (it's memory address) to $s6 position in the pointers array

done_cmp:
	jr $ra					#Return to function call
	

printer:
	add $t0, $0, $0			#int i  = 0;
	addu $t1, $0, $s2		#pointers array pointer (memory address)	
print_loop:
	beq $t0, $s0, exit		#if(i >= number of records) {exit}
	lw $t2, 0($t1)			#Load the pointer to the record that we are one
	lw $a0, 0($t2)			#Load the year as the first argument
	li $v0, 1				#syscall code for print an integer
	syscall
	jal print_space
	lw $a0, 4($t2)			#Load the month
	li $v0, 1
	syscall
	jal print_space
	lw $a0, 8($t2)			#Load the day
	li $v0, 1
	syscall
	jal print_space
	lw $a0, 12($t2)			#Load the ID
	li $v0, 1
	syscall
	jal print_newline
	
	addi $t0, $t0, 1		#i += 1;
	addiu $t1, $t1, 4		#Get next record's pointer
	j print_loop

print_newline:
	la $a0, newline			#print a newline
	li $v0, 4
	syscall
	jr $ra
	
print_space:
	la $a0, space			#Print a space
	li $v0, 4
	syscall
	jr $ra

exit:
	li $v0, 10				#Exit program nicely
	syscall

	
	
	
