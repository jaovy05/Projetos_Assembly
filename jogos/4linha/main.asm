	.data

matriz:	.space 54
menuP:	.ascii "\n\n*** MENU ***\n\n"
	.ascii "1 - Configuração\n"
	.ascii "2 - Jogar\n"
	.asciz "3 - Sair\n"
	
txt_in_erro:	.string "Input invalido! Digite um valor com uma opção correspondente"
txt_jogada:	.string	" faça a sua jogada: "
txt_win:	.string " Venceu!!\n"
txt_empate:	.string "\nEmpate!!"

txt_comeca:	.ascii  "Quem começa?\n"
txt_comecaP:	.ascii	"1) Player\n"
txt_comecaR:	.asciz	"2) Robo\n"

player1:	.string "Jogador 1\01234567890"
player2:	.string "Jogador 2\01234567890"

robo0:	.string "Héstia"
robo1:	.string "Teseu"
robo2:	.string "Ares"
robo3:	.string "Atena"
robo4:	.string "Caos"

	.text	
	# s0 = registrador qtd player
	# s1 = registrador tam tabuleiro
	# s2 = dificuldade 
	# s3 = win p1
	# s4 = win p2
	# s5 = win robo
	# s6 = jogador atual
	# s7 = jogadas faltando
start:
	li s0, 1
	li s1, 7
	li s2, 0
	li s3, 0
	li s4, 0
	li s5, 0
main:	
	la a0, menuP
	li a1, 3
	call input	#Chama função para processar input
	
	beq a0, a1, sair
	li a1, 2
	beq a0, a1, jogar
	la a2, player1
	call config
	j main
robo:
	jal joga_robo
	j verificando_acerto
jogar:
	la a0, matriz
	mv a1, s1
	jal inicia_tabuleiro #jogar 
	li s6, 1
	bne s0, s6, partida	# Se for 1 jogador, pergunta quem começa
	
	la a0, txt_comeca
	li a1, 2
	call input
	
	beq a0, s6, partida
	li s6, 2
partida:
	beqz s7, empate
	la a0, matriz
	mv a1, s1
	jal imprime_tabuleiro
	li t0, 1
	li a7, 4
	beq t0, s6, p1joga
	beq t0, s0, robo
	la a0, player2
	j pede_jogada
p1joga:
	la a0, player1
pede_jogada:
	ecall
	la a0, txt_jogada
	mv a1, s1
	jal input
	addi a0, a0, -1

jogando:
	mv a4, a0		# Move a coluna jogada para o verifica_vencedoreea
	mv a3, s6
	la a2, matriz
	jal insere
	bnez a0, partida	
	mv s10,	a1		# refatorar salva a ultima jogada do p1
	mv s11, a4
verificando_acerto:
	la a0, matriz
	mv a3, a1
	mv a1, s1
	mv a2, s6
	li a5, 4
	jal verifica_vencedor

	beqz a0, fimpartida
	xori s6, s6, 3
	addi s7, s7, -1
	j partida
fimpartida:
	la a0, matriz
	mv a1, s1
	jal imprime_tabuleiro
	li t0, 2
	beq s6, t0, winJ2
	addi s3, s3, 1
	la a0, player1
	j venceu
winJ2:
	la a0, player2
	beq s0, t0, soma_winj2
	addi s5, s5, 1
	j venceu
soma_winj2:
	addi s4, s4, 1
venceu:
	li a7, 4
	ecall
	la a0, txt_win
	ecall
	j main
empate:
	la a0, txt_empate
	li a7, 4
	ecall
	j main
sair:
	li a0, 0 #sair
	li a7, 93
	ecall			
	#########################################################
	# void inicia_tabuleiro(int *matriz_jogo, int colunas)	#
	# Entrada: 						#
	#	ao = endereço da matriz				#
	#	a1 = quantidade de colunas			#
	#########################################################
inicia_tabuleiro:
	li t1, 6
	mul a1, a1, t1
	mv s7, a1
	li t0, 0
	li t1, '_'
