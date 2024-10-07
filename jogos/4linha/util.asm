	.data
txt_input_inv:	.string "Opção inválida!\n"

.global input
	.text
	#########################################################
	# int input( char* menu, int qtdop)			#
	# Entrada: 						#
	#	ao = endereço da string menu			#
	#	a1 = quantidade de opções			#	
	# Saida:						#
	#	ao = opção selecionada				#
	#########################################################							
input:
	mv t0, a0
	li a7, 4
	ecall
	li a7, 5
	ecall

	blez a0, erro
	bgt a0, a1, erro		
	ret
erro:
	la a0, txt_input_inv
	li a7, 4
	ecall
	mv a0, t0
	j input	
