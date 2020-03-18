strcmp:
	add $t0, $0, $0			#int i  = 0;
	addi $t1, $0, 20		#Max each string
	la $t6, 0($a0)			#Copy of $a0, for incrementation
	la $t7, 0($a1)			#Copy of $a1 for incrementation
	addi $s3, $0, 1			#For comparisons (later)
	cmp_loop:
		beq $t0, $t1, done
		lb $t3, 0($t6)		#First char of string1
		lb $t4, 0($t7)		#First char of string2
		beq $t3, $t4, next_char	#if(char1 ==  char2) {next_char}
		slt $t5, $t4, $t3	#if (char2 < char1) {$t5 = 1;}
		j done
	next_char:
		addi $t6, $t6, 1	#Next char of string1
		addi $t7, $t7, 1	#Next char of string2
		addi $t0, $t0, 1	#i += 1;
		j cmp_loop
	done:
		add $v0, $0, $t5	#retrns 1 if string2 < string1 and 0 if it is already in right order
		jr $ra
		