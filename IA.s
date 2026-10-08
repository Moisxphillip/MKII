.text
.macro randomint(%int)
	li a1, %int
	li a7, 42
	ecall
.end_macro

gameplan: # int function(int who) a0 -> a0
	bnez a0, JUMPERL
	la a0, SACODEPORRADA
	ret
JUMPERL:li t1, 1
	bne a0, t1, BLOCKERL
	la a0, JUMPER
	ret
BLOCKERL: li t1, 2
	bne a0, t1,ATACKERL
	la a0, BLOCKER
	ret
ATACKERL:
	la a0, ATACKER
	ret
# so ataca e anda
ATACKER: #void ATACKER(int* player, int* ia) a0, a1 -> 
	lw 	a5, 40(a1)
        bnez 	a5, .ATTACKERL3
        mv 	s1, a1
        
        lw      a3,4(a0)
        lw      a4,4(a1)
        li      a2,158
        sub     a5,a3,a4
        addi    a5,a5,79
        bgtu    a5,a2,.ATTACKERL5
        
        randomint(2)
        bnez   	a0, CHUTARATACKER
      	la 	a5, socomedio
      	j GUARDARATACKER 
CHUTARATACKER:
	la 	a5, chutemedio
GUARDARATACKER:        
	sw      a5,12(s1)
        ret
.ATTACKERL5:
        bgt     a3,a4,.ATTACKERL7
        la      a5,andarpratras
        sw      a5,12(a1)
.ATTACKERL3:
        ret
.ATTACKERL7:
        la      a5,andarprafrente
        sw      a5,12(a1)
        ret
#so ataca e pula
JUMPER: #void JUMPER(int*player, int* ia) a0, a1 -> 
	lw 	a5, 40(a1)
        bnez 	a5, .JUMPERL3
        mv 	s1, a1
        
        lw      a3,4(a0)
        lw      a4,4(a1)
        li      a2,158
        sub     a5,a3,a4
        addi    a5,a5,79
        bgtu    a5,a2,.JUMPERL5
        
        randomint(2)
        bnez   	a0, CHUTARJUMPER
      	la 	a5, socomedio
      	j GUARDARJUMPER 
CHUTARJUMPER:
	la 	a5, chutemedio
GUARDARJUMPER:        
	sw      a5,12(s1)
        ret
.JUMPERL5:
        bgt     a3,a4,.JUMPERL7
        la      a5,pulatras
        sw      a5,12(a1)
.JUMPERL3:
        ret
.JUMPERL7:
        la      a5,pulafrente
        sw      a5,12(a1)
        ret
#anda, ataca e bloqueia
BLOCKER:
	lw      a5,40(a1)
        bnez    a5,.BLOCKERL3
        mv 	s1, a1
        
        lw      a3,4(a0)
        lw      a4,4(a1)
        li      a2,158
        sub     a5,a3,a4
        addi    a5,a5,79
        bgtu    a5,a2,.BLOCKERL5
        
        randomint(10)
        li 	t1, 2
        ble   	a0, t1, CHUTARBLOCKER
        
        li 	t1, 5
        blt 	a0, t1, SOCARBLOCKER
        
        la a5, defesa
        j GUARDARBLOCKER
        
SOCARBLOCKER:
      	la 	a5, socomedio
      	j GUARDARBLOCKER 
CHUTARBLOCKER:
	la 	a5, chutemedio
GUARDARBLOCKER:        
	sw      a5,12(s1)
        ret
.BLOCKERL5:
        bgt     a3,a4,.BLOCKERL7
        la      a5,andarpratras
        sw      a5,12(a1)
.BLOCKERL3:
        ret
.BLOCKERL7:
        la      a5,andarprafrente
        sw      a5,12(a1)
        ret
#so anda
SACODEPORRADA:
        lw      a5,40(a1)
        bnez    a5,.SACODEPORRADAL3
        lw      a3,4(a0)
        lw      a4,4(a1)
        li      a2,158
        sub     a5,a3,a4
        addi    a5,a5,79
        bgtu    a5,a2,.SACODEPORRADAL6
.SACODEPORRADAL3:
        ret
.SACODEPORRADAL6:
        ble     a3,a4,.SACODEPORRADAL5
        la      a5,andarprafrente
        sw      a5,12(a1)
        ret
.SACODEPORRADAL5:
        la      a5,andarpratras
        
        sw      a5,12(a1)
        ret
