#Some simple math functions

     .text

      li    $a0, 3
      li    $a1, 9
						
      jal   fast
      move  $a0, $v0
      jal   printInt
exit:
      li    $v0, 10
      syscall
      
####################################################						
# recursive naive algorithm for power of a number. #
# x = b^n                                          # 
# b in $a0.                                        #   
# n in $a1                                         #
# x returning value in v0                          # 
####################################################

power:
      addi  $sp, $sp, -8
      sw    $ra, 4($sp)
      sw    $a1, 8($sp)
					   
      bnez  $a1, rec
      addi  $sp, $sp, 8    #pop the stack
      li    $v0, 1         #return 1
      jr    $ra
rec:
      addi  $a1, $a1 -1	   #n = n - 1
      jal   power
      mul   $v0, $v0, $a0  #b * (b^n)
      lw    $ra, 4($sp)
      lw    $a1, 8($sp)
      addi  $sp, $sp, 8
      jr    $ra

#####################################
# fast exponetiation algorithm.     #						
# same as power x = b^n.            #
# but better fewer multiplications. #
# b in $a0.                         #
# n in $a1.                         #
# x returning value in v0.          #
#####################################

fast:
      addi   $sp, $sp, -8    #free some space of the stack
      sw     $a1, 4($sp)     #this argument changes, we need to keep it
      sw     $ra, 8($sp)
						
      bnez   $a1, L1         #base case of recursion b^0 = 1
      addi   $sp, $sp, 8     #pop the stack
      li     $v0, 1
      jr     $ra             #return
L1:						
      addi   $sp, $sp, -4    #we jump to a procedure
      sw     $ra, 12($sp)    #to know if our number
      jal    iseven	     #is even
      lw     $ra, 12($sp)    				
      addi   $sp, $sp, 4     
      beqz   $t0, L2         #if number is even
      div    $a1, $a1, 2     #b^n = (b^(n/2))^2
      jal    fast
      mul    0,	$v0, $v0     #square the value
      lw     $ra, 8($sp)     #pop the stack
      lw     $a1, 4($sp)     #and return
      addi   $sp, $sp, 8
      jr     $ra
L2:		             #if number is not even
      addi   $a1, $a1, -1    #b^n = b * b^(n - 1)
      jal    fast
      mul    $v0, $v0, $a0   #the multiplication
      lw     $ra, 8($sp)     #pop the stack
      lw     $a1, 4($sp)     #and return
      addi   $sp, $sp, 8
      jr     $ra

##########################################
# function to check if a number is even. #
# is number in $a0 even?                 #
##########################################

iseven:			
      rem   $t0, $a1, 2    #the psedoinstruction for the rem
      beqz  $t0, true						
      li    $t0, 0         #if is not even
      jr    $ra		   #return 0 for false
true:			   #else
      li    $t0, 1	   #return 1 for true
      jr    $ra

########################
#is number in $a0 odd? #
########################

odd:
      rem   $a0, $a0, 2
      beqz  $a0, tru
      li    $a0, 1
      jr    $ra
tru:
      li    $a0, 0
      jr    $ra	
      
######################################################################						
# naive integer - division algorithm.                                #
# The quotiend is in $v0 the rem is in $v1                           #
# The large number must be in $a0                                    #
# The small in $a1                                                   #    
######################################################################

divNaive:

      addi  $sp, $sp, -8
      sw    $ra, 4($sp)
      sw    $a0, 8($sp)
					   
      slt   $t0, $a0, $a1   #large < small
      seq   $t1, $a0, $zero #large == zero
      or    $t2, $t0, $t1			
	  		   
      beqz  $t2, rec2
      addi  $sp, $sp, 8     #pop the stack 
      move  $v1, $a0#the rem of the number is large < small == True
      li   $v0, 0
      jr   $ra
rec2:
      sub	 $a0, $a0, $a1		   #keep subtratring the small number from the large
      jal			divNaive					
  				addi		$v0, $v0 1			  #the quotiend is, how many time we sutracted the small number from the large
     	lw			$ra,	4($sp)
      lw			$a0,	8($sp)
     	addi		$sp,	$sp, 8
						jr			$ra						
printInt:		
						addi		$sp, $sp, -4
						sw		$ra, 0($sp)
						li			$v0, 1
						syscall
						addi		$sp, $sp, -4 		#extra code for the stack
						sw		$ra, 0($sp)  		#to keep the value of ra
				 	jal			printEndl	   		#for printing new line
						lw			$ra, 0($sp)
				 	addi		$sp, $sp, 4
						jr			$ra
printEndl:
				 	li			$v0, 4
				 	move	$t0, $a0   		#usually a0 contains some value
				 	la			$a0, endl
					 syscall
					 move	$a0, $t0   		#restore a0 original value
						jr			$ra
	
						.data
endl:					.asciiz "\n"
buffer:				.space 16
