	
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
.data
	FRAMEATUAL: .word 0
	FRAMEATUALIA:.word 0
	HITTADO: .word 0
	HITTADOIA: .word 0
	SEMSOM: .word 0
.text
#---------funcao de interrupcao
ingameKEY:  #void ingameKEY() ->
	addi sp, sp, -24
	
	sw 	a0, 0(sp)
	sw 	a1, 4(sp)
	sw 	a2, 8(sp)
	sw 	t0, 12(sp)
	sw 	t1, 16(sp)
	sw 	a7, 20(sp)
	
	la a7, PLAYERADDRESS
	lw a7,0(a7)
	
	lw a7,40(a7)
	bnez a7, CANTACTION
	csrrci zero,0,1 	# clear o bit de habilitação de interrupção global em ustatus (reg 0)
	
	
	
	la a0, PLAYERADDRESS
	lw a0, 0(a0)
	
	li t0, 0xFF200004
	lw t0, 0(t0)
	li t1, 97
	
	bne t1, t0, NOTAIGK
	la t1, andarpratras # A
	sw t1, 12(a0)
	j FINALIGK
	
NOTAIGK: li t1, 100
	bne t1, t0, NOTBIGK
	la t1, andarprafrente # D
	sw t1,12(a0)
	
	
	j FINALIGK
NOTBIGK:li t1, 106
	bne t1, t0, NOTJIGK
	la t1, socomedio # J
	sw t1, 12(a0)
	j FINALIGK
	
NOTJIGK:li t1, 107
	bne t1, t0 NOTKIGK
	la t1, chutemedio #K
	sw t1, 12(a0)
	j FINALIGK

NOTKIGK: li t1,108
	bne t1, t0, NOTLIGK
	la t1, defesa #L
	sw t1, 12(a0)
	j FINALIGK

NOTLIGK:li t1, 119
	bne t1, t0, NOTWIGK
	la t1, pulaparado #W
	sw t1, 12(a0)
	j FINALIGK

NOTWIGK: li t1, 101
	bne t1, t0, NOTEIGK
	la t1, pulafrente #E
	sw t1, 12(a0)
	j FINALIGK
	
NOTEIGK:li t1,113
	bne t1, t0, NOTQIGK
	la t1, pulatras #Q
	sw t1, 12(a0)
	j FINALIGK
NOTQIGK:

FINALIGK:
	bnez a7, CANTACTION
	csrrsi zero,0,0x10 	# seta o bit de habilitação de interrupção em ustatus 
CANTACTION:
	lw 	a0, 0(sp)
	lw 	a1, 4(sp)
	lw 	a2, 8(sp)
	lw 	t0, 12(sp)
	lw 	t1, 16(sp)
	lw 	a7, 20(sp)
	addi 	sp, sp, 24
		
	uret
#---calcula o sprite atual do personagem
calcsprite: # int* calcsprite(int* sprite_Base, int personagem) a0, a1 -> 
	li t1, 426192
	mul a1, a1, t1
	add a0, a0, a1
	ret
#calcula o adress de auxilio dos frames idle e step
calcaddress: #void calcaddress(int ia) a1 -> a1  
	la t1, FRAMEATUAL
	beqz a1, ISIAADDRESS
	addi t1, t1, 4
ISIAADDRESS:
	mv a1, t1
	ret
#funcao que chama a acao atual do personagem
ManageAction: #void ManageAction(int* player, int ia) a0, a1 ->
	addi sp, sp, -4
	sw ra, 0(sp)
	
	lw t0,12(a0)
	jal calcaddress 
	beqz t0, NOACTION
	jalr t0
	j FIMMA
NOACTION:		
	jal idleanimations
	
FIMMA:	lw ra, 0(sp)
	addi sp, sp, 4
	ret
#funcao pra quando o personagem nao tem acao sendo executada
idleanimations: # void idleanimations(int* player, int address) a0, a1 ->
	addi sp, sp, -4
	sw ra, 0(sp)

	li t1, 0
	sw t1, 0(a1)
	
	mv t0, a0
	
	la a0, kitana_idle1
	lw a1, 0(t0)
	jal calcsprite
	
	lw a1, 16(t0)
	bne a1, a0, idleAN1
	li t1, 16392
	add a0, a0, t1
idleAN1:
	sw a0, 16(t0)
FIMidleAN:
	lw ra, 0(sp)			
	addi sp, sp, 4
	ret

