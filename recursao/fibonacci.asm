#função fibonacci:
# input: a0 = numero da seguencia
# output: a0 = valor
.global fibonacci
fibonacci:
	li t0, 2
	ble a0, t0, fim
	
	addi sp, sp, -8
	sw a0, (sp)
	sw ra, 4(sp)
	# |  i   |
	# |  fff |	
	addi a0, a0, -1
	jal fibonacci
	mv t1, a0
	lw a0, (sp)
	addi sp, sp, 4 #desempilha o numero
	addi a0, a0, -2
	jal fibonacci
	add a0, a0, t1
	lw ra, (sp)
	addi sp, sp, 4
	ret
	
fim:
	li a0, 1
	ret
