main:
    addi $a0, $zero, 10 # n = 10
    jal fib          # call fib(10)
    j exit

fib:
    addi $sp , $sp , -12
    sw $ra , 0x8 ( $sp ) # memo $ra
    sw $a0 , 0x4 ( $sp ) # memo $a0
    sw $s0 , 0x0 ( $sp ) # memo $s0
    beq $a0 , $0 , n_is_zero # n = 0
    addi $t0 , $0 , 0 #initial $t0 = 0
    slti $t0 , $a0 , 2 # if n < 2  =>  $t0 = 1
    bne $t0 , $0 , n_is_one # n = 1
    addi $a0 , $a0 , -1 # n = n - 1
    jal fib
    add $s0 , $v0 , $0
    lw $a0 , 0x4 ( $sp )
    addi $a0 , $a0 , -2 # n = n - 2
    jal fib
    add $v0 , $v0 , $s0
    lw $s0 ,0x0 ( $sp )
    lw $ra ,0x8 ( $sp )
    addi $sp , $sp , 12
    jr $ra

n_is_zero :
    lw $s0 ,0x0 ( $sp )
    lw $ra ,0x8 ( $sp )
    addi $sp , $sp , 12
    addi $v0 ,$0, 0
    jr $ra

n_is_one :
    lw $s0 ,0x0 ( $sp )
    lw $ra ,0x8 ( $sp )
    addi $sp , $sp , 12
    addi $v0 , $0 , 1
    jr $ra

exit:
