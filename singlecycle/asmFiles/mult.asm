 # DO NOT USE SUBLIME
  org 0x0000          # Setting Origin at 0
  ori $29, $0, 0xfffc # Loading Stack Pointer
  ori $5, $0, 0x00FF  # initialize first operanD
  ori $6, $0, 0x00FF  # initialize second operand
  ori $9, $0, 0x0000  # $9 <- 0 result reg
  ori $4, $1, 0x0001  # $4 <-1 decrementer
  push $5             # push op1
  push $6             # push op2
  pop $7              # $7 <- op1
  pop $8              # $8 <- op2
loop:
  beq $7, $0, done      # branch if 0 
  addu $9, $9, $8       # $9 <- $9 + $8
  sub $7, $7, $4
  j loop
done: 
  push $9
  halt
