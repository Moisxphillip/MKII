#  struct player
#{
#	int personagem;
#	int x, y;
#	function action;
#       int* sprite;
#	int lastx, lasty;
#	int "hitbox"	
#	int* vida
#	int reversed
#	int hitstun/actionframe 
# }
.text
FIGHT: #void FIGHT(int player) a0 -> a0
	addi sp, sp, -100
	sw ra, 0(sp)
	
	 #inicio de carregamento de cenario
	la t0, IAATUAL
	lw t0, 0(t0)
	li t1, 4
	mul t0, t0, t1
	
	la t1, ENEMYARRAY
	add t0,t0 , t1
	lw t0, 0(t0)
	
	mv s0, t0
	
	li t1, 76808
	
	mul t0, t0, t1
	la t1, bgtree
	add t0, t0, t1 
	
	sw t0, 4(sp) #termino de carregamento de cenario
#		-----inicializando player-----	
	la t0, PLAYERADDRESS
	addi t1, sp, 8
	sw t1, 0(t0)

	sw a0, 8(sp) #personagem
	
	li a0, -40
	sw a0, 12(sp) #x

	li a0, 85
	sw a0, 16(sp)	#y
	
	sw zero, 20(sp) # action
	sw zero, 24(sp) #Sprite
	
	li a0, -40
	sw a0, 28(sp) #lastx
	
	li a0, 85
	sw a0, 32(sp) #lasty
	
	sw zero, 36(sp) #hitbox
	
	li a0, 0xFEFFFFF8
	sw a0, 40(sp) #vida
	
	sw zero, 44(sp) #reversed
	
	sw zero, 48(sp) #hitstun | performing action
	
#		-----------inicializando inimigo-------------	
	la a0, ENEMYADDRESS
	addi t0, sp, 52
	sw t0, 0(a0)
	
	sw s0, 52(sp) #personagem
	
	li a0, 232
	sw a0, 56(sp) #x

	li a0, 85
	sw a0, 60(sp)	#y
	
	sw zero, 64(sp) # action
	
	sw zero, 68(sp) #Sprite
	
	li a0, 272
	sw a0, 72(sp) #lastx
	
	li a0, 85
	sw a0, 76(sp) #lasty
	
	sw zero, 80(sp) #hitbox
	
	li a0, 0xFEFFFFF8
	sw a0, 84(sp) #vida
	
	li a0, 1
	sw a0, 88(sp) #reversed
	
	sw zero, 92(sp) #hitstun | performing action
	
	la a0, IAATUAL
	lw a0, 0(a0)
	call gameplan
	sw a0, 96(sp)
	
#	---------Carregando cenarios---------------
	lw a0, 4(sp)
	mv a1, zero
	call loadbackground
	
	la a0, fight_hud
	mv a1, zero
	call loadbackground
	
	lw a0, 4(sp)
	li a1, 1
	call loadbackground
	
	la a0, fight_hud
	li a1, 1
	call loadbackground
#	---------terminou de inicializar------------
	la a0, ingameKEY
	call HabilitarINT
FIGHTLOOP:	
	
	la a0, PLAYERADDRESS
	lw a0, 0(a0)
	la a1, ENEMYADDRESS
	lw a1, 0(a1)
	
	lw t1, 96(sp)
	jalr t1
	
	la a0, PLAYERADDRESS
	lw a0, 0(a0)
	mv a1, zero
	call ManageAction  #acao do jogador
	
	la a0, ENEMYADDRESS
	lw a0, 0(a0)
	li a1, 1
	call ManageAction #acao da I.A
	
	lw a0, 4(sp)
	la a1, PLAYERADDRESS
	lw a1, 0(a1)
	la a2, ENEMYADDRESS
	lw a2, 0(a2)
	
	call newframe #printa tudo necessario na tela
	
	
	la a0, PLAYERADDRESS
	lw a0, 0(a0)
	la a1, ENEMYADDRESS
	lw a1, 0(a1)
	
	call calchitbox #checa a hitbox
	
	la a0, PLAYERADDRESS
	lw a0, 0(a0)
	la a1, ENEMYADDRESS
	lw a1, 0(a1)
	
	call checkreverse #inverte os frames caso necessario
	
	call IsEnemyDead
	
	bnez a0, GANHASTEKKK
	
	call IsPlayerDead
	
	bnez a0, PERDESTEKKK
	
	j FIGHTLOOP
