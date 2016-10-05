#--------------------------------------
# Test branch and jumps
#--------------------------------------
  org 0x0000
  ori   $1, $zero, 0xBA5C # 00
  ori   $2, $zero, 0x0080 # 04
  ori   $15, $zero, jmpR  # 08
  beq   $zero, $zero, braZ #0c
  sw    $1, 0($2)       # 10
braZ:
  jal   braR        #14
  sw    $1, 4($2)   #18
end:
  sw    $ra, 16($2) #1c
  HALT              #20
braR:
  or    $3, $zero, $ra #24
  sw    $ra, 8($2)  #28
  jal   jmpR     #2c
  sw    $1, 12($2)  #30
jmpR:                
  bne   $ra, $3, end #34
  halt                #38
