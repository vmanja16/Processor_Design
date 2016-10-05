#Mergesort for benchmarking
#Optimized for 512 bit I$ 1024 bit D$
#Author Adam Hendrickson ahendri@purdue.edu

org 0x0000
  ori   $fp, $zero, 0xFFFC # 0
  ori   $sp, $zero, 0xFFFC # 4
  ori   $a0, $zero, data   # 8
  lw    $s0, size($zero)   # C
  srl   $a1, $s0, 1        # 10
  or    $s1, $zero, $a0    # 14
  or    $s2, $zero, $a1    # 18
  jal   insertion_sort     # 1C
  srl   $t0, $s0, 1        # 20
  subu  $a1, $s0, $t0      # 24
  sll   $t0, $t0, 2        # 28
  ori   $a0, $zero, data   # 2C
  addu  $a0, $a0, $t0      # 30
  or    $s3, $zero, $a0    # 34
  or    $s4, $zero, $a1    # 38
  jal   insertion_sort     # 3C
  or    $a0, $zero, $s1    # 40
  or    $a1, $zero, $s2    # 44
  or    $a2, $zero, $s3    # 48
  or    $a3, $zero, $s4    # 4C
  ori   $t0, $zero, sorted # 50
  push  $t0                # 54
  jal   merge              # 58
  addiu $sp, $sp, 4        # 5C
  halt                     # 60

#--------------------------------------
insertion_sort:       # 64
  ori   $t0, $zero, 4 # 68
  sll   $t1, $a1, 2   # 6C
is_outer:             
  sltu  $at, $t0, $t1 # 6C
  beq   $at, $zero, is_end
  addu  $t9, $a0, $t0
  lw    $t8, 0($t9)
is_inner:
  beq   $t9, $a0, is_inner_end
  lw    $t7, -4($t9)
  slt   $at, $t8, $t7
  beq   $at, $zero, is_inner_end
  sw    $t7, 0($t9)
  addiu $t9, $t9, -4
  j     is_inner
is_inner_end:
  sw    $t8, 0($t9)
  addiu $t0, $t0, 4
  j     is_outer
is_end:
  jr    $ra
#--------------------------------------

#void merge(int* $a0, int $a1, int* $a2, int $a3, int* dst)
# $a0 : pointer to list 1
# $a1 : size of list 1
# $a2 : pointer to list 2
# $a3 : size of list 2
# dst [$sp+4] : pointer to merged list location
#--------------------------------------
merge:
  lw    $t0, 0($sp)
m_1:
  bne   $a1, $zero, m_3
m_2:
  bne   $a3, $zero, m_3
  j     m_end
m_3:
  beq   $a3, $zero, m_4
  beq   $a1, $zero, m_5
  lw    $t1, 0($a0)
  lw    $t2, 0($a2)
  slt   $at, $t1, $t2
  beq   $at, $zero, m_3a
  sw    $t1, 0($t0)
  addiu $t0, $t0, 4
  addiu $a0, $a0, 4
  addiu $a1, $a1, -1
  j     m_1
m_3a:
  sw    $t2, 0($t0)
  addiu $t0, $t0, 4
  addiu $a2, $a2, 4
  addiu $a3, $a3, -1
  j     m_1
m_4:  #left copy
  lw    $t1, 0($a0)
  sw    $t1, 0($t0)
  addiu $t0, $t0, 4
  addiu $a1, $a1, -1
  addiu $a0, $a0, 4
  beq   $a1, $zero, m_end
  j     m_4
m_5:  # right copy
  lw    $t2, 0($a2)
  sw    $t2, 0($t0)
  addiu $t0, $t0, 4
  addiu $a3, $a3, -1
  addiu $a2, $a2, 4
  beq   $a3, $zero, m_end
  j     m_5
m_end:
  jr    $ra
#--------------------------------------


org 0x300
size:
cfw 3
data:
cfw 3
cfw 2
cfw 1

org 0x500
sorted:
