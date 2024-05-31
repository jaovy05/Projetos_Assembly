#-------- função set_vector() -----------------------
.globl set_vector
.data

.text


set_vector:
    mv t0, zero
    mv t1, a0

for:
    li a0, 3
    beq t0, a1, fimf
    li a7, 42
    ecall
    sw a0, 0(t1)
    addi t0, t0, 1
    addi t1, t1, 4
    j for

fimf:
    ret