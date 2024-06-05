	.text
	
# a0 = inteiro
.global fatorial	
fatorial:
	li t0, 2  		# Valor de parada 
	beq a0, t0, fim		# se a0 for = 2 para
	addi sp, sp, -8		# Carrega 2 palavras na pilha
	sw a0, (sp)  		# Salva o valor para multiplicar 
	sw ra, 4(sp)		# Salva o Retorno
	addi a0, a0, -1		# Atualiza o parâmetro da função, ¨6 * (6-1) ...
	jal fatorial		# Chama a função
	lw t0, (sp)		# Carrega o ultimo valor de a0 salvo, 3 por exemplo
	lw ra, 4(sp)		# Carrega o ultimo retorno salvo
	addi sp, sp, 8		# Desempilha os valores
	mul a0, a0, t0		# faz a multiplicação
fim:
	ret