		.data
vetor:		.space 200
tam:		.asciz "Digite o tamanho do vetor (maximo 50):\n" 
digite:		.ascii "Digite o "
numero:		.ascii "01"
dovetor:	.asciz "° número: "

		.text
main:
	jal set_vector #faz um jump para função set_vector
	la a0, vetor
	jal selection_sort #faz um jump para função buble_sort
	jal print #faz um jump para função print

fim:
	li a7, 93 #realiza uma chamada de sistema com código 93(encerra programa)
	li a0, 0 #encerra o programa com 0
	ecall
	
#---------- função bubbleSort(*v, n) --------

selection_sort:
	mv s1, a1 		#cópia o tamanho para s1
	addi s1, s1, -1 	#subtraindo 1 do valor de s1
	mv t0, zero 		# int i = 0
	
for0:
	beq t0, s1, fim_func
	mv t1, t0 		# coloca o valor da variavel temporaria em t1
	addi t2, t0, 1		# variavel de controle j = i + 1
	lw s0, 0(a0)
for1:
	beq t2, a1, troca
	
#-------- função printf(*v, n) ---------------

print:
	la t0, vetor #insere o valor do primeiro endereço de memória do vetor no registrador t0
	mv t1, zero #insere o valor zero no registrador t1
	
for_print:
	#condicao
	bge t1, a1, fim_func #verifica se t1 >= a1, caso seja verdadeiro vai para fim_func
	#laço
	li a7, 1 #chamada de sistema de código 1 (printar inteiro)
	lw a0, (t0) #carrega o valor do t0 e insere em a0
	ecall 
	
	li a7, 11 #chamada de sistema de código 11 (printa um caracter)
	li a0, 32 #coloca o codigo de espaço para ser impresso 
	ecall 
	#incrementar
	addi t0, t0, 4
	addi t1, t1, 1
	j for_print	
	
#-------- função set_vector() -----------------------

set_vector:
	li a7, 4 #chamada de sistema de código 4 (printar string)
	la a0, tam #insere o valor do primeiro endereço de memória que está o vetor tam no registrador a0 
	ecall
	
	li a7, 5 #chamada de sistema de código 5 (ler um inteiro)
	ecall
	mv a1, a0 #coloca o valor do inteiro que está em a0 no registrador a1
	la t0, vetor #insere o valor do primeiro endereço de memória do vetor no registrador t0
	mv t1, zero #o registrador t1 ta recebendo o valor 0
	
for_set_vector:
	bge t1, a1, fim_func #verifica se t1 >= a1, caso seja verdadeiro vai para fim_func
	
	li a7, 4 #chamada de sistema de código 4 (printar string)
	la a0, digite #insere o valor do primeiro endereço de memória que está o vetor digite no registrador a0 
	ecall
	
	li a7, 5 #chamada de sistema de código 5 (ler um inteiro)
	ecall
	#pega o numero digitado e coloca no vetor
	sw a0, 0(t0)
	
	mv t6, ra
	jal incrementar
	mv ra, t6
	
	addi t0, t0, 4 #soma 4 no registrador t0
	addi t1, t1, 1 #soma 1 no registrador t1
	
	j for_set_vector #faz um jump na função for set_vector
	
#----------------------------- FUNÇÃO INCREMENTAR ------------------------------------------

incrementar:
	la t2, numero #insere o valor do primeiro endereço de memória do vetor numero no registrador t2
	lb t3, 1(t2) #o registrador t3 recebe a unidade 
	addi t3, t3, 1 #soma 1 ao valor do registrador t3
	li t4, 58 #58 é o proximo valor de 9 na tabl
	beq t3, t4, zerar #se t3 = t4 então t3 estorou os inteiros da tabela ascii (0 - 9)
	sb t3, 1(t2) #coloca a unidade no respectivo endereço
	ret #fim da função

zerar:
	addi t3, t3, -10 #agora t3 volta 10 caracteres na tabela ascii (t3 = 0)
	lb t4, 0(t2) #o registrador t4 recebe a dezena
	addi t4, t4, 1 #soma 1 à dezena
	sb t3, 1(t2) #coloca a unidade no respectivo endereço
	sb t4, 0(t2) #coloca a dezena no respectivo endereço
	
fim_func:
	ret #retorna ao endereço de memória que esta no registrador ra

