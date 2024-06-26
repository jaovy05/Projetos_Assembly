
		.data
		#estatisticas

qtd_inserido:	.word 0
qtd_removido:	.word 0
head:		.word 0
maior:		.space 4
menor:		.space 4
funcoes:	.space 20

		#inputs simples para o usuario
txt_inserido:	.string "foi inserido\n"
txt_removido:	.string "foi removido\n"
txt_input:	.string "\nDigite um n�mero\n"
n_implementado:	.string "\nEsta opera��o n�o foi implementada\n"
txt_invalido:	.string "\n***DIGITE UMA OP��O V�LIDA***\n"

		#print do menu
menu:		.ascii "*** MENU ***\n\n"
op1:		.ascii "1 - Inserir\n"
op2:		.ascii "2 - Remover por indice\n"
op3:		.ascii "3 - Remover por valor\n"
op4:		.ascii "4 - Imprimir lista\n"
op5:		.ascii "5 - Estat�sticas\n"
op6:		.asciz "6 - Sair\n"

		.text
main:
	li s0, 0		# Inicia o registrador de controle das op��es menores inv�lidas 
	li s1, 6		# Inicia o registrador de controle das op��es maiores inv�lidas 
	la t0, funcoes		# Carrega o vetor de fun��es
	la t1, insere_inteiro	# Endere�o da fun��o de inserir	
	sw t1, 0(t0)		# Adiciona a fun��o no vetor v[0]
	la t1, remove_por_indice 
	sw t1, 4(t0)		# Adiciona a fun��o no vetor v[1]
	la t1, remove_por_valor # Endere�o da fun��o de remover por valor	
	sw t1, 8(t0) 		# Adiciona a fun��o no vetor v[2]
	la t1, imprime_lista	
	sw t1, 12(t0)		# Adiciona a fun��o no vetor v[3]
	la t1, estatistica	
	sw t1, 16(t0)		# Adiciona a fun��o no vetor v[4]
	li a7, 4 		# Comando para PrintString
	
loop_menu:
	la a0, menu		# Carrega o menu para ser printado
	ecall			# Chama o OS
	li a7, 5		# Comando para ReadInt
	ecall			# Chama o OS
	beq a0, s1, fim		# Se op��o = 6 encerra 
	blt s1, a0, invalido	# Se op��o > 6 � inv�lida 
	bge s0, a0, invalido	# Se 0 >= op��o � inv�lida
	mv t2, a0		# Coloca op��es em uma var temporaria para calculo de indice
	addi t2, t2, -1		# Tira um para trabalhar com 0 at� 4
	la t0, funcoes		# Carrega o vetor de fun��es temporiamente
	slli t2, t2, 2		# Multiplica o indice por 4
	add t0, t0, t2		# Faz o deslocamento v[i]
	li t1, 3		# Carrega 3 para comparar as op��es inserir e remover
	ble a0, t1, ins_rmv	# Se op��es <= 3 a fun��o recebe a1 e a0
	li t1, 4		# Carrega 4 para comparar fun��o estat�stica
	beq a0, t1, load_head	# Se op��es = 4 a fun��o recebe a0
	j chama_func		# se op��es = 5 a fun��o n�o recebe par�metro 

invalido:
	la a0 txt_invalido	# Salva a mensagem "inv�lida" para retorno
	j volta_loop		# Vai para o label printar a mensagem e voltar para o loop
	
ins_rmv:
	li a7, 4		# Comando para PrintString
	la a0, txt_input	# Coloca a mensagem de input para ser exibida
	ecall			# Chama OS para exibir
	li a7, 5		# Comando para ReadInt
	ecall			# Chama OS
	mv a1, a0		# Move o valor para a1
	
load_head:
	la a0, head		# Carrega o head em a0
	
chama_func:
	lw t1, 0(t0)		# Carrega o fun��o
	jalr t1			# Chama a fun��o
	
volta_loop:
	li a7, 4		# Comando para PrintString
	ecall			# Chama OS
	j loop_menu		# Volta para o loop

fim:
	li a0, 0		# Coloca 0 no retorno do programa
	li a7, 93		# Comando para encerrar programa
	ecall			# Chama OS

#################################################################
# Fun��o: int insere_inteiro(int *head, int valor)		#
#   Adiciona na arvore						#
#   e atualiza a estat�stica numeros inseridos			#
# entrada: a0 - ponteiro head					#
#	   a1 - valor						#
# saida: retorna o inteiro inserido				#
#################################################################

insere_inteiro:
	lw t0, 0(a0)		#carrego o endere�o do ponteiro head
	mv t1, a0		#coloco em t1
	beqz t0, insere_no	# se o ponteiro for 0, ele nulo
procura_fim:
	mv t1, t0 	#move t0 para t1 para ter o ponteiro anterior
	addi t1, t1, 4	#soma 4 pq o endere�o est� na 2� parte
	lw t0, 4(t0)	#coloca em t0 o proximo endere�o
	bnez t0, procura_fim	#se for diferente de nulo, continua procurando
insere:
	li a7, 9
	li a0, 8
	ecall
	sw a0, 0(t1)	#coloca no ponteiro o valor da proxima memoria
	sw a1, 0(a0)	
	la a0, txt_inserido
	ret
	
#################################################################
# fun��o: int remove_por_indice(int *head, int indice);  	#
#   remove um elemento da lista pelo indice			#
#   e atualiza a estat�stica numeros removidos			#
# entrada: a0 - ponteiro head					#
#	   a1 - valor						#
# saida: retorna o valor removido ou exce��o			#
#################################################################

remove_por_indice:
	la a0, txt_removido
	ret
	
#################################################################
# fun��o: int remove_por_valor(int *head, int valor)		#
#   remove um elemento da lista pelo valor			#
#   e atualiza a estat�stica numeros removidos			#
# entrada: a0 - ponteiro head					#
#	   a1 - valor						#
# saida: retorna o indice do removido ou exce��o		#
#################################################################

remove_por_valor:
	la a0, n_implementado
	ret
	
#################################################################
# fun��o: void imprime_lista(int *head)				#
#   Imprime a lista						#
# entrada: a0 - ponteiro head					#
#################################################################

imprime_lista:
	la a0, n_implementado
	ret
	
#################################################################
# fun��o: void estatistica()					#
#   Exibe as estat�sticas, maior n�mero, menor n�mero,		#
#   quantidade de elementos, quantidade inserida e removida	#
#################################################################

estatistica:
	la a0, n_implementado
	ret
