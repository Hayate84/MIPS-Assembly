						.text

						li			$a0, 44444	#large
						li			$a1, 5			#small
		
						jal			divNaive
						move	$a0, $v0
						jal			printInt
						move	$a0,	$v1
						jal			printInt
exit:
						li			$v0, 10
						syscall		

#naive division algorithm. The quotiend is in $v0 the rem is in $v1
#									   The large number must be in $a0
#									   The small in $a1

divNaive:
						addi		$sp,	$sp, -8
						sw		$ra,	  4($sp)
						sw		$a0,	  8($sp)
					   
					    slt			$t0,	$a0,	$a1			#large < small
						seq		$t1,	$a0,	$zero		#large == zero
						or			$t2,  $t0,	$t1			
					   
						beqz		$t2,	rec2
						addi		$sp, $sp, 8				#pop the stack
						move	$v1, $a0					#the rem of the number is large < small == True
						li			$v0, 0
						jr			$ra
rec2:
						sub		$a0, $a0, $a1		   #keep subtratring the small number from the large
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
