#beq, bne, lw, sw, j y jr
.text
	lui $sp, 0x1001
	addi $sp, $sp, 0x400
	addi $t2, $t2, 20
	addi $t3, $t3, 15
	bne $t3, $t2, test2
main: 	
	beq $t2, $t3,test

test: 
	addi $sp, $sp, -8
	sw $t2, 0($sp)			
	sw $t3, 4($sp)
	j final	
test2: 
	addi $t3, $t3, 5
	j main
final: 
	add $a0, $t2, $t3
	add $t2, $t3, $a0
	add $t3, $t2, $a0
	lw $t2, 0($sp)			
	lw $t3, 4($sp)	
	addi $sp, $sp, 8
	add $t4, $t2, $t3
	