andarprafrente: #void andarprafrente(int*player,int address) a0, a1 -> 
	addi sp, sp, -4
	sw ra, 0(sp)
	mv s0, a0
	mv s1, a1
	
	sw zero, 12(s0)
	
	lw t0, 4(s0)
	li t1, 232
	bge t0, t1, NOAPF
	addi t0, t0, 8
	sw t0, 4(s0)
	
NOAPF:	

	la a0, kitana_step1
	lw a1, 0(s0)
	jal calcsprite
 	
	mv 	a3, s1
        lw      a5,0(a3)
        li      a4,5
        addi    a5,a5,1
        rem     a5,a5,a4
        slli    a4,a5,11
        add     a4,a4,a5
        slli    a4,a4,3
        sw      a5,0(a3)
        add     a0,a4,a0
        
	sw a0, 16(s0)
	
	mv a0, s0
	call alignplayer
	
	lw ra, 0(sp)
	addi sp, sp, 4
	ret
	
andarpratras: #void andarpratras(int*player, int address) a0, a1 ->
	addi sp, sp, -4
	sw ra, 0(sp)
	mv s0, a0
	mv s1, a1
	
	sw zero, 12(s0)
	
	lw t0, 4(s0)
	li t1, -40
	ble t0, t1, NOAPT
	addi t0, t0, -8
	sw t0, 4(s0)
	
NOAPT:	

	la a0, kitana_step1
	lw a1, 0(s0)
	jal calcsprite

	mv 	a2, s1
        lw      a5,0(a2)
        li      a4,5
        addi    a5,a5,1
        rem     a5,a5,a4
        li      a4,4
        sub     a3,a4,a5
        slli    a4,a3,11
        add     a4,a4,a3
        slli    a4,a4,3
        sw      a5,0(a2)
        add     a0,a4,a0
        
	sw a0, 16(s0)
	
	mv a0, s0
	call alignplayer
	
	lw ra, 0(sp)
	addi sp, sp, 4
	ret
	
socomedio: #void socomedio(int*player) a0 -> 
	addi sp, sp, -4
	sw ra, 0(sp)
	mv s0, a0
	
	la a0, kitana_punch1
	lw a1, 0(s0)
	jal calcsprite
	
	mv a1, s0
	
        lw      a2,40(a1)
        li      a3,1
        beqz    a2,.SCML2
        addi    a5,a2,-5
        seqz    a5,a5
        li      a6,1
        addi    a3,a5,2
        bne     a2,a6,.SCML9
.SCML2:
        lw      a4,0(a1)
        addi    a7,a3,-3
        seqz    a7,a7
        andi    a5,a4,-3
        li      t1,0
        bnez    a5,.SCML4
.SCML10:
        slli    a5,a7,3
        sub     a5,a5,a7
        slli    t1,a5,4
.SCML4:
        addi    t4,a2,1
        li      a5,6
        rem     t4,t4,a5
        addi    a5,a4,-1
        seqz    a5,a5
        addi    a4,a4,-3
        seqz    a4,a4
        addi    a3,a3,-1
        slti    a6,a2,5
        slli    a2,a3,11
        add     a3,a2,a3
        slli    a3,a3,3
        add     a3,a3,a0
        lw      t3,12(a1)
        sw      a3,16(a1)
        li      a3,118
        mul     a5,a5,a7
        sw      t4,40(a1)
        mul     a4,a4,a7
        mul     a5,a5,a3
        li      a3,109
        mul     a4,a4,a3
        add     a5,a5,t1
        mul     a2,t3,a6
        add     a5,a5,a4
        sw      a5,28(a1)
        sw      a2,12(a1)
        lw ra, 0(sp)
        addi sp, sp, 4
        ret
.SCML9:
        addi    a3,a2,-4
        seqz    a3,a3
        slli    a3,a3,1
        addi    a4,a2,-2
        add     a3,a3,a5
        bgtu    a4,a6,.SCML2
        lw      a4,0(a1)
        addi    a3,a3,3
        addi    a7,a3,-3
        andi    a5,a4,-3
        seqz    a7,a7
        li      t1,0
        bnez    a5,.SCML4
        j       .SCML10
        
