.text  0x3000

ori $t8, $0, 65535

addi $v0, $0, 1 		#l for printing an integer
add $a0, $0, $t8
syscall
