#Mergesort for benchmarking
#Optimized for 512 bit I$ 1024 bit D$
#Author Adam Hendrickson ahendri@purdue.edu

org 0x0000
  ori   $fp, $zero, 0xFFFC
  ori   $sp, $zero, 0xFFFC
  ori   $a0, $zero, data
  lw    $s0, size($zero)
  srl   $a1, $s0, 1
  or    $s1, $zero, $a0
  or    $s2, $zero, $a1
  jal   insertion_sort
  srl   $t0, $s0, 1
  subu  $a1, $s0, $t0
  sll   $t0, $t0, 2
  ori   $a0, $zero, data
  addu  $a0, $a0, $t0
  or    $s3, $zero, $a0
  or    $s4, $zero, $a1
  jal   insertion_sort
  or    $a0, $zero, $s1
  or    $a1, $zero, $s2
  or    $a2, $zero, $s3
  or    $a3, $zero, $s4
  ori   $t0, $zero, sorted
  push  $t0
  jal   merge
  addiu $sp, $sp, 4
  halt



#void insertion_sort(int* $a0, int $a1)
# $a0 : pointer to data start
# $a1 : size of array
#--------------------------------------
insertion_sort:
  ori   $t0, $zero, 4
  sll   $t1, $a1, 2
is_outer:
  sltu  $at, $t0, $t1
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
cfw 100
data:
cfw 0x087d
cfw 0x5fcb
cfw 0xa41a
cfw 0x4109
cfw 0x4522
cfw 0x700f
cfw 0x766d
cfw 0x6f60
cfw 0x8a5e
cfw 0x9580
cfw 0x70a3
cfw 0xaea9
cfw 0x711a
cfw 0x6f81
cfw 0x8f9a
cfw 0x2584
cfw 0xa599
cfw 0x4015
cfw 0xce81
cfw 0xf55b
cfw 0x399e
cfw 0xa23f
cfw 0x3588
cfw 0x33ac
cfw 0xbce7
cfw 0x2a6b
cfw 0x9fa1
cfw 0xc94b
cfw 0xc65b
cfw 0x0068
cfw 0xf499
cfw 0x5f71
cfw 0xd06f
cfw 0x14df
cfw 0x1165
cfw 0xf88d
cfw 0x4ba4
cfw 0x2e74
cfw 0x5c6f
cfw 0xd11e
cfw 0x9222
cfw 0xacdb
cfw 0x1038
cfw 0xab17
cfw 0xf7ce
cfw 0x8a9e
cfw 0x9aa3
cfw 0xb495
cfw 0x8a5e
cfw 0xd859
cfw 0x0bac
cfw 0xd0db
cfw 0x3552
cfw 0xa6b0
cfw 0x727f
cfw 0x28e4
cfw 0xe5cf
cfw 0x163c
cfw 0x3411
cfw 0x8f07
cfw 0xfab7
cfw 0x0f34
cfw 0xdabf
cfw 0x6f6f
cfw 0xc598
cfw 0xf496
cfw 0x9a9a
cfw 0xbd6a
cfw 0x2136
cfw 0x810a
cfw 0xca55
cfw 0x8bce
cfw 0x2ac4
cfw 0xddce
cfw 0xdd06
cfw 0xc4fc
cfw 0xfb2f
cfw 0xee5f
cfw 0xfd30
cfw 0xc540
cfw 0xd5f1
cfw 0xbdad
cfw 0x45c3
cfw 0x708a
cfw 0xa359
cfw 0xf40d
cfw 0xba06
cfw 0xbace
cfw 0xb447
cfw 0x3f48
cfw 0x899e
cfw 0x8084
cfw 0xbdb9
cfw 0xa05a
cfw 0xe225
cfw 0xfb0c
cfw 0xb2b2
cfw 0xa4db
cfw 0x8bf9
cfw 0x12f7

org 0x500
sorted:
