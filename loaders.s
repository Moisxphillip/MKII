.text
.eqv FRAMESET 0xFF200604
#faz o load de uma imagem 320x240 no bmp display
loadbackground: #void loadbackground(int*background, int frame) a0, a1 ->
        beqz    a1,.LBGL4
        li      a3,-15650816
        addi    a3,a3,-1024
        li      a5,-15728640
.LBGL2:
        addi    a0,a0,8
.LBGL3:
        lw      a4,0(a0)
        addi    a5,a5,4
        addi    a0,a0,4
        sw      a4,-4(a5)
        bgtu    a3,a5,.LBGL3
        ret
.LBGL4:
        li      a3,-16699392
        addi    a3,a3,-1024
        li      a5,-16777216
        j       .LBGL2
#DEPRECATED-----------------------------        
clearscreen:
        bnez    a0,.CLSSL16
        li      a4,-16699392
        li      a5,-16777216
        addi    a4,a4,-1024
.CLSSL9:
        li      a3,199
.CLSSL11:
        sw      a3,0(a5)
        addi    a5,a5,4
        bgtu    a4,a5,.CLSSL11  
        ret
.CLSSL16:
        li      a4,-15650816
        li      a5,-15728640
        addi    a4,a4,-1024
        j       .CLSSL9
#da um clear na região determinada, com a largura e altura do sprite        
clearsprite: #void clearsprite(int* background, int* sprite, int x, int y, int frame) a0..a4 -> 
        li      a6,-16777216
        beqz    a4,.CLSPRL14
        li      a6,-15728640
.CLSPRL14:
        lw      t1,0(a1)
        slli    a5,a3,2
        add     a5,a5,a3
        slli    a4,a5,6
        lw      a7,4(a1)
        srai    a5,t1,31
        add     a3,a4,a2
        andi    a4,a5,3
        add     a1,a4,t1
        add     a5,a0,a3
        addi    a5,a5,8
        add     a4,a6,a3
        srai    a1,a1,2
        blez    a7,.CLSPRL13
        li      a6,80
        sub     a6,a6,a1
        li      a3,3
        slli    a6,a6,2
        li      a0,0
        ble     t1,a3,.CLSPRL25
.CLSPRL16:
        li      a3,0
.CLSPRL18:
        lw      a2,0(a5)
        addi    a4,a4,4
        addi    a3,a3,1
        sw      a2,-4(a4)
        addi    a5,a5,4
        bgt     a1,a3,.CLSPRL18
        addi    a0,a0,1
        add     a4,a4,a6
        add     a5,a5,a6
        bne     a7,a0,.CLSPRL16
.CLSPRL13:
        ret
.CLSPRL25:
        ret
      
#printa um sprite em (x,y)        
sprite: #void sprite(int* sprite, int x, int y, int frame) a0..a3 ->
        li      a5,-16777216
        beqz    a3,.SPRL14
        li      a5,-15728640
.SPRL14:
        lw      t1,0(a0)
        slli    a3,a2,2
        lw      a7,4(a0)
        srai    a4,t1,31
        add     a3,a3,a2
        andi    a4,a4,3
        add     a5,a5,a1
        slli    a3,a3,6
        add     a4,a4,t1
        add     a5,a5,a3
        srai    a1,a4,2
        addi    a3,a0,8
        blez    a7,.SPRL13
        li      a6,80
        sub     a6,a6,a1
        li      a4,3
        slli    a6,a6,2
        li      a0,0
        ble     t1,a4,.SPRL25
.SPRL16:
        li      a4,0
.SPRL18:
        lw      a2,0(a3)
        addi    a5,a5,4
        addi    a4,a4,1
        sw      a2,-4(a5)
        addi    a3,a3,4
        bgt     a1,a4,.SPRL18
        addi    a0,a0,1
        add     a5,a5,a6
        bne     a7,a0,.SPRL16
.SPRL13:
        ret
.SPRL25:
        ret

#Printa um determinado sprite desconsiderando words 0xC7C7C7C7 
spritepimba: #void spritepimba(int*sprite, int x, int y, int frame) a0..a3 -> 
        li      a5,-16777216
        beqz    a3,.SPRPBL2
        li      a5,-15728640
