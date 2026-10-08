.eqv FILESIZE 426192

.text
HabilitarINT: #void HabilitarINT(LABEL) a0 ->
	mv tp,a0	# carrega em tp o endereço base das rotinas de Tratamento da Interrupção
 	csrrw zero,5,tp 	# seta utvec (reg 5) para o endereço tp
 	csrrsi zero,0,1 	# seta o bit de habilitação de interrupção global em ustatus (reg 0)
	li tp,0x100
 	csrrw zero,4,tp		# habilita a interrupção do usuário

 	li t1,0xFF200000	# Endereço de controle do KDMMIO
	li t0,0x02		# bit 1 habilita/desabilita a interrupção
	sw t0,0(t1)   		# Habilita interrupção do teclado
	ret	
	
TeclaMENU: # void TeclaMENU(unsigned int* positionpointer) a0 -> 
	addi sp, sp, -4
	sw a0, 0(sp)
	csrrci zero,0,1 	# clear o bit de habilitação de interrupção global em ustatus (reg 0)
	
	li      a5,-14680064 
        lbu     a4,4(a5)
	
	li 	t1, 10
	bne 	t1, a4, NORMALTCMN
	lw 	a0,0(sp)
	addi 	sp, sp, 4
	j OUTOFLOOPMENU
NORMALTCMN:
	
	lw      a3,0(a0)
        li      a1,119
        addi    a5,a4,-97
        seqz    a5,a5
        addi    a2,a4,-100
        sub     a5,a3,a5
        seqz    a2,a2
        add     a5,a5,a2
        beq     a4,a1,.L27
        li      a2,115
        bne     a4,a2,.L28
        addi    a5,a5,2
.L28:
        andi    a4,a5,3
        beq     a3,a4,.L26
        andi    a2,a5,1
        li      a1,192
        bnez    a2,.L30
        li      a1,92
.L30:
        andi    a5,a5,2
        li      a2,124
        bnez    a5,.L31
        li      a2,60
.L31:
        andi    a5,a3,1
        li      a6,92
        bnez    a5,.L39
        li      a7,1
        li      a5,60
        bleu    a3,a7,.L33
.L40:
        li      a5,124
.L33:
        sw      a4,0(a0)
        
        mv s1, a1 #x1
        mv s2, a2 #y1
        mv s4, a4 #pos
        mv s6, a6 #x2
        mv s5, a5 #y2
     
        la a0, char_menu
        la a1, frame_char_menu
        mv a2, s6
        mv a3, s5
        mv a4, zero
        call clearsprite
        
        la a0, char_menu
        la a1, kitana_idle1
        li a2, 0
        li a3, 50
        mv a4, zero
        
        call clearsprite
        
        la a0, kitana_idle1
        mv a1, s4
        call calcsprite
        li a1, 0
        li a2, 50
        mv a3, zero
        call sprite
        
        la a0, frame_char_menu
        mv a1, s1
        mv a2, s2
        mv a3, zero
        
        call sprite
        
        
        
.L26:
        j .MKEYSAIR
.L39:
        li      a7,1
        li      a6,192
        li      a5,60
        bgtu    a3,a7,.L40
        j       .L33
.L27:
        addi    a5,a5,-2
        j       .L28
.MKEYSAIR:
	csrrsi zero,0,0x10 	# seta o bit de habilitação de interrupção em ustatus 
	lw a0,0(sp)
	addi sp, sp, 4
	uret
