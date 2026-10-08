.text


.macro randomint(%int)
	li a1, %int
	li a7, 42
	ecall
.end_macro

spritereversal: # void spritereversal(char* personagem, char* toreverse) a0, a1 ->
        li      a5,16384
        li      t4,425984
        addi    a4,a5,7
        addi    t4,t4,216
        add     a0,a0,a4
        addi    a7,a1,8
        add     t4,a1,t4
        li      t5,128
        li      t6,-16384
        mv      t3,a4
        addi    t1,a5,8
.SPRRL5:
        mv      a1,a7
        sw      t5,-8(a7)
        sw      t5,-4(a7)
        add     a2,a0,t6
.SPRRL2:
        addi    a6,a2,128
        mv      a5,a6
        mv      a4,a1
.SPRRL3:
        lbu     a3,0(a5)
        addi    a4,a4,1
        addi    a5,a5,-1
        sb      a3,-1(a4)
        bne     a5,a2,.SPRRL3
        addi    a1,a1,128
        mv      a2,a6
        bne     a0,a6,.SPRRL2
        add     a7,a7,t1
        add     a0,a0,t3
        bne     t4,a7,.SPRRL5
        ret
        
calcreversedsprite: #void calcreversedsprite(struct*player, int ia) a0, a1 -> a0

	lw t1, 36(a0)
	bnez t1, ReversedYES
	lw a0, 16(a0)
	ret
ReversedYES:
	lw t1, 16(a0)
	la t0, kitana_dead
	remu t1, t1, t0
	li t0, 426192
	remu t1, t1, t0
	beqz a1, EHJOGADOR
	la a0, ReversedIA
	j CALCREVERSED
EHJOGADOR:
	la a0, PlayerReversed
CALCREVERSED:
	add a0,a0, t1	
	ret


alignplayer: #alignplayer(int*player) a0 -> 
        lw      a4,36(a0)
        lw      a5,4(a0)
        bnez    a4,.AGPL2
        li      a4,-40
        blt     a5,a4,.AGPL9
.AGPL3:
        li      a4,232
        ble     a5,a4,.AGPL7
        li      a5,232
.AGPL7:
        sw      a5,4(a0)
        ret
.AGPL9:
        li      a5,-40
        j       .AGPL3
.AGPL2:
        li      a4,-20
        bge     a5,a4,.AGPL6
        li      a5,-20
.AGPL6:
        li      a4,292
        ble     a5,a4,.AGPL7
        li      a5,292
        sw      a5,4(a0)
        ret
        
BOGOSORT: #BOGOSORT(int* enemy) a0 ->
	addi t1, a0, 16
	mv s0, a0
	mv t0, a0
BOGOLOOP:	
	randomint(4)
	li a1, 4
	mul a0, a0, a1
	
	add t2, s0, a0
	
	lw a0, 0(t2)
	lw t3, 0(t0)
	sw t3, 0(t2)
	sw a0, 0(t0)
	
	addi t0, t0, 4
	blt t0, t1, BOGOLOOP 
	
	ret

calchitbox: #int calchitbox(int* player, int* enemy) a0, a1 -> a0
        mv 	s0, a0
        mv 	s1, a1
        lw      a5,28(a0)
        beqz    a5,.CALCHITL4
        
        la	 t1,  defesa
      	lw	 t0,  12(s1)
      	beq 	 t1, t0, .CALCHITL4
      	
        lw      a2,36(a0)
        lw      a4,4(a0)
        lw      a3,4(a1)
        bnez    a2,.CALCHITL5
        add     a4,a5,a4
        addi    a3,a3,19
        li      a5,0
        blt     a3,a4,.CALCHITL6
.CALCHITL4:
        lw      a4,28(a1)
        beqz    a4,.CALCHITL3
        
        la	 t1,  defesa
      	lw	 t0,  12(s0)
      	beq 	 t1, t0, .CALCHITL3
        
        lw      a6,36(a1)
        lw      a2,4(a1)
        lw      a3,4(a0)
        bnez    a6,.CALCHITL8
        addi    a3,a3,19
        add     a4,a4,a2
        bge     a3,a4,.CALCHITL3
        li      a5,5
        sw      a5,40(a0)
        sw 	zero, 28(a0)
        la      a5,tomouhit
        sw      a5,12(a0)
        li      a5,1
.CALCHITL3:
        mv      a0,a5
        ret
.CALCHITL8:
        addi    a2,a2,128
        sub     a4,a2,a4
        addi    a3,a3,128
        bgt     a4,a3,.CALCHITL3
        li      a5,5
        sw      a5,40(a0)
        sw 	zero, 28(a0)
        la      a5,tomouhit
        sw      a5,12(a0)
        li      a5,1
        j       .CALCHITL3
.CALCHITL5:
        addi    a4,a4,128
        sub     a4,a4,a5
        addi    a3,a3,128
        bgt     a4,a3,.CALCHITL18
.CALCHITL6:
	sw 	zero, 28(a1)
        li      a5,5
        sw 	zero, 28(a1)
        sw      a5,40(a1)
        la     a5,tomouhit
        sw      a5,12(a1)
        li      a5,1
        j       .CALCHITL4
.CALCHITL18:
        li      a5,0
        j       .CALCHITL4
        
checkreverse: # void checkreverse(int*player,int*enemy) a0 , a1 -> 
        lw      a4,4(a0)
        lw      a5,4(a1)
        ble     a4,a5,.ckrL2
        li      a5,1
        sw      a5,36(a0)
        sw      zero,36(a1)
        ret
.ckrL2:
        sw      zero,36(a0)
        li      a5,1
        sw      a5,36(a1)
        ret
