#-------- fun��o set_vector() -----------------------
.globl set_vector
.text

set_vector:
	mv t0, zero
	mv t1, a0
	mv t2, a1
	slli a1, a1, 3
for:
	li a0, 3
	beq t0, t2, fim
	li a7, 42
	ecall
	sw a0, 0(t1)
	addi t0, t0, 1
	addi t1, t1, 4
	j for
fim:
	ret
