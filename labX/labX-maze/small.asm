.eqv true 1 # define true 1
.eqv false 0 # define false 0

.eqv MAX 40000 # 100 * 100 * 4 = 40000
.data
maze: .space MAX
wasHere: .space MAX
correctPath: .space MAX
width: .word 
height: .word 
startX: .word 
startY: .word 
endX: .word 
endY: .word 

.text
main:
	# we use $t0 for y
	# we use $t1 for x
	# we use $t2 for tempchar
	
	# scanf("%d%d", &width, &height);
	# scanf("%d", &width);
	li $v0,5
	syscall
	la $a0,width
	sw $v0,($a0)
	# scanf("%d", &height);
	li $v0,5
	syscall
	la $a0,height
	sw $v0,($a0)
	# for(y=0; y < height; y++)
	# {
	# for(x=0; x < width; x++)
	# {
	li $t0,0 # y = 0