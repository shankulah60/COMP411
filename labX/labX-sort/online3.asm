#
# "Insertion Sort -- Assembly Version"
#
# This MIPS assembly code -- based on MIPS R3000's instruction set -- first
# receives the number of values to be sorted (N), then receives the values
# (for N times) to be sorted, and then sort the values using "Insertion Sort"
# and prints the result of the sorting.
#
# Note: Maximum number of values to be sorted (N) is 999 numbers.
#
# Author: Benjapol Worakan (benwrk)
#
	.data
space:	.asciiz " "		# a space string.
line:	.asciiz	"\n"		# a newline string.
colonsp:	.asciiz ": "	# a colon string with space.
array:	.word	0 : 1000	# an array of word, for storing values.
size:	.word	5		# actual count of the elements in the array.

param_info_string:	.asciiz	"Input number of values to be sorted (0 < N < 1000): "
receive_values_loop_info_string:	.asciiz	"Input each value: "
receive_values_loop_iter_string:	.asciiz	"Input value#"
sorted_array_string:	.asciiz "Sorted:"

	.text
	.globl	main
main:
params_info:
	li	$v0, 4			# 4 = print_string syscall.
	la	$a0, param_info_string	# load params_info_string to argument register $a0.
	syscall				# issue a system call.
params:
	li	$v0, 5			# 5 = read_int syscall.
	syscall				# issue a system call.
	la	$t0, size		# load address of size to $t0.
	sw	$v0, 0($t0)		# store returned value in $v0 to size.
receive_values_loop_info:
	li	$v0, 4			# 4 = print_string syscall.
	la	$a0, receive_values_loop_info_string	# load receive_values_loop_info_string to argument register $a0.
	syscall				# issue a system call.
	li	$v0, 4			# 4 = print_string syscall.
	la	$a0, line		# load line to argument register $a0.
	syscall				# issue a system call.
receive_values_loop_prep:
	la	$t0, array		# load array to $t0.
	lw	$t1, size		# load size to $t1.
	li	$t2, 0			# loop runner, starting from 0.
receive_values_loop:
	bge	$t2, $t1, receive_values_end	# while ($t2 < $t1).
	li	$v0, 4			# 4 = print_string syscall.
	la	$a0, receive_values_loop_iter_string # load receive_values_loop_iter_string to argument register $a0.
	syscall				# issue a system call.
	li	$v0, 1			# 1 = print_int syscall.
	addi	$a0, $t2, 1		# load (runner + 1) to argument register $a0.
	syscall				# issue a system call.
	li	$v0, 4			# 4 = print_string syscall.
	la	$a0, colonsp		# load colonsp to argument register $a0.
	syscall				# issue a system call.

	li	$v0, 5			# 5 = read_int syscall.
	syscall				# issue a system call.
	sw	$v0, 0($t0)		# store returned value from syscall in the array.

	addi	$t0, $t0, 4		# increment array pointer by 4.
	addi	$t2, $t2, 1		# increment loop runner by 1.
	j	receive_values_loop	# jump back to the beginning of the loop.
receive_values_end:
	jal	print			# call print routine.
sort_prep:
	la	$t0, array		# load array to $t0.
	lw	$t1, size		# load array size to $t1.
	li	$t2, 1			# loop runner, starting from 1.
sort_xloop:
	la	$t0, array		# load array to $t0.
	bge	$t2, $t1, sort_xloop_end	# while (t2 < $t1).
	move	$t3, $t2		# copy $t2 to $t3.
sort_iloop:
	la	$t0, array		# load array to $t0.
	mul	$t5, $t3, 4		# multiply $t3 with 4, and store in $t5
	add	$t0, $t0, $t5		# add the array address with $t5, which is the index multiplied with 4.
	ble	$t3, $zero, sort_iloop_end	# while (t3 > 0).
	lw	$t7, 0($t0)		# load array[$t3] to $t7.
	lw	$t6, -4($t0)		# load array[$t3 - 1] to $t6.
	bge	$t7, $t6, sort_iloop_end	# while (array[$t3] < array[$t3 - 1]).
	lw	$t4, 0($t0)
	sw	$t6, 0($t0)
	sw	$t4, -4($t0)
	subi	$t3, $t3, 1
	j	sort_iloop		# jump back to the beginning of the sort_iloop.
sort_iloop_end:
	addi	$t2, $t2, 1		# increment loop runner by 1.
	j	sort_xloop		# jump back to the beginning of the sort_xloop.
sort_xloop_end:
	li	$v0, 4			# 4 = print_string syscall.
	la	$a0, sorted_array_string	# load sorted_array_string to argument register $a0.
	syscall				# issue a system call.
	li	$v0, 4			# 4 = print_string syscall.
	la	$a0, line		# load line to argument register $a0.
	syscall				# issue a system call.
	jal	print			# call print routine.
exit:
	li	$v0, 10			# 10 = exit syscall.
	syscall				# issue a system call.

print:
print_loop_prep:
	la	$t0, array
	lw	$t1, size
	li	$t2, 0
print_loop:
	bge	$t2, $t1, print_end
	li	$v0, 1
	lw	$a0, 0($t0)
	syscall
	li	$v0, 4
	la	$a0, space
	syscall
	addi	$t0, $t0, 4
	addi	$t2, $t2, 1
	j	print_loop
print_end:
	li	$v0, 4
	la	$a0, line
	syscall
	jr	$ra