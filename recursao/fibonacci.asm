#função fibonacci:
# input: a0 = numero da seguencia
# output: a0 = valor
.global fibonacci
fibonacci:
	li t0, 2
	ble a0, t0, fim
	
	addi sp, sp, -8
	sw ra, (sp)
	sw a0, 4(sp)
	# | 0Xffff |
	# |    i   |	
	addi a0, a0, -1
	jal fibonacci
	mv t1, a0
	lw a0, -4(sp)
	jal fibonacci
	add a0, a0, t1
	ret
	
fim:
	li a0, 1
	ret