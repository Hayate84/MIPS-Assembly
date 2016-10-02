#fast exponantiation
#b^n	b = $a0	n = $a1

						.text
						.globl main
main:		
						li			$a0, 3
						li			$a1, 5
						
						jal			fast
						
						move	$a0, $v0
						jal			printInt
exit:									
						li			$v0, 10
						syscall		
fast:
						addi		$sp, $sp, -8					#free some space of the stack
						sw		$a1, 4($sp)					#this argument changes, we need to keep it
						sw		$ra,	8($sp)
						
						bnez		$a1,	L1						#base case of recursion b^0 = 1
						addi		$sp, $sp, 8					#pop the stack
						li			$v0, 1
						jr			$ra								#return
L1:						
						addi		$sp, $sp, -4					#we jump to a procedure
						sw		$ra,	12($sp)				#to 	know if	our number
						jal			iseven							#is even
						lw			$ra,	12($sp)				
						addi		$sp,	$sp, 4
						beqz		$t0,	L2						#if number is even
						div		$a1,	$a1, 2					#b^n = (b^(n/2))^2
						jal			fast
						mul		$v0,	$v0, $v0				#square the value
						lw			$ra,	8($sp)					#pop the stack
						lw			$a1,	4($sp)					#and return
						addi		$sp,	$sp, 8
						jr			$ra
L2:																	#if number is not even
						addi		$a1, $a1, -1					#b^n = b * b^(n - 1)
						jal			fast
						mul		$v0, $v0, $a0				#the multiplication
						lw			$ra,	8($sp)					#pop the stack
						lw			$a1,	4($sp)					#and return
						addi		$sp,	$sp, 8
						jr			$ra	
iseven:																#function to check if a number is even
						rem		$t0, $a1, 2					#the psedoinstruction for the rem
						beqz 	$t0, true						
						li			$t0, 0							#if is not even
						jr			$ra								#return 0 for false
true:																	#else
						li			$t0, 1							#return 1 for true
						jr			$ra
printInt:		
						addi		$sp, $sp, -4
						sw		$ra, 0($sp)
						li			$v0, 1
						syscall
						addi		$sp, $sp, -4 					#extra code for the stack
						sw		$ra, 0($sp)  					#to keep the value of ra
						jal			printEndl	   					#for printing new line
						lw			$ra, 0($sp)
						addi		$sp, $sp, 4
						jr			$ra
printEndl:
						li			$v0, 4
						move	$t0, $a0   					#usually a0 contains some value
						la			$a0, endl
						syscall
						move	$a0, $t0   					#restore a0 original value
						jr			$ra
	
						.data
endl:					.asciiz "\n"