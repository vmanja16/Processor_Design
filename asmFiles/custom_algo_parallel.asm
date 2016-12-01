#REGISTERS
#at $1 at
#v $2-3 function returns
#a $4-7 function args
#t $8-15 temps
#s $16-23 saved temps (callee preserved)
#t $24-25 temps
#k $26-27 kernel
#gp $28 gp (callee preserved)
#sp $29 sp (callee preserved)
#fp $30 fp (callee preserved)
#ra $31 return address

# SUBROUTINE REFERENCE 
#crc
# USAGE random0 = crc(seed), random1 = crc(random0)
#       randomN = crc(randomN-1)

# $v0 = crc32($a0)

#-divide(N=$a0,D=$a1) returns (Q=$v0,R=$v1)--------

#-max (a0=a,a1=b) returns v0=max(a,b)--------------

#-min (a0=a,a1=b) returns v0=min(a,b)--------------



#----------------------------------------------------------
# First Processor
#----------------------------------------------------------


  org 0x000
  #ori $sp, $0, 0x3FF0   # init SP
  ori $s7,  $0, 256 
  ori $s6,  $0, 40       # out of range flag
  ori $s5,  $0, 0xbabe   # "random" seed
  ori $s4,  $0, 0        # value generated, max 256
  ori $s3,  $0, 10       # MAX buffer size
  ori $s2,  $0, 0        # buffer size (0 - 10)
  ori $s1,  $0, 0        # buffer pointer (HEAD)
  ori $s0,  $0, 0        # holds produced data

  
produce:

  lw  $s2, buffSize($0)  #load current size
  beq $s2, $s3 , produce   #If max
  

  beq  $s4, $s7, endP0

  ori $a0, $0, lockval
  jal lock 

  lw  $s2, buffSize($0) #load current size
  addiu $s2, $s2, 1 #incremented size
  sw    $s2, buffSize($0) #store incremented size

  ori $a0, $s5, 0 #use seed as argument
  jal crc32       #get random number

  addiu $t0, $s1, buffer      #buffer head true location
  sw  $v0, 0($t0)             #store value on ring buffer

  ori   $s5, $v0, 0x0000        #update seed

  addiu $s1, $s1, 0x0004            #increment head
  jal buffReset

  ori $a0, $0, lockval
  jal unlock #release the lock



  ori $t0, $0, 256 #max values should generate
  addiu $s4, $s4, 1
  ori $t2, $0, 256
  beq   $s4, $t0, endP0
  j produce

buffReset:
  beq $s1, $s6, reset_h
  jr  $ra
reset_h:
  ori $s1, $0, 0
  jr  $ra

endP0:
  ori $t5, $0, 256
  sw $t5, finishSignal($0)
  halt



#----------------------------------------------------------
# Second Processor
#---------------------------------------------------------- 

org 0x300
ori $sp, $0, 0x3FF0 #init SP
ori $s2, $0, 40
ori $s3, $0, 1
ori $s4, $0, 0      #clear buffer
ori $s5, $0, 0xFFFF #clear min
ori $s6, $0, 0x0000 #clear max
ori $s7, $0, 0x0000 #clear sum

consume:

  lw $t3, buffSize($0)       #Wait if empty
  beq $t3, $0, isEndP1

  ori $a0, $0, lockval
  jal lock

  lw $t3, buffSize($0)        #wait if empty
  ori  $t0, $0, 1
  subu $t3, $t3, $t0          #t3--; buffSize = t3
  sw    $t3, buffSize($0)

  addiu  $t4, $s4, buffer    #buffer tail address
  lw    $t1, 0($t4)          #load from buffer
    
  ori    $a1, $t1, 0         #set current val in argument pos
  andi   $a1, $a1, 0xFFFF

  addiu $s4, $s4, 4         #increment tail 
  jal   resettail


  ori   $a0, $s5, 0
  jal   min                 #min
  ori   $s5, $v0, 0

  ori   $a0, $s6, 0
  jal   max                 #max
  ori   $s6, $v0, 0

  addu  $s7, $s7, $a1       #update sum

  ori $a0, $0, lockval
  jal unlock


  j consume                 #END scope


endP1:
  
  sw  $s5, minval($0)
  sw  $s6, maxval($0)

  srl $s7, $s7, 4
  srl $s7, $s7, 4
  sw  $s7, avgval($0)

  halt

isEndP1:
  lw  $t0, finishSignal($0) #check finish signal from p0
  beq $t0, $0, consume
  j endP1

resettail:
  beq $s4, $s2, reset_t
  jr  $ra
reset_t:
  ori $s4, $0, 0
  jr  $ra

 
finishSignal:
  cfw 0x000


# pass in an address to lock function in argument register 0
# returns when lock is available
lock:
aquire:
  ll    $t0, 0($a0)         # load lock location
  bne   $t0, $0, aquire     # wait on lock to be open
  addiu $t0, $t0, 1
  sc    $t0, 0($a0)
  beq   $t0, $0, lock       # if sc failed retry
  jr    $ra


# pass in an address to unlock function in argument register 0
# returns when lock is free
unlock:
  sw    $0, 0($a0)
  jr    $ra

lockval:
  cfw   0x0000


### CRC ----------------------------------------------
#REGISTERS
#at $1 at
#v $2-3 function returns
#a $4-7 function args
#t $8-15 temps
#s $16-23 saved temps (callee preserved)
#t $24-25 temps
#k $26-27 kernel
#gp $28 gp (callee preserved)
#sp $29 sp (callee preserved)
#fp $30 fp (callee preserved)
#ra $31 return address

# USAGE random0 = crc(seed), random1 = crc(random0)
#       randomN = crc(randomN-1)
#------------------------------------------------------
# $v0 = crc32($a0)
crc32:
  lui $t1, 0x04C1
  ori $t1, $t1, 0x1DB7
  or $t2, $0, $0
  ori $t3, $0, 32

l1:
  slt $t4, $t2, $t3
  beq $t4, $zero, l2

  srl $t4, $a0, 31
  sll $a0, $a0, 1
  beq $t4, $0, l3
  xor $a0, $a0, $t1
l3:
  addiu $t2, $t2, 1
  j l1
l2:
  or $v0, $a0, $0
  jr $ra
#------------------------------------------------------

## MAX-MIN ----------------------------------------
# registers a0-1,v0,t0
# a0 = a
# a1 = b
# v0 = result

#-max (a0=a,a1=b) returns v0=max(a,b)
max:
  push  $ra
  push  $a0
  push  $a1
  or    $v0, $0, $a0
  slt   $t0, $a0, $a1
  beq   $t0, $0, maxrtn
  or    $v0, $0, $a1
maxrtn:
  pop   $a1
  pop   $a0
  pop   $ra
  jr    $ra
#--------------------------------------------------

#-min (a0=a,a1=b) returns v0=min(a,b)--------------
min:
  push  $ra
  push  $a0
  push  $a1
  or    $v0, $0, $a0
  slt   $t0, $a1, $a0
  beq   $t0, $0, minrtn
  or    $v0, $0, $a1
minrtn:
  pop   $a1
  pop   $a0
  pop   $ra
  jr    $ra
#--------------------------------------------------

  

buffSize:       
  cfw 0x000


#Global Constants
org 0x0800

minval:
  cfw 0xFFFF
maxval:
  cfw 0x0000
avgval:
  cfw 0xFFFF

#data 
buffer:
  cfw 0x0000
  cfw 0x0000
  cfw 0x0000
  cfw 0x0000
  cfw 0x0000
  cfw 0x0000
  cfw 0x0000
  cfw 0x0000
  cfw 0x0000
  cfw 0x0000
