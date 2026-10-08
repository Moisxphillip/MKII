##########
# funcoes a serem chamadas sao:
# - PlayerPerdeHP
# - EnemyPerdeHP
# ambas precisam receber o endereco onde
# o valor referencial inicial foi guardado
# atraves de a0. Nao retornam nada
##########
# - IsPlayerDead
# - IsEnemyDead
# retornam 1 em a0 caso o personagem tenha morrido.
# nao requerem argumento.
##########

PlayerPerdeHP:
	lw t4 (a0) #le o valor de hp anterior
	addi t4, t4, 8
	sw t4 (a0) #guarda valor atualizado
	li t1, 7704 # quadrado onde comeca a barra sup esq
	li t6, 0x07070707 # word com 4 valores de vermelho
	add t5, t4, t1 #soma o ponto inicial ao endereco inicial do bmpdsp
	addi t1, zero, 8#loops (linhas) a serem preenchidas
PlayerHPFrame0:
	addi t1, t1, -1# desce 1 no loop
	sw t6, (t5)#guarda a word de vermelhos na tela
	addi t5, t5, 4 #anda 4 bytes no endereco em t4
	sw t6, (t5)#guarda a word de vermelhos na tela
	addi t5, t5, 316#pula pra linha abaixo
	bne t1, zero, PlayerHPFrame0 #segue o loop ate pintar todas as linhas
	li t0, 0xFD7E8
	add t5, t5, t0 #salta pro inicio do frame 1
	addi t1, zero, 8 # reseta o counter pra prox funcao
	li t3, 7704 # vai pro quadrado onde comeca a barra sup esq
	add t5, t5, t3
PlayerHPFrame1:
	addi t1, t1, -1#desce 1 no loop
	sw t6, (t5)#guarda a word de vermelhos na tela
	addi t5, t5, 4 #anda 4 bytes no endereco em t4
	sw t6, (t5)#guarda a word de vermelhos na tela
	addi t5, t5, 316#pula pra linha abaixo
	bne t1, zero, PlayerHPFrame1 #segue o loop ate pintar todas as linhas
	ret #retorno ao codigo principal

#######################################################
EnemyPerdeHP:
	lw t4 (a0) #le o valor de hp anterior
	addi t4, t4, -8
	sw t4 (a0) #guarda valor atualizado
	li t1, 7988 # quadrado onde comeca a barra sup esq
	add t5, t4, t1 #soma o ponto inicial ao endereco inicial do bmpdsp
	li t6, 0x07070707 # word com 4 valores de vermelho
	addi t1, zero, 8#loops (linhas) a serem preenchidas
	
EnemyHPFrame0:
	addi t1, t1, -1# desce 1 no loop
	sw t6, (t5)#guarda a word de vermelhos na tela
	addi t5, t5, -4 #anda 4 bytes no endereco em t4
	sw t6, (t5)#guarda a word de vermelhos na tela
	addi t5, t5, 324#pula pra linha abaixo
	bne t1, zero, EnemyHPFrame0 #segue o loop ate pintar todas as linhas
	li t0, 0xFD6D4
	add t5, t5, t0 #salta pro inicio do frame 1
	addi t1, zero, 8 # reseta o counter pra prox funcao
	li t3, 7980 # vai pro quadrado onde comeca a barra sup esq
	add t5, t5, t3
EnemyHPFrame1:
	addi t1, t1, -1# desce 1 no loop
	sw t6, (t5)#guarda a word de vermelhos na tela
	addi t5, t5, -4 #volta 4 bytes no endereco em t4
	sw t6, (t5)#guarda a word de vermelhos na tela
	addi t5, t5, 324#pula pra linha abaixo
	bne t1, zero, EnemyHPFrame1 #segue o loop ate pintar todas as linhas
	ret #retorno ao codigo principal
###############################

IsPlayerDead:
	li t1, 0xFF001E76 #posicao do bmpdsp onde acaba a barra de vida
	lb t4,(t1) #Le byte
	addi t4, t4, -7
	beq t4, zero, PDead #se o byte continha "7", player morreu
	add a0, zero, zero #no murio
	ret
PDead:
	addi a0, zero, 1 #murio :(
	ret

IsEnemyDead:
	li t1, 0xFF001EC8 #posicao do bmpdsp onde acaba a barra de vida
	lb t4,(t1) #Le byte
	addi t4, t4, -7
	beq t4, zero, EDead #se o byte continha "7", enemy morreu
	add a0, zero, zero #no murio
	ret
EDead:
	addi a0, zero, 1 #murio :(
	ret
