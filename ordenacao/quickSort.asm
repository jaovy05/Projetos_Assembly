#------------- Quick Sort -------------
# a0 = vetor, a1 = inicio, a2 = fim
quick_sort:
	bge a2, a1, fim
	mv s0, a0
	call particiona
	jal quick_sort
	jal quick_sort
fim: 
	ret

# a0 = vetor, a1 = inicio, a2 = fim
particiona:
	mv t0, a0
	mv t1, a1
	
	sub a1, a2, a1	# Quantidade de elementos 	
	li a7, 42	# Selecionar um indice aleatório para ser o pivo
	ecall 
	add a0, a0, t1	# Corrige o indice do pivo
	slli a0, a0, 2	# multiplica por 4
	
	slli t2, t1, 2 	# k vai ser o inicio
	
	slli a2, a2, 2	# Multiplica por 4
	add t3, t0, a2	# Posiçãoa do fim
	add a0, t0, a0	# Posição pivo
	lw t4, (t3)	# Elemento fim
	lw t5, (a0)	# Valor de pivo
	sw t4, (a0)	# Troca os valores
	sw t5, (t3)	# Troca os valores
	
	slli t1, t1, 4 	# i vai ser o início
for:
	beq a2, t1, fimp
	lw t4, (t1)	# elemento atual
	lw t5, (t3)	# fim
	addi t1, t1, 4
	bgt t4, t5, for
	
	lw t4, (t2)
	sw t5, (t2)
	sw t4, (t1)
	addi t2, t2, 4
	j for
fimp:
	