loop_clear:
	beq a1, t0, end_func
	sb t1, (a0)
	addi t0, t0, 1
	addi a0, a0, 1
	j loop_clear	
end_func:
	ret	
	#########################################################
	# void imprime_tabuleiro(int *matriz_jogo, int colunas)	#
	# Entrada: 						#
	#	ao = endereço da matriz				#
	#	a1 = quantidade de colunas			#
	#########################################################
imprime_tabuleiro:
	li t1, 6
	mv t3, a0
	li t0, 0
	li t2, 0
for_1linha:
	beq a1, t0, end_line
	addi t0, t0, 1
	li a7, 1
	mv a0, t0
	ecall
	li a7, 11
	li a0, ' '
	ecall
	j for_1linha
for_print:
	bgt t2, t1, end_print
	lb a0, (t3)
	ecall
	li a0, ' '
	ecall
	
	addi t0, t0, 1
	addi t3, t3, 1
	bne a1, t0, for_print	
end_line:
	li t0, 0
	li a0, '\n'
	ecall
	addi t2, t2, 1
	j for_print
end_print:
	li a0, '\n'
	ecall
	ret
	#########################################################################
	# int insere(int coluna,int colunasTotais, char* matriz, int jogador)	#
	# Entrada:								#
	#	a0 coluna jogada						#
	#	a1 colunas totais						#
	#	a2 matriz							#
	#	a3 jogador atual						#
	# Saida:								#
	#	a0 0 se deu para inserir e -1 se erro				#
	#       a1 = linha jogada						#
	#########################################################################
insere:
	li t1, 5	# numero de linhas para descer 
	add t0, a2, a0	# desloca para a coluna certa
	mul t3, t1, a1	# multiplica pelo numero de colunas
	add t0, t0, t3	# soma no vetor para encontrar a ultima linha
	li t3, 0	# para comparar se ele chegiy no final do vetor
	li t4, '_'	# para comparar se a posição est livre
for_insere:
	blt t1, t3, erro_func	# Verifica se há espaço vago na coluna
	lb t2, (t0)		# Carrega o elemento atual
	beq t4, t2, sucess_func	# Verifica se está livre
	sub t0, t0, a1		# Subtrai uma linha
	addi t3, t3, 1		# soma o contador em 1
	j for_insere
sucess_func:
	sub a1, t1, t3
	li t3, 34		# carrega 34
	add t3, t3, a3		# soma no numero do jogador 35 = # e 36 = $
	sb t3, (t0)		# coloca na memoria
	li a0, 0		# retorna sucesso
	ret			
erro_func:
	li a0, -1		# retorna erro
	ret
	#################################################################################################################
	# int verifica_vencedor(int *matriz_jogo, int colunas, int jogador, int coluna jogada, int linha jogada)	#
	# Entrada:													#
	#	a0 matriz_jogo												#
	#	a1 colunas do jogo											#
	#	a2 jogador												#
	#	a4 coluna jogada											#
	#	a3 linha jogada												#
	#	a5 quantas linhas verifica										#										#
	# Saida:													#
	#	a0 1 se deu certo e -1 se deu errado									#
	#	a1 jogador												#
	#################################################################################################################
verifica_vencedor:
	sw ra, -4(sp)
	addi sp, sp, -4
	mv t3, a3
	mv a3, a5
	
	mul t0, a1, t3		# Multiplica as colunas totais com linha jogada para dar o salto
	add t0, t0, a0		# Soma o salto da linha com a matriz
	addi a2, a2, 34		# Soma 34 no jogador para conseguir seu respectivo caracter

	mv a5, t0		# Vai conferir se a linha bateu
	li a6, 1		# conferir somente 1 pos cada vez
	mv a7, a1
	jal sequencia
	beqz a6, ganhou

	li t1, 2		# Se a linha for maior que 2, não forma 4 em linha
	bgt t3, t1, diagonal
	
	add t0, t0, a4		# Agora faz o salto para a coluna 
	
	mv a5, t0
	mv a6, a1
	li a7, 4

	jal sequencia
	beqz a6, ganhou 

