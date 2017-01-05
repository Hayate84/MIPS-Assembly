               .data
array:         .word  1,  2,  3,  4,  5
               .word  6,  7,  8,  9, 10 
               .word 11, 12, 13, 14, 15 
               .word 16, 17, 18, 19, 20
               .word 21, 22, 23, 24, 25 

transpose:     .word 0, 0, 0, 0, 0
               .word 0, 0, 0, 0, 0
               .word 0, 0, 0, 0, 0 
               .word 0, 0, 0, 0, 0
               .word 0, 0, 0, 0, 0
length:        .word 5

               .text
               
               la   $s0, array
               la   $s1, transpose
               la   $t0, length
               lw   $s2, 0($t0)
               li   $s3, 20                 #row offset
               li   $s4, 4                  #col offset
               li   $t0, -1                 #i = -1
L1:
               addi $t0, $t0, 1             #i += 1
               beq  $t0, $s2, EXIT          #if i != length of the rows loop
               li   $t1, 0                  #j = 0
L2:
               beq  $t1, $s2, L1            #if j != length of the cols loop

               lw   $t2, 0($s0)             #element of the array in $t3       
               addi $s0, $s0, 4             #get next element

               mul  $t3, $s3, $t1           #get the offset from rows
               mul  $t4, $s4, $t0           #get the offset from cols
               add  $t3, $t4, $t3           #total offset
               add  $s1, $s1, $t3           #transpose[j][i] = a[i][j]
               sw   $t2, 0($s1)             #store the value of the array to the transpose array position
               sub  $s1, $s1, $t3           #reset the array
               addi $t1, $t1, 1             #next j
               j L2                         #loop 
EXIT:
               li $v0, 10
               syscall
