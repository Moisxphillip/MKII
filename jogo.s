.eqv FILESIZE 426192
.include "AberturaP/Abertura"
.include "includes.asm"	
	IAATUAL: .word 0
	ENEMYARRAY: .word 0,1,2,3
	PLAYERADDRESS: .word 0 
	ENEMYADDRESS:  .word 0
.text
.globl main

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

main:
MainHUB:
	li t1, FRAMESET
	sw zero, 0(t1)
	call Aberturalegal
	addi sp, sp, -4
	sw ra, 0(sp)
	
	call MENU
	
	call GameLOOP
	
	lw ra, 0(sp)
	addi sp, sp, 4
	
	li a7, 10
	ecall
	
GameLOOP: # void GameLOOP(int pos) a0 -> 
	addi sp, sp, -8
	sw ra, 0(sp)
	sw a0, 4(sp)
	
	la a0, kitana_dead
	lw a1, 4(sp)
	call calcsprite #descobre o primeiro sprite do personagem escolhido
	
	la a1, PlayerReversed #gera os sprites invertidos
	call spritereversal
	
	la a0, ENEMYARRAY
	call BOGOSORT
	
INGAMELOOP:	
	la t1, IAATUAL
	lw t1, 0(t1)
	li t0, 4
	beq t1, t0, OUTOFGAMELOOP
	
	la a0, kitana_dead
	
	la a1, IAATUAL
	lw a1, 0(a1)
	li t1, 4
	mul a1, a1, t1
	
	la t1, ENEMYARRAY
	add a1,a1, t1
	lw a1, 0(a1)
	
	call calcsprite #descobre o primeiro sprite do personagem escolhido
	
	la a1, ReversedIA #gera os sprites invertidos
	call spritereversal
	
	
	lw a0, 4(sp)
	jal FIGHT
	
	beqz a0, OUTOFGAMELOOP
	
	la t1, IAATUAL
	lw a1, 0(t1)
	addi a1, a1, 1
	sw a1, 0(t1)
	
	j INGAMELOOP	
OUTOFGAMELOOP:
	lw ra, 0(sp)
	addi sp, sp, 8
	ret		
	
MENU:#int MENU() a0(position) -> 
	addi sp, sp, -8
	sw ra, 0(sp)
	sw zero, 4(sp)
	
	la a0, char_menu
	call loadbackground
	
	la a0, kitana_idle1
        li a1, 0
        li a2, 50
        mv a3, zero
        call sprite
        
        la a0, frame_char_menu
        li a1, 92
        li a2, 60
        mv a3, zero
        
        call sprite
	
	la a0, TeclaMENU
	call HabilitarINT
	addi a0, sp, 4
HelperLOOPMENU:
	j HelperLOOPMENU
	
OUTOFLOOPMENU:	
	csrrci zero,0,1 	# clear o bit de habilitação de interrupção global em ustatus (reg 0)

	lw a0, 4(sp)
	lw ra, 0(sp)
	addi sp, sp, 4
	ret
