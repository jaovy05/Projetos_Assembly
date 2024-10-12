	.data
	
menuS:	.ascii "\n*** CONFIGURAÇÃO ***\n\n"
	.ascii "1 - Quantidade de jogadoers\n"
	.ascii "2 - Tamanho do tabuleiro\n"
	.ascii "3 - Modo de dificuldade\n"
	.ascii "4 - Zerar contadores\n"
	.ascii "5 - Mostrar as configuracoes atuais e o valor dos contadores\n"
	.ascii "6 - Mudar nome dos jogadores\n"
	.asciz "7 - Voltar ao menu\n"

txt_qtd:	.string "Digite a quantidade de jogadores (1 ou 2)\n"
txt_tabul:	.string "Digite 1 para 7x6 ou 2 para 9x6:\n"
txt_mode:	.string "Digite 1 para fácil ou 2 para médio"
txt_player1:	.string "\nDigite o nome do jogador 1: "
txt_player2:	.string "\nDigite o nome do jogador 2: "

config_tabul0:	.string	"\nTabuleiro: "
config_tabul1:	.string "x6\n"
config_qtd0:	.string "Possui "
config_qtd1:	.string " pessoa(s) jogando\n"
config_diff1:	.string "Dificuldade: fácil\n"
config_diff2:	.string "Dificuldade: médio\n"
config_player:	.string	" - vitória(s): "
config_robo:	.string	"Robo - vitória(s): "

.global config
	.text
	# s0 = registrador qtd player
	# s1 = registrador tam tabuleiro
	# s2 = dificuldade 
	# s3 = win p1
	# s4 = win p2
	# s5 = win robo
	# s6 = jogador atual
	# s7 = jogadas faltando
		
	#########################################################
	# void config( char* p1)				#
	# Entrada: 						#
	#	a2 = endereço da string p1			#
	#########################################################	
config:
	addi sp, sp, -4
	sw ra, 0(sp)

config_menu:
	la a0, menuS
	li a1, 7
	call input	# ret em a0 o valor do input
	
	beq a0, a1, retorno_main
	li a1, 6
	beq a0, a1, in_name
	li a1, 5
	beq a0, a1, out_config
	li a1, 4
	beq a0, a1, clear
	li a1, 3
	beq a0, a1, mode
	li a1, 2
	beq a0, a1, tabuleiro	
qtd_jogadores:
	la a0, txt_qtd
	li a1, 2
	jal input
	
	mv s0, a0
	j config_menu
tabuleiro:
	la a0, txt_tabul
	li a1, 2
	jal input
	# a0 = 2 | 10 and 10 = 10
	# a0 = 1 | 01 and 10 = 00
	and a0, a0, a1	# se o retorno for 1 vai zerar, se for 2 fica 2
	addi s1, a0, 7	# 0 + 7 = 7 colunas e 2 + 7 = 9
	j config_menu
mode:
	la a0, txt_mode
	li a1, 2
	jal input
	
	mv s2, a0
	j config_menu	
clear:
	mv s3, zero	# zera win_p1
	mv s4, zero	# zera win_p2
	mv s5, zero	# zera robo
	j config_menu
	
out_config:
	li a7, 4
	la a0, config_tabul0
	ecall
	li a7, 1
	mv a0, s1
	ecall
	li a7, 4
	la a0, config_tabul1
	ecall
	
	la a0, config_qtd0
	ecall
	li a7, 1
	mv a0, s0
	ecall
	li a7, 4
	la a0, config_qtd1
	ecall
	
	mv a0, a2
	ecall
	la a0, config_player
	ecall
	li a7, 1
	mv a0, s3
	ecall
	li a7, 11
	li a0, '\n'
	ecall
	
	li a7, 4
	li t0, 1
	beq t0, s0, out_conf_robo	
	
	addi a0, a2, 21 # player 2 está 21 bytes dps do jogador 1
	ecall
	la a0, config_player
	ecall
	li a7, 1
	mv a0, s4
	ecall
	li a7, 11
	li a0, '\n'
	ecall
	j config_menu
out_conf_robo:
	la a0, config_robo
	ecall
	li a7, 1
	mv a0, s5
	ecall
	li a7, 11
	li a0, '\n'
	ecall
	
	beq t0, s2, out_conf_facil
	
	li a7, 4
	la a0, config_diff2
	ecall
	j config_menu
out_conf_facil:
	li a7, 4
	la a0, config_diff1
	ecall
	j config_menu
in_name:	
	la a0, txt_player1
	li a7, 4
	ecall
	
	li a7, 8
	li a1, 21
	mv a0, a2
	ecall
	
	jal remove_quebra
	
	li t0, 1
	beq s0, t0, config_menu
	
	la a0, txt_player2
	li a7, 4
	ecall
	
	li a7, 8
	addi a0, a2, 21
	ecall
	
	jal remove_quebra
	j config_menu
retorno_main:
	lw ra, 0(sp)
	addi sp, sp, 4
	ret

	#########################################################
	# void remove_quebra( char* p1)				#
	# Entrada: 						#
	#	a0 = endereço da string p1			#
	#########################################################
remove_quebra:
	mv t0, a0

for:
	lb t1, 0(t0)
	addi t0, t0, 1
	bnez t1, for
	sb zero, -2(t0)	# -1 do incremento e -1 para a penultimapos
	ret