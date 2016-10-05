  org 0x0000  # Start at 0
  ori $29, $0, 0xfffc # Initialize SP
  ori $6, $0, 0x000A  # Initilialize Operands
  push $6             
  ori $5, $29, 0x0000 # $5 <- SP for stack top
  push $6
  push $6
  push $6
loop1:
  beq $29, $5,done1 # Check $5 == stack_top
############################################
#         Multiply Subroutine              #
############################################
mult:                                      #
  ori $9, $0, 0x0000  # $9 <- 0 result reg #
  ori $4, $1, 0x0001  # $4 <-1 decrementer #
  pop $7              # $7 <- op1          #
  pop $8              # $8 <- op2          #
loop:                                      #
  beq $7, $0, done      # branch if 0      #
  addu $9, $9, $8       # $9 <- $9 + $8    #
  sub $7, $7, $4                           #
  j loop                                   #
done:                                      #
  push $9                                  #
############################################
  j loop1  

done1:
  halt

  