.SPRPBL2:
        lw      t3,0(a0)
        slli    a3,a2,2
        lw      t1,4(a0)
        srai    a4,t3,31
        add     a3,a3,a2
        andi    a4,a4,3
        add     a5,a5,a1
        add     a4,a4,t3
        slli    a3,a3,6
        srai    a1,a4,2
        add     a3,a5,a3
        addi    a4,a0,8
        blez    t1,.SPRPBL1
        li      a7,80
        sub     a7,a7,a1
        li      a0,-943210496
        li      a5,3
        slli    a7,a7,2
        li      a6,0
        addi    a0,a0,1991
        ble     t3,a5,.SPRPBL15
.SPRPBL4:
        li      a5,0
.SPRPBL7:
        lw      a2,0(a4)
        addi    a5,a5,1
        addi    a4,a4,4
        beq     a2,a0,.SPRPBL6
        sw      a2,0(a3)
.SPRPBL6:
        addi    a3,a3,4
        bgt     a1,a5,.SPRPBL7
        addi    a6,a6,1
        add     a3,a3,a7
        bne     t1,a6,.SPRPBL4
.SPRPBL1:
        ret
.SPRPBL15:
        ret

spritealt:
        beqz    a3,.SPRAL8
        li      a6,-15728640
        li      a5,-15728640
.SPRAL2:
        lw      t3,0(a0)
        slli    a3,a2,2
        lw      t1,4(a0)
        srai    a4,t3,31
        add     a3,a3,a2
        andi    a4,a4,3
        slli    a3,a3,6
        add     a5,a5,a1
        add     a4,a4,t3
        add     a5,a5,a3
        srai    a2,a4,2
        addi    a3,a0,8
        blez    t1,.SPRAL1
        li      a7,80
        sub     a7,a7,a2
        li      a4,3
        slli    a7,a7,2
        li      a0,0
        ble     t3,a4,.SPRAL14
.SPRAL4:
        li      a4,0
.SPRAL7:
        addi    a4,a4,1
        bgtu    a6,a5,.SPRAL6
        lw      a1,0(a3)
        sw      a1,0(a5)
.SPRAL6:
        addi    a5,a5,4
        addi    a3,a3,4
        bgt     a2,a4,.SPRAL7
        addi    a0,a0,1
        add     a5,a5,a7
        bne     t1,a0,.SPRAL4
.SPRAL1:
        ret
.SPRAL8:
        li      a6,-16777216
        li      a5,-16777216
        j       .SPRAL2
.SPRAL14:
        ret
        
newframe: #void newframe(int*bkg, struct*player, struct* ia) a0, a1, a2->
	addi sp, sp, -8
	sw ra, 0(sp)
	sw a0, 4(sp)
	
	li t2, FRAMESET
	lw t2, 0(t2)
	
	mv s0,a1
	mv s2, a2
	#-----troca o frame------#
	xori t2, t2, 1
	#-----printa o player----"
	mv a0, s0 
	mv a1, zero
	call calcreversedsprite
	
	lw a1, 4(s0)
	lw a2, 8(s0)
	mv a3, t2
	call spritepimba
	#------printa o inimigo-------#
	mv a0, s2
	li a1, 1
	call calcreversedsprite
	
	lw a1, 4(s2)
	lw a2, 8(s2)
	mv a3, t2
	call spritepimba
 #----------troca o frame, se era 0 agora eh 1, vice versa----#
	li a0, FRAMESET
	sw t2, 0(a0)
#---------limpa o frame anterior---------------#	
	lw a0, 4(sp)	
	lw a1, 16(s0)
	lw a2, 20(s0)
	lw a3, 24(s0)

	xori a4, t2,1
	
	call clearsprite
	
	lw a0, 4(sp)
	lw a1, 16(s2)
	lw a2, 20(s2)
	lw a3, 24(s2)
	xori a4, t2, 1
	
	call clearsprite
	
	lw a1, 4(s0)
	lw a2, 8(s0)
	sw a1, 20(s0)
	sw a2, 24(s0)
#------------atualiza os "lastx" e "lasty"------------#	
	lw a1,  4(s2)
	lw a2, 8(s2)
	sw a1, 20(s2)
	sw a2, 24(s2)
	
	lw ra,0(sp)
	addi sp, sp, 8
	ret
