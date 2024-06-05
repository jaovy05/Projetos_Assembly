#------------- Quick Sort -------------
# a0 = vetor, a1 = inicio, a2 = fim
quick_sort:
	bge a2, a1, fim
	mv s0, a0
	call particiona
	jal quick_sort
	jal quick_sort
fim: 
	ret