chutemedio: # void chutemedio(int*player) a0 -> 
	addi sp, sp, -4
	sw ra, 0(sp)
	mv s0, a0
	
	la a0, kitana_kick1 
	lw a1, 0(s0)
	jal calcsprite
	
	mv a1, s0
	
        lw      a2,40(a1)
        beqz    a2,.CML9
        addi    a5,a2,-8
        seqz    a4,a5
        li      a5,1
        addi    a6,a4,2
        bne     a2,a5,.CML14
.CML8:
        addi    a3,a2,-5
        seqz    a5,a3
        slli    a3,a5,1
        add     a3,a3,a5
        add     a3,a3,a6
.CML6:
        lw      a4,0(a1)
        addi    a7,a3,-4
        seqz    a7,a7
        andi    a5,a4,-3
        li      t1,0
        bnez    a5,.CML7
.CML15:
        slli    a5,a7,3
        sub     a5,a5,a7
        slli    t1,a5,4
.CML7:
        addi    t4,a2,1
        li      a5,9
        rem     t4,t4,a5
        addi    a5,a4,-1
        seqz    a5,a5
        addi    a4,a4,-3
        seqz    a4,a4
        addi    a3,a3,-1
        slli    a6,a3,11
        add     a3,a6,a3
        slli    a3,a3,3
        add     a3,a3,a0
        lw      t3,12(a1)
        sw      a3,16(a1)
        li      a3,118
        slti    a2,a2,8
        mul     a5,a5,a7
        sw      t4,40(a1)
        mul     a4,a4,a7
        mul     a5,a5,a3
        li      a3,109
        mul     a4,a4,a3
        add     a5,a5,t1
        mul     t3,t3,a2
        add     a5,a5,a4
        sw      a5,28(a1)
        sw      t3,12(a1)
        
        lw ra, 0(sp)
        addi sp, sp, 4
        ret
.CML9:
        li      a5,1
.CML2:
        addi    a3,a2,-5
        seqz    a4,a3
        slli    a3,a4,1
        add     a3,a3,a4
        li      a6,1
        addi    a4,a2,-3
        add     a3,a3,a5
        bgtu    a4,a6,.CML6
        lw      a4,0(a1)
        addi    a3,a3,4
        addi    a7,a3,-4
        andi    a5,a4,-3
        seqz    a7,a7
        li      t1,0
        bnez    a5,.CML7
        j       .CML15
.CML14:
        li      a5,6
        beq     a2,a5,.CML8
        addi    a5,a2,-7
        seqz    a5,a5
        slli    a5,a5,1
        add     a5,a5,a4
        li      a4,2
        addi    a3,a5,3
        bne     a2,a4,.CML2
        lw      a4,0(a1)
        addi    a7,a3,-4
        seqz    a7,a7
        andi    a5,a4,-3
        li      t1,0
        bnez    a5,.CML7
        j       .CML15
        
defesa: #void defesa(int*player) a0 ->
	addi sp,sp, -4
	sw ra, 0(sp)
	
	mv s0, a0
	la a0, kitana_def
	lw a1, 0(s0)
	call calcsprite
	sw a0, 16(s0)
	
	lw ra, 0(sp)
	addi sp, sp, 4
	ret
	
pulaparado: #void pulaparado(int*player) a0 ->
	addi sp, sp, -4
	sw ra, 0(sp)
	
	mv s0, a0
	
	la a0, kitana_jump
	lw a1, 0(s0)
	call calcsprite
	sw a0, 16(s0)
	
	mv a0, s0
	
	lw      a5,40(a0)
        li      a3,2
        lw      a4,8(a0)
        ble     a5,a3,.PPL2
        addi    a2,a5,-3
        bgtu    a2,a3,.PPL3
        addi    a4,a4,16
.PPL3:
        addi    a2,a5,1
        li      a3,6
        rem     a2,a2,a3
        lw      a3,12(a0)
        slti    a5,a5,5
        sw      a4,8(a0)
        mul     a5,a3,a5
        sw      a2,40(a0)
        sw      a5,12(a0)
        lw ra, 0(sp)
	addi sp, sp, 4
	ret
.PPL2:
        addi    a4,a4,-16
        j       .PPL3
	
pulafrente: # void pulafrente(int*) a0 -> 
	addi sp,sp, -4
	sw ra, 0(sp)
	
	mv s0, a0
	
	la a0, kitana_jumpmove1
	lw a1, 0(s0)
	call calcsprite
	mv a1, a0
	mv a0, s0
	
	lw      a4,4(a0)
        lw      a5,40(a0)
        li      a2,2
        addi    a4,a4,16
        sw      a4,4(a0)
        lw      a3,8(a0)
        addi    a7,a5,-3
        ble     a5,a2,.PFL2
        bgtu    a7,a2,.PFL3
        addi    a3,a3,16
