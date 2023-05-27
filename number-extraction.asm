#Extract number from string and print in reversed order

.data
prompt: .asciiz  "Input the string: "
string: .space 100

.text
input:
	la $a0, prompt				
	li $v0, 54
	la $a1, string
	la $a2, 100
	syscall

	la $a0, string				# load address of string into $a0
	bne $a1,0,input
	add $s0,$sp,0				# stack pointer
	li $t0, 0  				# counter
loop:
	lb $t1, ($a0) 				# load byte from string into $t1
	beq $t1, $0, end_loop 			# if byte is 0, end loop

# check if byte is a number
	blt $t1, '0', next_byte
	bgt $t1, '9', next_byte

# push byte onto stack
	addi $sp, $sp, -4
	sw $t1, ($sp)

next_byte:
	addi $a0, $a0, 1 			# increment pointer to string
	addi $t0, $t0, 1 			# increment counter
	j loop

end_loop: li $t0, 0   				# reset counter

print_loop:
beq $sp, $s0, end_print_loop 			# if counter is equal to stack pointer, end loop
# pop byte from stack
lw $t1, ($sp)
# print byte to screen
move $a0, $t1
li $v0, 11
syscall
  
# decrement stack pointer
addi $sp, $sp, 4

addi $t0, $t0, 1 # increment counter
j print_loop

end_print_loop:
li $v0, 10 # exit program
syscall
