		.data
vetor:		.space 400
n:		.word 50

main:	
	la a0, vetor
	lw a1, n
	call set_vector
	la a0, vetor
	li a1, 0
	lw a2, n
	jal quick_Sort
	la a0, vetor
	lw a1, n
	call print
fim:
	li a7, 93
	li a0, 0
	ecall
	
#------------- Quick Sort -------------
quick_sort:
	