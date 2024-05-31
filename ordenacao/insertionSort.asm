		.data
vetor:		.space 400
n:		.word 50

		.text
		
main:	
	la a0, vetor
	lw a1, n
	call set_vector
	la a0, vetor
	lw a1, n
	jal insertion_Sort
	la a0, vetor
	lw a1, n
	call print
fim:
	li a7, 93
	li a0, 0
	ecall

#------------------- Insertion Sort ----------------------------
insertion_Sort:
	li t0, 1		# Variavel de controle do for
	addi a0, a0, 4
for0:
	beq t0, a1, fimf	# Se i for = n volta para o loop
	lw t1, 0(a0) 		# Carrega o min, min = vetor[i]
	mv t2, t0 		# Inicia a 2° variável de controle, j = i
	mv t3, a0		# Copia o valor do vetor para t3, v[j]
for1:
	beqz t2, inc		# Só faça se j > 0
	lw t4, -4(t3)		# Acha a posição anterior do vetor[j]
	bge t1, t4, inc		# Se min >= vetor[j-1] ele vai atualizar o v[j]
	sw t4, 0(t3)		# Troca o valor de vetor[j] para vetor[j-1]
	addi t2, t2, -1		# Incrementa j, j--
	addi t3, t3, -4		# Acompanha o deslocamento de j
	j for1
inc:	
	sw t1, 0(t3)		# Coloca em V[j] o min
	addi t0, t0, 1		# Incrementa o i, i++
	addi a0, a0, 4		# Acompanha o deslocamento de i
	j for0
fimf:
	ret
	