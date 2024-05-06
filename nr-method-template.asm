.data


.text
	
	li t0, 2999		# load a value to convert to floating point
	fcvt.s.w fa0, t0	# convert int to float 
	jal prntFloat		# print it to be sure the conersion worke
	
	# complete 2a, 2b, and 2c
	fsqrt.s fa0, fa0	# square root float
	jal prntFloat
	fmul.s fa0, fa0, fa0	# square float to return to original
	jal prntFloat		
	jal prntNewLine
	
	# complete 2d (repeating 2a, 2b, and 2c, except with double precision
	fcvt.d.w fa0, t0 	# convert int to double
	jal prntDouble
	fsqrt.d fa0, fa0	# square root double
	jal prntDouble
	fmul.d fa0, fa0, fa0	# square double to get original
	jal prntDouble
	jal prntNewLine
	
	
	# now test Newton-Raphson method

	li t0, 9		# number n iterations
	li t1, 2999		# number X you want sqrt
	li t2, 2		# load constant 2
	li t3, 10		# load constant 10
	
	# perform conversions for t1, t2, t3, and store results in ft0, ft2, and ft4
	fcvt.d.w ft0, t1	# ft0 = 2999.0
	fcvt.d.w ft2, t2	# ft2 = 2.0
	fcvt.d.w ft4, t3	# ft4 = 10.0
	
	#jal NewtonRoots		# get sqrt(N) in n iterations
	
	#li t0, 3
	#jal NewtonRoots
	#jal prntNewLine
	#jal prntDouble
	
	#li t0, 5
	#jal NewtonRoots
	#jal prntNewLine
	#jal prntDouble
	
	#li t0, 7
	#jal NewtonRoots
	#jal prntNewLine
	#jal prntDouble
	
	#li t0, 9
	#jal NewtonRoots
	#jal prntNewLine
	#jal prntDouble
	
	li t1, 556932
	
	fcvt.d.w ft0, t1
	fsqrt.d fa0, ft0
	jal prntNewLine
	jal prntDouble
	
	jal s3, NewtonRoots
	
	
	#fmv.d fa0, <result register>	# move the function result to fa0, and print the result

	
	jal exit
		
NewtonRoots:
	
	# set up the initial conditions by checking if the input is > 10
	# follow the instructions for the initial guess in the assignment
	blt t1, t3, Jump10	# if 2999 < 10: go to Jump10
	fdiv.d fa0, ft0, ft4	# fa0 = 2999.0/10.0
	jal s2, NewtonRootsLoop
	
	jr s3
	Jump10: 
	fdiv.d fa0, ft0, ft2	# fa0 = 2999.0/2.0
	jal s2, NewtonRootsLoop
	
	jr s3

NewtonRootsLoop:

	# perform the actual N-R method computation
	#li t6, 0 		# i = 0
	
	li t6, 1		# 1 for 10^-x
	fcvt.d.w ft11, t6	# convert 1 to double
	li s8, 100000000		# x for 10^-x
	fcvt.d.w fs8, s8	# convert x to double
	fdiv.d ft11, ft11, fs8	# 1/x for 10^-x (0.001
	fadd.d fs7, fa0, fa0	#copy estimated to fs7
	fsub.d fs7, fs7, fa0	#copy estimated to fs7
	loop:	
	fmul.d ft5, fa0, fa0 	#square of floating point for function
	fsub.d ft6, ft5, ft0 	#f(xn)
	fmul.d ft7, ft2, fa0 	#f'(xn)
 	fdiv.d ft8, ft6, ft7 	#f(x)/f'(xn)
	fsub.d fa0, fa0, ft8 	#xn - f(xn)/f'(xn)
	#addi t6, t6, 1
	fsub.d ft10, fs7, fa0   #difference between previous estimated and current
	fadd.d fs7, fa0, fa0	#copy estimated to fs7
	fsub.d fs7, fs7, fa0	#copy estimated to fs7
	#bne t6, t0, loop #loop if i!=9
	fle.d s9, ft10, ft11	#s9=1 if difference < 0.001
	jal prntNewLine
	jal prntDouble
	bne s9, t6, loop	#if not difference < 0.001, then loop
	jr s2

# helper functions

# prints a float and newline, assuming float already moved to fa0
prntFloat:
	li a7, 2
	ecall
	li a0, '\n'
	li a7, 11
	ecall
	jr ra

# prints a double and newline, assuming double already moved to fa0
prntDouble:
	li a7, 3
	ecall
	li a0, '\n'
	li a7, 11
	ecall
	jr ra
	
prntNewLine:
	li a0, '\n'
	li a7, 11
	ecall
	jr ra

exit:
	li a7, 10
	ecall