diagonal:	
	add t2, a4, t3
	addi a6, a1, -1
	neg a6, a6
	
	li t1, 5	
	bgt t2, t1, calcula_coluna
	
	mul a5, a1, t2		# Multiplica as colunas totais com a soma para dar o salto
	add a5, a5, a0		# soma o salto no vetor para dar a posição correta 
	mv a7, t2
	
	jal sequencia
	beqz a6, ganhou 
	j diagonal_inversa
	
calcula_coluna:
	mul a5, a1, t1	
	
	addi t1, t2, -5
	add a5, a5, a0
	add a5, a5, t1
	sub a7, a1, t1
	
	jal sequencia
	beqz a6, ganhou
	
diagonal_inversa:
	sub t2, t3, a4
	addi a6, a1, 1
		
	bltz t2, calcula_coluna_inversa
	
	mul a5, a1, t2		# Multiplica as colunas totais com a soma para dar o salto
	add a5, a5, a0		# soma o salto no vetor para ir para a linha correta 
	li a7, 6
	sub a7, a7, t2
	
	jal sequencia
	beqz a6, ganhou 
	
calcula_coluna_inversa:
	sub a5, a0, t2
	mv a7, a1
	add a7, a7, t2
	
	jal sequencia
	mv ra, s11
	bnez a6, sem_sequencia 
ganhou:
	li a0, 0
	addi a1, a2, -34
	j end
sem_sequencia:
	li a0, -1
end:
	lw ra, 0(sp)
	addi sp, sp, 4
	ret
	#################################################################################
	# int sequencia(int jogador, i sequencia, i* posição, i soma,i casas procuradas	#
	# Entrada:									#
	#	a2 jogador								#
	#	a3 numero de elementos da sequecia					#
	#	a5 posição de inicio							#
	#	a6 distancia entre as comparacoes					#
	#	a7 casas procuradas							#
	# Saida:									#
	#	a6 0 se deu certo e -1 se deu errado					#
	#	a2 jogador								#
	#	a5 posicao do elemento							#
	#################################################################################	
sequencia:
	mv t1, a3
forfind:
	beqz t1, end_seq
	beqz a7, sequencia_nao_encontrada
	
	lb t2, (a5)
	add a5, a5, a6
	
	addi t1, t1, -1
	addi a7, a7, -1
	
	beq a2, t2, forfind
	j sequencia
sequencia_nao_encontrada:
	li a6, -1
	ret
end_seq:
	li a6, 0
	ret
	#########################################################
	# Joga robo 						#
	# Entrada						#
	#	a0  robo					#
	#	s1  tamanho do tabuleiro			#
	#	s11 coluna jogada pelo player			#
	#	s10 linha  jogada pelo player			#
	# Saida:						#
	#	a1 tamanho do tabuleiro				#
	#########################################################
joga_robo:
	sw ra, -4(sp)
	addi sp, sp, -4
	beqz a0, seleciona_facil
	
	la a0, matriz
	mv a1, s1
	li a2, 1
	mv a3, s10
	mv a4, s11
	li a5, 3
	jal verifica_vencedor
	bnez a6, seleciona_facil
	
	la a2, matriz
	sub a5, a5, a2
	rem a0, a5, s1
	
	mv a4, a0		# Move a coluna jogada para o verifica_vencedoreea
	mv a1, s1
	li a3, 2
	jal insere 
	bnez a0, seleciona_facil

	j fim_select
seleciona_facil:
	addi a1, s1, -1
	li a7, 42
	ecall
	mv a4, a0		# Move a coluna jogada para o verifica_vencedoreea
	mv a1, s1
	la a2, matriz
	li a3, 2
	jal insere 
	bnez a0, seleciona_facil
fim_select:
	lw ra, (sp)
	addi sp, sp, 4
	ret

	
	
	