#--------------POST FIGHT------------------------#
#--------------GANHOU O ROUND-------------------#
GANHASTEKKK:	
	la a0, msg_finish
	li a1, 96
	li a2, 40
	li a3, FRAMESET
	lw a3, 0(a3)
	call sprite
	
	la a0, kitana_hit
	la a1, ENEMYADDRESS
	lw a1, 0(a1)
	lw a1, 0(a1)
	call calcsprite
	
	la a1, ENEMYADDRESS
	lw a1, 0(a1)
	sw a0, 16(a1)
#--------bate no adversario -----------#
GANHASTEKKKLOOP:	
	
	la a0, PLAYERADDRESS
	lw a0, 0(a0)
	mv a1, zero
	call ManageAction  #acao do jogador
	
	lw a0, 4(sp)
	la a1, PLAYERADDRESS
	lw a1, 0(a1)
	la a2, ENEMYADDRESS
	lw a2, 0(a2)
	
	call newframe #printa tudo necessario na tela
	
	la a0, PLAYERADDRESS
	lw a0, 0(a0)
	la a1, ENEMYADDRESS
	lw a1, 0(a1)
	
	call calchitbox #hitbox checker
	beqz a0, GANHASTEKKKLOOP
	
	csrrci zero, 0, 1 #desativar o keyboard 
#-----------apaga mensagem de FINISH-----------#	
	lw a0, 4(sp)
	la a1, msg_finish
	li a2, 96
	li a3, 40
	li a4, FRAMESET
	lw a4, 0(a4)
	call clearsprite 
#------------Printa mensagem de FATALITY-----------#	
		
	la s10, ENEMYADDRESS 
	lw s10, 0(s10)
	
	la a0, kitana_dead
	lw a1, 0(s10)
	call calcsprite
	
	la s10, ENEMYADDRESS 
	lw s10, 0(s10)
	sw a0, 16(s10)
	
	la s11, PLAYERADDRESS
	lw s11, 0(s11)
	
	la a0, kitana_win1
	lw a1, 0(s11)
	call calcsprite
	sw a0, 16(s11)
	
	la a0, msg_fatality
	li a1, 96
	li a2, 40
	li a3, FRAMESET
	lw a3, 0(a3)
	call sprite
	
	la a0, msg_fatality
	li a1, 96
	li a2, 40
	li a3, FRAMESET
	lw a3, 0(a3)
	xori a3, a3, 1
	call sprite
	
	lw a0, 4(sp)
	mv a1, s11
	mv a2, s10
	
	call newframe

	lw a0, 4(sp)
	mv a1, s11
	mv a2, s10
	
	call newframe

#---------musica de vitoria---------------#
	li a0,47		# define a nota
	li a1,120		# define a duracao da nota em ms
	li a2,106		# Seta o som de tiro
	li a3,90		# define o volume
	li a7,33		# define o syscall
	ecall			# toca a nota
	li a0,54		# define a nota
	li a1,120		# define a duracao da nota em ms
	li a2,106		# Seta o som de tiro
	li a3,90		# define o volume
	li a7,33		# define o syscall
	ecall			# toca a nota
	li a0,50		# define a nota
	li a1,2300		# define a duracao da nota em ms
	li a2,106		# Seta o som de tiro
	li a3,90		# define o volume
	li a7,33		# define o syscall
	ecall			# toca a nota
	li a0,44		# define a nota
	li a1,2000		# define a duracao da nota em ms
	li a2,106		# Seta o som de tiro
	li a3,90		# define o volume
	li a7,33		# define o syscall
	ecall			# toca a nota
#------------------------prox sprite de vitoria------------------#	
	la s11, PLAYERADDRESS
	lw s11, 0(s11)
	
	la a0, kitana_win2
	lw a1, 0(s11)
	call calcsprite
	sw a0, 16(s11)
	
	lw a0, 4(sp)
	mv a1, s11
	mv a2, s10
	
	call newframe
	
	li a0, 1
	j SAIRFIGHT
#--------------PERDEU O ROUND---------------------#
PERDESTEKKK:
	la a0,GameOver
	li a1, FRAMESET
	lw a1, 0(a1)
	call loadbackground
	
	la s11, PLAYERADDRESS
	lw s11, 0(s11)
	
	la a0, kitana_dead
	lw a1, 0(s11)
	call calcsprite
	sw a0, 16(s11)
	
	lw a0, 16(s11)
	lw a1, 4(s11)
	lw a2, 8(s11)
	li a3, FRAMESET
	lw a3, 0(a1)
	call sprite
	
	mv a0, zero
SAIRFIGHT:
	
	lw ra, 0(sp)
	addi sp, sp, 100
	
	ret
