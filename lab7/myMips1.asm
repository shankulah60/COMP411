
.data
  AA:     .space 400  		# int AA[100]
  BB:     .space 400  		# int BB[100]
  CC:     .space 400  		# int CC[100]
  m:      .space 4   		# m is an int whose value is at most 10
                   		# actual size of the above matrices is mxm
  space:  .asciiz " "
  newline:	.asciiz "\n"
# You may add more variables here if you need to



.text

main:
	addi $v0, $0, 5			#Get m
	syscall
	add $s0, $0, $v0		#$s0 holds m
	sw $s0, m($0)			#Store in m's memory location
	
	#Calculating the size of the array
	mult $s0, $s0
	mflo $s1                  #$s1 holds the size
	
	#Filling the arrays with values
	la $t1, AA($0)            #Load the address of array AA
	add $t2, $0, $0 	   #int i = 0;   $t2 holding loop counter
Loop_Fill_A:

	slt $t3, $t2, $s1	   #if(i ($t2) < size ($s1)) {$t3 = 1} else{$t3 = 0}
	beq $t3, $0, endLoop_Fill_A	#if($t3 == 0) {exit the loop}
	#Else:
	addi $v0, $0, 5		   #Getting the value from user/console
	syscall
	add $t4, $0, $v0
	
	sw $t4, ($t1)		   #Store in the array
	addi $t2, $t2, 1	   #Update the loop counter (i += 1;)
	addi $t1, $t1, 4 	   #Update the array element address 
	j Loop_Fill_A		   #Go back to the start of the loop

endLoop_Fill_A:	
	#**All registers can be overwritten
	la $t1, BB($0)		   #Load the address of array BB
	add $t2, $0, $0 	   #int i = 0;
Loop_Fill_B:
	slt $t3, $t2, $s1	   #if(i ($t2) < size ($s1)) {$t3 = 1} else{$t3 = 0}
	beq $t3, $0, endLoop_Fill_B #if($t3 == 0) {Exit the loop}
	#Else:
	addi $v0, $0, 5		   #Getting the value from the user/sonsole
	syscall
	add $t4, $0, $v0
	
	sw $t4, ($t1)		   #Store in the array
	addi $t2, $t2, 1	   #Update the loop counter (i += 1;)
	addi $t1, $t1, 4	   #Update the array element address
	j Loop_Fill_B		   #Go back to the top of the loop
	
endLoop_Fill_B:

	# **All matrix filled, Can overwrite all registers **
matmult:
	la $s2, CC($0)		   #Load the address of array CC into $s2
	
	add $t0, $0, $0 	   #int i  = 0;
	add $t1, $0, $0 	   #int j = 0;
	add $t2, $0, $0		   #int k = 0;
	add $t3, $0, $0		   #int sum = 0;
	addi $s4, $0, 4		   #Store 4 into $s4
	#Reserve $t4 for results on branches
i_loop:
	slt $t4, $t0, $s0	   #Check is (i < m)
	beq $t4, $0, end_i_loop
		#else
	j_loop:
		add $t3, $0, $0		#sum = 0;		
		slt $t4, $t1, $s0	#Check is (j < m)
		beq $t4, $0, end_j_loop
			#else
		k_loop:
			slt $t4, $t2, $s0
			beq $t4, $0, end_k_loop
			#Do the multiplication
			AA_value:
				mult $t0, $s0		#i * m;
				mflo $t5
				add $t5, $t5, $t2	# i * m + k  || index of array, not memory location
				mult $t5, $s4		#Array index * 4
				mflo $t5		#Memory location offset
				la $t6, AA($0)		#Load AA's memory location
				add $s7, $t5, $t6	#Add the offset to the memory location
				lw $s5, ($s7)		#Get the value from the array
			BB_value:
				mult $t2, $s0		#k * m;
				mflo $t5
				add $t5, $t5, $t1	# k * m + j  || index of array, not memory location
				mult $t5, $s4		#Array index * 4
				mflo $t5		#Memory location offset
				la $t6, BB($0)		#Load BB's memory location]
				add $s7, $t5, $t6	#Add the offset to the memory location
				lw $s6, ($s7)
				#lw $s6, $t5($t6)	#Get the value from the array
			calc_sumL:
				mult $s5, $s6		#AA[...] * BB[...]		*... calculated in last sections
				mflo $t7
				add $t3, $t3, $t7	#sum = sum + (AA[...] * BB[...])				
			store_in_c:
				mult $t0, $s0		#i * m
				mflo $t5
				add $t5, $t5, $t1	# i * m + j  || index of array, not memory location
				mult $t5, $s4		#Array index * 4
				mflo $t5		#Memory location offset
				add $s7, $t5, $s2	#Adding the offset to the memory location
				sw $t3, ($s7)		#Store sum into the calculated memory location of the array
				#sw $t3, $t5($s2)	#Store sum into the calculated memory location of the array
				
			
			addi $t2, $t2, 1	#k += 1;
			j k_loop
		end_k_loop: add $t2, $0, $0		#Reset k for the next iterations
		addi $t1, $t1, 1	#j += 1;
		j j_loop
	end_j_loop: add $t1, $0, $0			#Reset j for the next iterations
	addi $t0, $t0, 1 	   #i += 1;
	j i_loop

end_i_loop: add $t0, $0, $0		#Reset i for the next iterations
	
end_matmult:

	#** CC Filled, Can overwrite all temporary registers **	
print:
	add  $t2, $0, $s2
	add $t0, $0, $0 	   #int i  = 0;
	add $t1, $0, $0	   	   #int cnt = 0;
print_Loop:
	slt $t3, $t0, $s1
	beq $t3, $0, Endprint_Loop  #if(i > max) {end loop} 
	#Else
	
	if_one:	
		slt $t3, $t1, $s0
		beq $t3, $0, end_if_one
		#else
		lw $t4, ($t2)		#Get the number from the array into $t4
		addi $v0, $0, 1		#Print the number
		add $a0, $0, $t4
		syscall
		addi $v0, $0, 4
		la $a0,space
		syscall
		addi $t1, $t1, 1	#cnt += 1;
	end_if_one:
	if_newline:
		bne $t1, $s0, end_if_newline
		#else
		addi $v0, $0, 4		#Print a newline
		la $a0, newline
		syscall
		add $t1, $0, $0		#cnt  = 0;
	end_if_newline:
	#increment loop counter and the cnt
	addi $t0, $t0, 1
	addi $t2, $t2, 4
	j print_Loop
Endprint_Loop:
	
#Load the memory location of CC <-- Store it
#Calculate the array index like in C, place index value into a register
#Use add to add the value into the 	
	
	
	
	
	
	
	
#------- INSERT YOUR CODE HERE for main -------
#
#  Best is to convert the C program line by line
#    into its assembly equivalent.  Carefully review
#    the coding templates near the end of Lecture 8.
#
#
#  1.  First, read m (the matrices will then be size mxm).
#  2.  Next, read matrix A followed by matrix B.
#  3.  Compute matrix product.  You will need triple-nested loops for this.
#  4.  Print the result, one row per line, with one (or more) space(s) between
#      values within a row.
#  5.  Exit.
#
#------------ END CODE ---------------




exit:                     # this is code to terminate the program -- don't mess with this!
  addi $v0, $0, 10      	# system call code 10 for exit
  syscall               	# exit the program



#------- If you decide to make other functions, place their code here -------
#
#  You do not have to use helper methods, but you may if you would like to.
#  If you do use them, be sure to do all the proper stack management.
#  For this exercise though, it is easy enough to write all your code
#  within main.
#
#------------ END CODE ---------------
