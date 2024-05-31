
		.data

tam:		.word 250
vetor:		.space 1000 # (tam* 4)

		.text

main:
	la a0, vetor
	lw a1, tam
	call set_vector #faz um jump para função set_vector
	la a0, vetor
	lw a1, tam
	jal selection_sort #faz um jump para função buble_sort
	la a0, vetor
	lw a1, tam
	call print #faz um jump para função print

fim:
	li a7, 93 #realiza uma chamada de sistema com código 93(encerra programa)
	li a0, 0 #encerra o programa com 0
	ecall
	
#---------- função selectionSort(*v, n) --------

selection_sort:
	mv s1, a1 		#cópia o tamanho para s1
	addi s1, s1, -1 	#subtraindo 1 do valor de s1
	mv t0, zero 		# int i = 0
	
for0:
	beq t0, s1, fim_func
	mv t1, t0 		# coloca o valor da variavel temporaria em t1
	addi t2, t0, 1		# variavel de controle j = i + 1
	
	lw t3, 0(a0)
	mv s0, a0		# Duplica o vetor min para ter o J
	addi s0, s0, 4		# J vai ser a proxima casa
	
for1:
	lw t4, 0(s0)		# Carrega o valor do v[j]
	beq t2, a1, troca	# Se J for = tamanho vai verificar troca
	bge t4, t3, incrementa0	# Se o j for maior que o min volta pro loop
	mv t3, t4		# Troca os valores para min ficar com o menor
	mv t1, t2		# Atualiza o indice do min

incrementa0:
	addi t2, t2, 1		# Incrementa j (j++)
	addi s0, s0, 4		# Incrementa o vetor para acompanhar j, v2 = v[j]
	j for1

troca:
	beq t1, t0, incrementa1	# Se for igual volta para o loop
	sub t1, t1, t0		# Calcula a distância dos inteiros
	slli t1, t1, 2		# Calcula a distância em bytes
	lw t2, 0(a0)		# Lê o valor da posição "i" a ser trocada
	sw t3, 0(a0)		# Troca o i pelo min
	add a0, a0, t1		# Soma a distância calculada
	sw t2, 0(a0)		# Troca o min pelo i
	sub a0, a0, t1		# Volta para a posição normal
	
incrementa1:
	addi t0, t0, 1		# Incrementa i (i++)
	addi a0, a0, 4		# Incrementa o vetor para acompanhar i, v1 = v[i]
	j for0			# Volta para o loop principal

fim_func:
	ret #retorna ao endereço de memória que esta no registrador ra

