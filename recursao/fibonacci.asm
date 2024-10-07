.global fibonacci
.text
fibonacci:
	li t0, 2
	ble a0, t0, fim        # se a entrada for menor que 2 retorna 1 

	addi sp, sp, -12       # empilha 3 posi��es de mem�ria
	sw a0, 8(sp)           # salva a0 na pilha
	sw ra, 4(sp)           # salva ra na pilha
	sw a1, 0(sp)           # salva s0 na pilha

	addi a0, a0, -1        # a0 = a0 - 1
	jal fibonacci          # chamada recursiva fibonacci(n-1)
	mv a1, a0              # salva o resultado de fibonacci(n-1) em s0

	lw a0, 8(sp)           # restaura o valor original de a0
	addi a0, a0, -2        # a0 = a0 - 2
	jal fibonacci          # chamada recursiva fibonacci(n-2)

	add a0, a0, a1         # soma os resultados de fibonacci(n-1) e fibonacci(n-2)

	lw ra, 4(sp)           # restaura ra da pilha
	lw a1, 0(sp)           # restaura s0 da pilha
	addi sp, sp, 12        # ajusta a pilha de volta

	ret                    # retorna

fim:
	li a0, 1               # retorna 1 para fibonacci(0) e fibonacci(1)
	ret
