# Add the numbers in an array

.data

sum:    .space 4
i:      .space 4
a:      .word 7,8,9,10,8

.text

main:

     add   $9,$0,$0     # i in $9 = 0
     add   $8,$0,$0     # sum in $8 = 0

loop:
     sll   $10,$9,2     # convert "i" to word offset
     lw    $10,a($10)   # load a[i]
     add   $8,$8,$10    # sum = sum + a[i];
     addi  $9,$9,1      # for (...; ...; i++
     slti  $10,$9,5     # for (...; i<5;
     bne   $10,$0,loop

     sw    $8,sum($0)   # update final sum in memory
     sw    $9,i($0)     # update final i in memory
end:
     ori   $v0, $0, 10  # system call 10 for exit
     syscall            # we are out of here.