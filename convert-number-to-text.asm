.data
prompt: .asciiz  "Please input an Interger(0-999 999 999): "
prompt2: .asciiz "The number in English is: \0"
zero: .asciiz "Zero"
one: .asciiz "One "
two: .asciiz "Two "
three: .asciiz "Three "
four: .asciiz "Four "
five: .asciiz "Five "
six: .asciiz "Six "
seven: .asciiz "Seven "
eight: .asciiz "Eight "
nine: .asciiz "Nine "
ten: .asciiz "Ten "

eleven: .asciiz "Eleven "
twelve: .asciiz "Twelve "
thirteen: .asciiz "Thirteen "
fourteen: .asciiz "Fourteen "
fifteen: .asciiz "Fifteen "
sixteen: .asciiz "Sixteen "
seventeen: .asciiz "Seventeen "
eighteen: .asciiz "Eighteen "
nineteen: .asciiz "Nineteen "
twenty: .asciiz "Twenty-"
thirty: .asciiz "Thirty-"
forty: .asciiz "Forty-"
fifty: .asciiz "Fifty-"
sixty: .asciiz "Sixty-"
seventy: .asciiz "Seventy-"
eighty: .asciiz "Eighty-"
ninety: .asciiz "Ninety-"

hundred: .asciiz "Hundred "
thousand: .asciiz "Thounsand "
million: .asciiz "Million "


.text
input:
#get integer (stored in a1):
li $v0, 51
la $a0, prompt
syscall
bne $a1,0,input				#input check
blt $a0,0,input
bgt $a0,999999999,input

add $a1,$a0,$0				#store in a1

#assign const 10, 100, 1000...
addi $s0,$s0, 10
addi $s1,$s1, 100
addi $s3,$s3, 1000
addi $s4,$s4, 1000000

beq $a1,0,print0			#check 0

main:
div $a1, $s4 				#get the 3 million units
mflo $a3
beq $a3,0,thousands			#skip to 3 thousand units if no million unit
addi $t8,$t8,1
j print3

print_mils:				#print3 return address
addi $t8,$t8,-1
la $a0, million
syscall

thousands:
div $a1, $s4 		
mfhi $a3
div $a3,$s3
mflo $a3
beq $a3,0,print_units			#skip to 3 last units if no thousand unit		
addi $t9,$t9,1
j print3

print_thous:				#print3 return address
addi $t9,$t9,-1
la $a0, thousand
syscall
addi $s7,$s7,1


print_units:				#print3 return address
addi $s7,$s7,-1
div $a1, $s3
mfhi $a3
j print3



#print 3 unit:
print3:
div $a3 ,$s1				#div 100							
mflo $v1				#get the hundred unit
jal print_digit				#print the hundred unit
nop
beq $v1,0,last_2units			#last_2units if the hundred unit is 0
la $a0,hundred				#print 'hundred' if not 0
syscall

last_2units:
div $a3 ,$s1				#div 100
mfhi $v1				#get 2 units left
beq $v1, 0, exit 			#done print3 if they equal 0
bgt $v1,19,print_ty			#if greater 19, print_ty
bgt $v1,10, print_teen			#if greater 10 (and not greater 19), print_teen
last_unit:	
div $v1, $s0				#v1 storing 2 last units, so div 10 to get the last unit
mfhi $v1
jal print_digit				#print last unit, print_digit
nop
j exit					#done print3



div $a3 ,$s0
mfhi $v1
jal print_digit
nop
j exit

print_digit:				#1,2,...,9
li $v0,4
p1:	bne $v1,1,p2	
	la $a0,one
	syscall
	j return
p2:	bne $v1,2,p3
	la $a0,two
	syscall
	j return
p3:	bne $v1,3,p4
	la $a0,three
	syscall
	j return
p4:	bne $v1,4,p5
	la $a0,four
	syscall
	j return
p5:	bne $v1,5,p6
	la $a0,five
	syscall
	j return
p6:	bne $v1,6,p7
	la $a0,six
	syscall
	j return
p7:	bne $v1,7,p8
	la $a0,seven
	syscall
	j return
p8: 	bne $v1,8,p9
	la $a0,eight
	syscall
	j return
p9:	bne $v1,9,return
	la $a0,nine
	syscall
	j return


print0:					#0
	li $v0,4
	la $a0,zero
	syscall

print_teen:				#10,...,19
li $v0,4
p10:	bne $v1,10,p11	
	la $a0,ten
	syscall
	j exit
p11:	bne $v1,11,p12	
	la $a0,eleven
	syscall
	j exit
p12:	bne $v1,12,p13
	la $a0,twelve
	syscall
	j exit
p13:	bne $v1,13,p14
	la $a0,thirteen
	syscall
	j exit
p14:	bne $v1,14,p15
	la $a0,fourteen
	syscall
	j exit
p15:	bne $v1,15,p16
	la $a0,fifteen
	syscall
	j exit
p16:	bne $v1,16,p17
	la $a0,sixteen
	syscall
	j exit
p17:	bne $v1,17,p18
	la $a0,seventeen
	syscall
	j exit
p18: 	bne $v1,18,p19
	la $a0,eighteen
	syscall
	j exit
p19:	bne $v1,19,p20
	la $a0,nineteen
	syscall
	j exit


	
print_ty: 				#20, 30, 40, 50,...
li $v0,4
p20:	bgt $v1,29,p30
	la $a0,twenty
	syscall
	j last_unit
p30:	bgt $v1,39,p40
	la $a0,thirty
	syscall
	j last_unit
p40:	bgt $v1,49,p50
	la $a0,forty
	syscall
	j last_unit
p50:	bgt $v1,59,p60
	la $a0,fifty
	syscall
	j last_unit
p60:	bgt $v1,69,p70
	la $a0,sixty
	syscall
	j last_unit
p70:	bgt $v1,79,p80
	la $a0,seventy
	syscall
	j last_unit
p80:	bgt $v1,89,p90
	la $a0,eighty
	syscall
	j last_unit
p90:	
	la $a0,ninety
	syscall
	j last_unit

return:
	jr $ra

exit:	
	beq $t8,1,print_mils
	beq $t9,1,print_thous
	beq $s7,1, print_units

done:
