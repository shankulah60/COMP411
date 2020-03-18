.data

.text

main:

Read_in_values:
	addi $v0, $0, 5				#Read an integer, width
	syscall
	add $t3, $0, $a0			#Store read integer (width) into $t3
	addi $v0, $0, 5				#Read an integer, height
	syscall
	add $t4, $0, $a0			#Store read integer (height) into $t4
	
	#add $t0, $0, $0				#int i = 0;
	mult $t4, $t3				# width * height
	mflo $t1				#$t1 holds the number of elements to read
	add $a0, $0, $t1			#Move the num elements to read into $a0
	
	addi $v0, $0, 9				#syscall code for sbrk
	syscall					#Maze
	add $s0, $0, $v0			#Save the address of the array into $s0
	addi $v0, $0, 9				#syscall code for sbrk
	syscall					#WasHere
	add $s1, $0, $v0			#Save the address of the array into $s1
	addi $v0, $0, 9				#syscall code for sbrk
	syscall					#CorrectPath
	add $s2, $0, $v0			#Save the address of the array into $s2
	#Begin Reading Values In
	#beq $t0, $t1, end_Read_Loop		#if( i == num_elements_to_read) {End_Loop}
	add $t5, $0, $0 			#int y = 0;
	add $t6, $0, $0				#int x = 0;
Height_Loop:
	beq $t5, $t4, End_Height_Loop		#if(y == height) {end_loop}
Width_Loop:
		beq $t6, $t3, End_Width_Loop	#if(x == width) {end_loop}
		mult $t5, $t3			#y * width
		mflo $t7			#Store result in $t7
		add $t7, $t7, $t3		#Getting the array index =(x + (width * y))
		addi $v0, $0, 12		#Syscall for read character
		syscall
		add $t0, $0, $a0		#Store the read character $t0
		
		#Setup Stack for temp Registers
		addi $sp, $sp
		jal IndexMemVal
End_Width_Loop:
	addi $t6, $t6, 1			#x += 1;
	j Width_Loop				#Loop back to start of loop
End_Height_Loop:
	addi $t5, $t5, 1			#y+= 1;
	j Height_Loop				#Loop back to start of loop
	
end_main:

IndexMemVal:
	

end_IndexMemVal: