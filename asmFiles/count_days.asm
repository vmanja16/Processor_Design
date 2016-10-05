  org 0x0000
  ori $29, $0, 0xfffc

  ori $2, $0, 0x0013  # $2 <- day  
  ori $3, $0, 0x0008  # $3 <- month
  ori $6, $0, 0x07e0  # $6 <- year

  # REGISTER 10 is Temporary Register
  ori $10, $0, 0x07d0 # $10 <- 2000

  subu $6, $6, $10      # $6 <- year-2000
  ori $10, $0, 0x016D  # $10 <- 365
  push $10
  push $6
  jal mult
  pop $6               #  $6 <- 365*(year-2000)

  ori $10, $0, 0x0001  
  subu $3, $3, $10     #  $3 <- month -1
  ori $10, $0, 0x001e  #  $10 <- 30
  push $3
  push $10
  jal mult
  pop $3               # $3 <- 30 * (month -1)

  addu $2, $2, $3      # $2 <- day + 30*(month-1) 
  addu $2, $2, $6      # $2 <- day + 30*(month-1) + 365*(year-2000)
  push $2
  halt


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
  sub $7, $7, $4      # decrement $7       #
  j loop                                   #
done:                                      #
  push $9                                  #
  jr $31                                   #
############################################