.PFL3:
        lw      a6,12(a0)
        slti    a2,a5,5
        sw      a3,8(a0)
        mul     a2,a6,a2
        li      a4,2
        li      a3,0
        sw      a2,12(a0)
        bgtu    a7,a4,.PFL5
        li      a3,5
        sub     a3,a3,a5
.PFL5:
        li      a4,6
        addi    a5,a5,1
        rem     a5,a5,a4
        slli    a4,a3,11
        add     a4,a4,a3
        slli    a4,a4,3
        add     a4,a4,a1
        sw      a4,16(a0)
        sw      a5,40(a0)
        
        mv a0, s0
	call alignplayer
	
        lw ra, 0(sp)
        addi sp,sp,4
        ret
.PFL2:
        addi    a3,a3,-16
        j       .PFL3
        
pulatras: # void pulatras(int* player) a0 -> 
	addi sp,sp, -4
	sw ra, 0(sp)
	
	mv s0, a0
	
	la a0, kitana_jumpmove1
	lw a1, 0(s0)
	call calcsprite
	mv a1, a0
	mv a0, s0	

	lw      a4,4(a0)
        lw      a3,8(a0)
        lw      a5,40(a0)
        addi    a4,a4,-16
        sw      a4,4(a0)
        li      a4,2
        addi    a6,a3,-16
        ble     a5,a4,.PTL7
        addi    a6,a3,16
.PTL7:
        lw      a2,12(a0)
        slti    a3,a5,5
        sw      a6,8(a0)
        mul     a3,a2,a3
        li      a4,2
        li      a2,0
        sw      a3,12(a0)
        bgt     a5,a4,.PTL4
        mv      a2,a5
.PTL4:
        slli    a4,a2,11
        add     a4,a4,a2
        slli    a4,a4,3
        li      a2,2
        add     a4,a4,a1
        li      a3,0
        ble     a5,a2,.PTL6
        li      a1,5
        sub     a3,a1,a5
.PTL6:
        addi    a5,a5,1
        li      a2,6
        rem     a5,a5,a2
        slli    a1,a3,11
        add     a1,a1,a3
        slli    a1,a1,3
        add     a4,a4,a1
        sw      a4,16(a0)
        sw      a5,40(a0)
        
        mv a0, s0
        call alignplayer
        
        lw ra, 0(sp)
        addi sp, sp, 4
        ret

tomouhit: #void tomouhit(int*player, int address) a0 , a1 -> 
	addi sp, sp, -4
	sw ra, 0(sp)
	
	mv s0, a0
	mv s1, a1
	
	addi s1, s1, 8
	lw t1, 0(s1)
	bnez t1, JaPassou
	
	li t1, 1
	sw t1, 0(s1)
	
	la t1, HITTADO
	addi a0, s0, 32
	bne s1, t1, IATOMOU
	call PlayerPerdeHP
	addi a0, s0, 32
	call PlayerPerdeHP
	j HITSOUND
IATOMOU:
	call EnemyPerdeHP
	addi a0, s0, 32
	call EnemyPerdeHP
JaPassou:	
	la a0, kitana_hit
	lw a1, 0(s0)
	call calcsprite
	
	sw a0, 16(s0)
	
	li a1, 85
	sw a1, 8(s0)
	
	lw a1, 40(s0)
	addi a1, a1, -1
	sw a1, 40(s0)
	la a0, SEMSOM
	lw t1,0(a0)
	bnez t1, nosoundhit
#-------dano tomado--------
	
HITSOUND:
	la a0, SEMSOM
	li t1, 1
	sw t1, 0(a0)
#-------musica----------	
	mv t1,a1
	
	li a0,43		# define a nota
	li a1,340		# define a duracao em ms
	li a2,127		# Seta o som de tiro
	li a3,90		# define o volume
	li a7,33		# define o syscall
	ecall 
	
	mv a1, t1
	
nosoundhit:	
	bnez a1, CONTINUEHIT
	sw zero, 12(s0)
	la a0 , SEMSOM
	sw zero, 0(a0)
	sw zero, 0(s1)
CONTINUEHIT:	
	lw ra, 0(sp)		
	addi sp, sp, 4		
	ret
