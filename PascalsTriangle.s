
############################################################################
# Pascals Triangle:                                                        #
#                     Program to print the first 9 terms,                  #
#                     of Pascals triangle.                                 #
############################################################################
			.text
initialize_variables:

			li	$t4, 0			#starting value for the loop
			li	$t5, 9			#ending  value for the loop n - 1 = 7 times
triangle:						#while	$t4 != $t5	
			li	$a0, 0			#argument for the factorial
			li	$a1, 0			#initialize $a1 argument for the binomial (n k)
						
			add	$a0, $a0, $t4		#n = n + 1
						
			sub	$t1, $t5, $a0		#t1 variable for the indentation
			move	$t0, $a0			#store a0 to a temporary variable because we need to print spaces
			la	$a0, spaces		#load the space string
			li	$v0, 4			#code to print string
start:
			beqz	$t1, stop		#while	t1 != 0
			syscall				#print space
			addi	$t1, $t1, -1		#$t1 -= 1 
			j	start			#loop
stop:
			move	$a0, $t0			#restore the original argument value
loop:							#loop while $a1 > $a0
			bgt	$a1, $a0, exit		#is $a1 > $a0?
			jal	binomial		#call the function
print:
			move	$t0, $a0			#store a0 variable because we need to print the value and one space
			move	$a0, $v0			#move the value to print
			li	$v0, 1			#code for print	integer
			syscall				#print the integer
			la	$a0, spaces		#load the space string
			li	$v0, 4			#code for print string
			syscall				#print the string
decrement:
			move	$a0, $t0			#restore argument to the correct value
			addi	$a1, $a1, 1		#$a1 += 1 
			j	loop			#loop until $a1 > $a0
exit:
			jal	printEndl		#call function to print newline
			addi	$t4, $t4, 1		#add next level for the triangle
			blt	$t4, $t5, triangle	#loop while $t4 < $t5
			li	$v0, 10		        #value code to terminate the program
			syscall				#end the program

####################################################################################
# Binomial coefficient: 						           #
#		Very naive way to compute with the function ((n!)/(k!) * (n - k)!) #
#		argument $a0 is n argument, argument $a1 is k argument             #
####################################################################################
						
binomial:	
			addi	$sp, $sp, -12		#free space from the stack
			sw	$a0, 4($sp)		#to keep the values from the
			sw	$a1, 8($sp)		#the arguments $a0 and $a1
						
			sub	$t3, $a0, $a1		#$t3 = n - k!
							#compute n!
			sw	$ra, 12($sp)		#space for the stack to keep the value of $ra
			jal	fact			#call factorial
			lw	$ra, 12($sp)		#restore $ra value
			move	$t1, $v0			#keep it in a temporary value
						
			move	$a0, $t3			#compute (n- k)! like the previous way
			sw	$ra, 12($sp)
			jal	fact
			lw	$ra, 12($sp)
			move	$t3, $v0			#$t3 value now is $t3! 
						
			move	$a0, $a1			#compute k!
			sw	$ra, 12($sp)
			jal	fact
			lw	$ra, 12($sp)
			move	$t0, $v0					
						
			mul	$t0, $t0, $t3		#(k!) * (n - k)!
			div	$v0, $t1, $t0		#we divide the previous value with n! and keep it in $v0 return value
						
			lw	$a0, 4($sp)		#restore argument values
			lw	$a1, 8($sp)
			addi	$sp, $sp, 12		#pop stack
			jr	$ra			#return

##################################################			
# Factorial recursive. 				 #  
#		      The return value is in $v0 # 
#		      Argument in $a0            #
##################################################

fact:			
			addi		$sp, $sp, -8
			sw		$ra, 4($sp)
			sw		$a0, 8($sp)			
					   
			bnez		$a0, recfact	
			addi		$sp, $sp, 8	#pop the stack
			li		$v0, 1		#return 1
			jr		$ra
recfact:
			addi		$a0, $a0, -1	#n - 1
			jal		fact				
			lw		$ra, 4($sp)
			lw		$a0, 8($sp)
			addi		$sp, $sp, 8
			mul		$v0, $a0, $v0	#n*fact
			jr		$ra

##############################################
# Print end line.			     #
#		  Line "\n" is in .data "\n" #
##############################################

printEndl:
			li		$v0, 4
			move		$t0, $a0		#usually a0 contains some value
			la		$a0, endl
			syscall
			move		$a0, $t0		#restore a0 original value
			jr		$ra
	
			.data
endl:			.asciiz "\n"
spaces:			.asciiz " "
