! Copyright (C) 2013 Joseph Moschini.
! See http://factorcode.org/license.txt for BSD license.
!

USING: accessors arrays io io.encodings.binary io.files
       intel.hex
       kernel lexer intel.8051.emulator.psw intel.8051.emulator.register
       intel.8051.emulator.memory
       math math.bitwise namespaces sequences
       tools.continuations ;


IN: intel.8051.emulator

! Table of Oscillator Periods
CONSTANT: period-seq {
        12 24 24 12 12 12 12 12 12 12 12 12 12 12 12 12
        24 24 24 12 12 12 12 12 12 12 12 12 12 12 12 12
        24 24 24 12 12 12 12 12 12 12 12 12 12 12 12 12
        24 24 24 12 12 12 12 12 12 12 12 12 12 12 12 12
        24 24 12 24 12 12 12 12 12 12 12 12 12 12 12 12
        24 24 12 24 12 12 12 12 12 12 12 12 12 12 12 12
        24 24 12 24 12 12 12 12 12 12 12 12 12 12 12 12
        24 24 24 24 12 24 12 12 12 12 12 12 12 12 12 12
        24 24 24 24 48 24 24 24 24 24 24 24 24 24 24 24
        24 24 24 24 12 12 12 12 12 12 12 12 12 12 12 12
        24 24 12 24 48 12 24 24 24 24 24 24 24 24 24 24
        24 24 12 24 24 24 24 24 24 24 24 24 24 24 24 24
        24 24 12 12 12 12 12 12 12 12 12 12 12 12 12 12
        24 24 12 12 12 24 12 12 24 24 24 24 24 24 24 24
        24 24 24 24 12 12 12 12 12 12 12 12 12 12 12 12
        24 24 24 24 12 12 12 12 12 12 12 12 12 12 12 12
    } 

! Table of number of bytes for each opcode
CONSTANT: nbytes-seq {
        1 2 3 1 1 2 1 1 1 1 1 1 1 1 1 1
        3 2 3 1 1 2 1 1 1 1 1 1 1 1 1 1
        3 2 1 1 2 2 1 1 1 1 1 1 1 1 1 1
        3 2 1 1 2 2 1 1 1 1 1 1 1 1 1 1
        2 2 2 3 2 2 1 1 1 1 1 1 1 1 1 1
        2 2 2 3 2 2 1 1 1 1 1 1 1 1 1 1
        2 2 2 3 3 3 1 1 1 1 1 1 1 1 1 1
        2 2 2 1 2 3 2 2 2 2 2 2 2 2 2 2
        2 2 2 1 1 3 2 2 2 2 2 2 2 2 2 2
        3 2 2 1 2 2 1 1 1 1 1 1 1 1 1 1
        2 2 2 1 1 1 2 2 2 2 2 2 2 2 2 2
        2 2 2 1 3 3 3 3 3 3 3 3 3 3 3 3
        2 2 2 1 1 2 1 1 1 1 1 1 1 1 1 1
        2 2 2 1 1 3 1 1 2 2 2 2 2 2 2 2
        1 2 1 1 1 2 1 1 1 1 1 1 1 1 1 1
        1 2 1 1 1 2 1 1 1 1 1 1 1 1 1 1
    }

TUPLE: cpu hp lp b psw dptr sp pc rom memory opcodes bytes cycles ;

! write to PSW
: >PSW ( b cpu -- )
    psw>> psw-write ;

! read PSW
: PSW> ( cpu -- b )
    psw>> psw-read ;


! write to ACC
: >A ( b cpu -- )
  memory>>
  RAM_A swap
  ram-direct-write ;

! read ACC
: A> ( cpu -- b )
  memory>>
  RAM_A swap
  ram-direct-read  ;

! write to B
: >B ( b cpu -- )
  memory>>
  RAM_B swap
  ram-direct-write ;

! read B
: B> ( cpu -- b )
  memory>>
  RAM_B swap
  ram-direct-read  ;
  
! write to R0
: >R0 ( b cpu -- )
  [ psw>> psw-bank-read ] keep ! get the bank value
  -rot
  8 *                          ! 8 registers by bank number
  rot
  memory>> ram-direct-write
  ;

: R0> ( cpu -- b )
  [ psw>> psw-bank-read ] keep ! get the reg bank value
  swap 8 *  ! get the address
  swap memory>> ram-direct-read ;

: @R0> ( cpu -- b )
   [ R0> ] keep memory>> ram-indirect-read ;  

: >@R0 ( b cpu -- )
   [ R0> ] keep memory>> ram-indirect-write ;
   
: >R1 ( b cpu -- )
  [ psw>> psw-bank-read ] keep ! get the bank value
  -rot
  8 * 1 +                      ! 8 registers by bank number
  rot
  memory>> ram-direct-write ;

: R1> ( cpu -- b )
  [ psw>> psw-bank-read ] keep ! get the reg bank value
  swap 8 * 1 +  ! get the address
  swap memory>> ram-direct-read ;

: @R1> ( cpu -- b )
   [ R1> ] keep memory>> ram-indirect-read ;  

: >@R1 ( b cpu -- )
   [ R1> ] keep memory>> ram-indirect-write ;  
  

: >R2 ( b cpu -- )
  [ psw>> psw-bank-read ] keep ! get the bank value
  -rot
  8 * 2 +                      ! 8 registers by bank number
  rot
  memory>> ram-direct-write ;

: R2> ( cpu -- b )
  [ psw>> psw-bank-read ] keep ! get the reg bank value
  swap 8 * 2 + ! get the address
  swap memory>> ram-direct-read ;


: >R3 ( b cpu -- )
  [ psw>> psw-bank-read ] keep ! get the bank value
  -rot
  8 * 3 +                      ! 8 registers by bank number
  rot
  memory>> ram-direct-write ;

: R3> ( cpu -- b )
  [ psw>> psw-bank-read ] keep ! get the reg bank value
  swap 8 * 3 +  ! get the address
  swap memory>> ram-direct-read ;

: >R4 ( b cpu -- )
  [ psw>> psw-bank-read ] keep ! get the bank value
  -rot
  8 * 4 +                          ! 8 registers by bank number
  rot
  memory>> ram-direct-write ;

: R4> ( cpu -- b )
  [ psw>> psw-bank-read ] keep ! get the reg bank value
  swap 8 * 4 +  ! get the address
  swap memory>> ram-direct-read ;

: >R5 ( b cpu -- )
  [ psw>> psw-bank-read ] keep ! get the bank value
  -rot
  8 * 5 +                          ! 8 registers by bank number
  rot
  memory>> ram-direct-write ;

: R5> ( cpu -- b )
  [ psw>> psw-bank-read ] keep ! get the reg bank value
  swap 8 * 5 +  ! get the address
  swap memory>> ram-direct-read ;

: >R6 ( b cpu -- )
  [ psw>> psw-bank-read ] keep ! get the bank value
  -rot
  8 * 6 +                      ! 8 registers by bank number
  rot
  memory>> ram-direct-write
  ;

: R6> ( cpu -- b )
  [ psw>> psw-bank-read ] keep ! get the reg bank value
  swap 8 * 6 +  ! get the address
  swap memory>> ram-direct-read ;

: >R7 ( b cpu -- )
  [ psw>> psw-bank-read ] keep ! get the bank value
  -rot
  8 * 7 +                      ! 8 registers by bank number
  rot
  memory>> ram-direct-write ;

: R7> ( cpu -- b )
  [ psw>> psw-bank-read ] keep ! get the reg bank value
  swap 8 * 7 +  ! get the address
  swap memory>> ram-direct-read ;



! get DPTR 16 bit number
: DPTR> ( cpu -- n )
    [ RAM_DPH ] dip [ memory>> ram-direct-read 8 shift ] keep
    [ RAM_DPL ] dip memory>> ram-direct-read bitor 16 bits ;

! write 16 bit value into DPTR
: >DPTR ( w cpu -- )
    [ dup 15 8 bit-range ] dip [ RAM_DPH ] dip [ memory>> ram-direct-write ] keep
    [ 7 0 bit-range ] dip [ RAM_DPL ] dip memory>> ram-direct-write ;

! increment the pc of cpu
: pc+ ( cpu -- )
  dup pc>> 1 + 16 0 bit-range swap pc<< ;
    
! read the data from rom
: rom-read ( a cpu -- d )
    rom>> ?nth dup [ ] [ ] if 8 bits ;

! read 16 bit data from ROM
: rom-read-word ( address cpu -- dddd )
  [ rom>> ?nth 8 shift ] 2keep swap 1 + swap rom>> ?nth bitor 16 bits ;
    
! read the rom addressed by pc
: rom-pc-read ( cpu -- dd )
  dup pc>> swap rom>> ?nth
  dup
  [ ]
  [ drop 0 ] if
  ;

! read data at pc address then return the number byte the data opcode is associated with
: rom-pc-nbytes ( cpu -- n )
    rom-pc-read nbytes-seq nth ;

! read data at pc address the return the period value for the opcode
: rom-pc-period ( cpu -- n )
    rom-pc-read period-seq nth ;

! do some stack pointer functions
! increment the sp
: sp+ ( cpu -- )
  [ sp>> 1 + 8 bits ] keep sp<< ;

! decrement the sp
: sp- ( cpu -- )
  [ sp>> 1 - 8 bits ] keep sp<< ;

! write to ram sp has address
: sp-write ( n cpu -- )
  [ sp>> ] keep
  memory>> ram-indirect-write ;

! push a byte onto the stack pointer
: sp-push ( b cpu -- )
  [ 7 0 bit-range ] dip ! make sure its a byte
  [ sp+ ] keep
  sp-write ;

: sp-pop ( cpu -- b )
  [ sp>> ] keep [ sp- ] keep
  memory>> ram-indirect-read ;

! save the contents of pc to sp
: pc->(sp) ( cpu -- )
  [ pc>> 15 8 bit-range ] keep [ pc>> 7 0 bit-range ] keep
  [ sp-push ] keep sp-push ;

! get the data from stack pointer into PC
: (sp)->pc ( cpu -- )
  [ sp-pop 8 shift ] keep [ sp-pop 8 bits ] keep
  [ bitor 16 bits ] dip
  pc<< ;




! calculate the relative address
: relative ( n a -- na )
  swap 8 >signed +
  15 0 bit-range
  ;


: (load-rom) ( n ram -- )
  read1
  [ ! n ram ch
    -rot [ set-nth ] 2keep [ 1 + ] dip (load-rom)
  ]
  [ 2drop ] if* ;

! Reads the ROM from stdin and stores it in ROM from
! offset n.
! Load the contents of the file into ROM.
! (address 0x0000-0x1FFF).
: load-rom ( filename cpu -- )
  memory>> swap binary
  [ 
    0 swap (load-rom)
  ] with-file-reader ;

: not-implemented ( cpu -- )
  drop ;

! NOP Instruction
: (opcode-00) ( cpu -- )
  pc+ ;

! AJMP
! Absolute Jump
: (opcode-01) ( cpu -- )
  [ rom-pc-read 0xe0 bitand 3 shift ] keep ! the instruction has part of address
  [ pc+ ] keep [ rom-pc-read ] keep -rot bitor swap pc<< ;

! LJMP
! Long Jump
: (opcode-02) ( cpu -- )
  [ pc+ ] keep
  [ pc>> ] keep
  [ rom-read-word ] keep pc<< ;

! RR A
! Rotate Accumulator Right
: (opcode-03) ( cpu -- )
  [ A> -1 8 bitroll ] keep [ >A ] keep pc+ ;
  
! INC A
! Increment Accumulator
: (opcode-04) ( cpu -- )
  [ A> 1 + 8 bits ] keep [ >A ] keep pc+ ;

! INC (DIR)
! Increment Data RAM or SFR
: (opcode-05) ( cpu -- )
  [ dup pc+ rom-pc-read ] keep
  [ memory>> ram-direct-read ] keep
  swap 1 + 8 bits swap [ rom-pc-read ] keep 
  [ memory>> ram-direct-write ] keep pc+ ;

! INC @R0
! Increment 8-bit internal data RAM location (0-255) addressed
! indirectly through register R0.
: (opcode-06) ( cpu -- )
  [ R0> ] keep ! get r0 value this is the adderss
  [ memory>> ram-indirect-read 1 + ] keep  ! get data from ram add 1 to data
  [ R0> ] keep      ! get the r0 address value
  [ memory>> ram-indirect-write ] keep pc+ ;   ! data is now save back into ram

! INC @R1
! Increment 8-bit internal RAM location (0 - 255) addressed
! indirectly through Register R1
: (opcode-07) ( cpu -- )
  [ R1> ] keep [ memory>> ram-indirect-read 1 + ] keep [ R1> ] keep
  [ memory>> ram-indirect-write ] keep pc+ ;

! INC R0
! Increment R0
: (opcode-08) ( cpu -- )
  [ R0> 1 + ] keep [ >R0 ] keep pc+ ;

! INC R1
! Increment R1
: (opcode-09) ( cpu -- )
  [ R1> 1 + ] keep [ >R1 ] keep pc+ ;

! INC R2
! Increment R2
: (opcode-0A) ( cpu -- )
  [ R2> 1 + ] keep [ >R2 ] keep pc+ ;


! INC R3
! Increment R3
: (opcode-0B) ( cpu -- )
  [ R3> 1 + ] keep [ >R3 ] keep pc+ ;


! INC R4
! Increment R4
: (opcode-0C) ( cpu -- )
  [ R4> 1 + ] keep [ >R4 ] keep pc+ ;

! INC R5
! Increment R5
: (opcode-0D) ( cpu -- )
  [ R5> 1 + ] keep [ >R5 ] keep pc+ ;


! INC R6
! Increment R6
: (opcode-0E) ( cpu -- )
  [ R6> 1 + ] keep [ >R6 ] keep pc+ ;

! INC R7
! Increment R7
: (opcode-0F) ( cpu -- )
  [ R7> 1 + ] keep [ >R7 ] keep pc+ ;

! JBC bit,rel
! clear bit and Jump relative if bit is set
: (opcode-10) ( cpu -- )
  [ pc+ ] keep ! pc now point to bit address
  [ rom-pc-read ] keep ! read value
  [ memory>> ram-bitstatus ] keep  ! bit status should be on stack
  swap
  [
    [ rom-pc-read ] keep
    [ memory>> ram-bitclr ] keep
    [ pc+ ] keep
    [ rom-pc-read ] keep
    [ pc+ ] keep
    [ pc>> relative ] keep pc<<
  ]
  [
    [ pc+ ] keep pc+
  ]
  if
  ;


! ACALL
! Absolute Call
: (opcode-11) ( cpu -- )
  [
    rom-pc-read 15 13 bit-range 8 shift
  ] keep ! the instruction part of address
  [ pc+ ] keep
  [ rom-pc-read ] keep
  [ pc+ ] keep
  [ pc->(sp) ] keep
  -rot bitor swap pc<< ;

! LCALL
! Long Call
: (opcode-12) ( cpu -- )
  [ pc+ ] keep
  [ rom-pc-read ] keep
  [ pc+ ] keep
  [ rom-pc-read ] keep
  [ pc+ ] keep
  [ pc->(sp) ] keep
  -rot [ 8 shift ] dip bitor swap pc<< ;


! RRC A
! Rotate Right A through Carry
: (opcode-13) ( cpu -- )
  [ A> ] keep [ psw>> psw-rrc ] keep [ >A ] keep pc+ ;


! DEC A
: (opcode-14) ( cpu -- )
  [ A> 1 - 8 bits ] keep [ >A ] keep pc+ ;  

! DEC (DIR)
! Decrement Data RAM or SFR
: (opcode-15) ( cpu -- )
  [ dup pc+ rom-pc-read ] keep
  [ memory>> ram-direct-read ] keep
  swap 1 - 8 bits swap [ rom-pc-read ] keep 
  [ memory>> ram-direct-write ] keep pc+ ;

! DEC @R0
! Decrement 8-bit internal data RAM location (0-255) addressed
! indirectly through register R0.
: (opcode-16) ( cpu -- )
  [ R0> ] keep ! get r0 value this is the adderss
  [ memory>> ram-indirect-read 1 - 8 bits ] keep  ! get data from ram add 1 to data
  [ R0> ] keep      ! get the r0 address value
  [ memory>> ram-indirect-write ] keep pc+ ;   ! data is now save back into ram

! DEC @R1
! Decrement 8-bit internal data RAM location (0-255) addressed
! indirectly through register R1.
: (opcode-17) ( cpu -- )
  [ R1> ] keep ! get r0 value this is the adderss
  [ memory>> ram-indirect-read 1 - 8 bits ] keep  ! get data from ram add 1 to data
  [ R1> ] keep      ! get the r0 address value
  [ memory>> ram-indirect-write ] keep pc+ ;   ! data is now save back into ram


! DEC R0
! Decrement R0
: (opcode-18) ( cpu -- )
  [ R0> 1 - ] keep [ >R0 ] keep pc+ ;

! DEC R1
! Decrement R1
: (opcode-19) ( cpu -- )
  [ R1> 1 - ] keep [ >R1 ] keep pc+ ;

! DEC R2
! Decrement R2
: (opcode-1A) ( cpu -- )
  [ R2> 1 - ] keep [ >R2 ] keep pc+ ;

! DEC R3
! Decrement R3
: (opcode-1B) ( cpu -- )
  [ R3> 1 - ] keep [ >R3 ] keep pc+ ;


! DEC R4
! Decrement R4
: (opcode-1C) ( cpu -- )
  [ R4> 1 - ] keep [ >R4 ] keep pc+ ;

! DEC R5
! Decrement R5
: (opcode-1D) ( cpu -- )
  [ R5> 1 - ] keep [ >R5 ] keep pc+ ;

! DEC R6
! Decrement R6
: (opcode-1E) ( cpu -- )
  [ R6> 1 - ] keep [ >R6 ] keep pc+ ;

! DEC R7
! Decrement R7
: (opcode-1F) ( cpu -- )
  [ R7> 1 - ] keep [ >R7 ] keep pc+ ;


! JB bit,rel
! Jump relative if bit is set
: (opcode-20) ( cpu -- )
  [ pc+ ] keep ! pc now point to bit address
  [ rom-pc-read ] keep ! read value
  [ memory>> ram-bitstatus ] keep  ! bit status should be on stack
  swap
  [
    [ pc+ ] keep
    [ rom-pc-read ] keep
    [ pc+ ] keep
    [ pc>> relative ] keep pc<<
  ]
  [
    [ pc+ ] keep pc+
  ]
  if
  ;

! AJMP
! Absolute Jump
: (opcode-21) ( cpu -- )
  (opcode-01) ;

! RET
! Return from subroutine pop PC off the stack
: (opcode-22) ( cpu -- )
  (sp)->pc ;
  
! RL A
! Rotate Accumulator Left
: (opcode-23) ( cpu -- )
  [ A> 1 8 bitroll ] keep [ >A ] keep pc+ ;

! ADD A,#data
: (opcode-24) ( cpu -- )
    [ A> ] keep [ pc+ ] keep [ rom-pc-read ] keep
    0 swap ! carry bit
    [ psw>> psw-add ] keep
    [ >A ] keep pc+ ;

! ADD A,dir
: (opcode-25) ( cpu -- )
    [ A> ] keep
    [ dup pc+ rom-pc-read ] keep [ memory>> ram-direct-read ] keep
    0 swap
    [ psw>> psw-add ] keep
    [ >A ] keep pc+ ;

! ADD A,@R0
: (opcode-26) ( cpu -- )
  [ A> ] keep
  [ @R0> ] keep
  0 swap
  [ psw>> psw-add ] keep
  [ >A ] keep pc+ ;
  
! ADD A,@R1
: (opcode-27) ( cpu -- )
  [ A> ] keep
  [ @R1> ] keep
  0 swap
  [ psw>> psw-add ] keep
  [ >A ] keep pc+ ;

! ADD A,R0
: (opcode-28) ( cpu -- )
    [ A> ] keep
    [ R0> ] keep
    0 swap
    [ psw>> psw-add ] keep
    [ >A ] keep pc+ ;

! ADD A,R1
: (opcode-29) ( cpu -- )
    [ A> ] keep
    [ R1> ] keep
    0 swap
    [ psw>> psw-add ] keep
    [ >A ] keep pc+ ;    

! ADD A,R2
: (opcode-2A) ( cpu -- )
    [ A> ] keep
    [ R2> ] keep
    0 swap
    [ psw>> psw-add ] keep
    [ >A ] keep pc+ ;

! ADD A,R3
: (opcode-2B) ( cpu -- )
    [ A> ] keep
    [ R3> ] keep
    0 swap
    [ psw>> psw-add ] keep
    [ >A ] keep pc+ ;

! ADD A,R4
: (opcode-2C) ( cpu -- )
    [ A> ] keep
    [ R4> ] keep
    0 swap
    [ psw>> psw-add ] keep
    [ >A ] keep pc+ ;

! ADD A,R5
: (opcode-2D) ( cpu -- )
    [ A> ] keep
    [ R5> ] keep
    0 swap
    [ psw>> psw-add ] keep
    [ >A ] keep pc+ ;

! ADD A,R6
: (opcode-2E) ( cpu -- )
    [ A> ] keep
    [ R6> ] keep
    0 swap
    [ psw>> psw-add ] keep
    [ >A ] keep pc+ ;

! ADD A,R7
: (opcode-2F) ( cpu -- )
    [ A> ] keep
    [ R7> ] keep
    0 swap
    [ psw>> psw-add ] keep
    [ >A ] keep pc+ ;

! JNB bit,rel
! Jump relative if bit is clear
: (opcode-30) ( cpu -- )
  [ pc+ ] keep ! pc now point to bit address
  [ rom-pc-read ] keep ! read value
  [ memory>> ram-bitstatus ] keep  ! bit status should be on stack
  swap
  [ [ pc+ ] keep pc+ ]
  [
    [ pc+ ] keep
    [ rom-pc-read ] keep
    [ pc+ ] keep
    [ pc>> relative ] keep pc<<
  ]
  if ;    

! ACALL
: (opcode-31) ( cpu -- )
    (opcode-11) ;
    
! RETI
: (opcode-32) ( cpu -- )
    [ hp>> ] keep [ lp>> ] keep [ or ] dip swap
    [
        ! may need to implement some exception here
        [ hp>> ] keep swap
        [ f >>hp ]
        [ f >>lp ] if
    ]
    when 
    (opcode-22) ! to make things simple just call the ret
    ;
    
! RLC A
: (opcode-33) ( cpu -- )
  [ A> ] keep [ psw>> psw-rlc ] keep [ >A ] keep pc+ ;

! ADDC A,#data  
: (opcode-34) ( cpu -- )
    [ A> ] keep [ pc+ ] keep [ rom-pc-read ] keep
    [ psw>> psw-cy ] keep ! carry bit
    [ psw>> psw-add ] keep
    [ >A ] keep pc+ ;

! ADDC A,dir
: (opcode-35) ( cpu -- )
    [ A> ] keep
    [ dup pc+ rom-pc-read ] keep [ memory>> ram-direct-read ] keep
    [ psw>> psw-cy ] keep
    [ psw>> psw-add ] keep
    [ >A ] keep pc+ ;

! ADDC A,@R0
: (opcode-36) ( cpu -- )
  [ A> ] keep
  [ @R0> ] keep
  [ psw>> psw-cy ] keep
  [ psw>> psw-add ] keep
  [ >A ] keep pc+ ;
  
! ADDC A,@R1
: (opcode-37) ( cpu -- )
  [ A> ] keep
  [ @R1> ] keep
  [ psw>> psw-cy ] keep
  [ psw>> psw-add ] keep
  [ >A ] keep pc+ ;

! ADDC A,R0
: (opcode-38) ( cpu -- )
    [ A> ] keep
    [ R0> ] keep
    [ psw>> psw-cy ] keep
    [ psw>> psw-add ] keep
    [ >A ] keep pc+ ;

! ADDC A,R1
: (opcode-39) ( cpu -- )
    [ A> ] keep
    [ R1> ] keep
    [ psw>> psw-cy ] keep
    [ psw>> psw-add ] keep
    [ >A ] keep pc+ ;    

! ADDC A,R2
: (opcode-3A) ( cpu -- )
    [ A> ] keep
    [ R2> ] keep
    [ psw>> psw-cy ] keep
    [ psw>> psw-add ] keep
    [ >A ] keep pc+ ;

! ADDC A,R3
: (opcode-3B) ( cpu -- )
    [ A> ] keep
    [ R3> ] keep
    [ psw>> psw-cy ] keep
    [ psw>> psw-add ] keep
    [ >A ] keep pc+ ;

! ADDC A,R4
: (opcode-3C) ( cpu -- )
    [ A> ] keep
    [ R4> ] keep
    [ psw>> psw-cy ] keep
    [ psw>> psw-add ] keep
    [ >A ] keep pc+ ;

! ADDC A,R5
: (opcode-3D) ( cpu -- )
    [ A> ] keep
    [ R5> ] keep
    [ psw>> psw-cy ] keep
    [ psw>> psw-add ] keep
    [ >A ] keep pc+ ;

! ADDC A,R6
: (opcode-3E) ( cpu -- )
    [ A> ] keep
    [ R6> ] keep
    [ psw>> psw-cy ] keep
    [ psw>> psw-add ] keep
    [ >A ] keep pc+ ;

! ADDC A,R7
: (opcode-3F) ( cpu -- )
    [ A> ] keep
    [ R7> ] keep
    [ psw>> psw-cy ] keep
    [ psw>> psw-add ] keep
    [ >A ] keep pc+ ;    

! JC rel
! Jump relative if carry is set
: (opcode-40) ( cpu -- )
  [ psw>> psw-cy? ] keep  ! carry bit
  swap
  [
    [ pc+ ] keep
    [ rom-pc-read ] keep
    [ pc+ ] keep
    [ pc>> relative ] keep pc<<
  ]
  [ [ pc+ ] keep pc+ ] if ;    

! AJUMP
! Absolute Jump
: (opcode-41) ( cpu -- )
    (opcode-21) ;
    
! ORL dir,A
! Logical-OR for byte variables
: (opcode-42) ( cpu -- )
  [ pc+ ] keep [ rom-pc-read dup ] keep [ memory>> ram-direct-read ] keep
  [ A> ] keep
  [ bitor 8 bits swap ] dip
  [ memory>> ram-direct-write ] keep
  pc+ ;
  
! ORL direct,#data
: (opcode-43) ( cpu -- )
    [ pc+ ] keep [ rom-pc-read dup ] keep [ memory>> ram-direct-read ] keep
    [ pc+ ] keep [ rom-pc-read ] keep
    [ bitor 8 bits swap ] dip
    [ memory>> ram-direct-write ] keep
    pc+ ;

! ORL A,#data
: (opcode-44) ( cpu -- )
    [ A> ] keep
    [ pc+ ] keep [ rom-pc-read ] keep
    [ bitor 8 bits ] dip
    [ >A ] keep
    pc+ ;

! ORL A,direct
: (opcode-45) ( cpu -- )
    [ A> ] keep
    [ pc+ ] keep [ rom-pc-read ] keep [ memory>> ram-direct-read ] keep
    [ bitor 8 bits ] dip
    [ >A ] keep
    pc+ ;

! ORL A,@R0
: (opcode-46) ( cpu -- )
    [ A> ] keep
    [ @R0> ] keep
    [ bitor 8 bits ] dip
    [ >A ] keep
    pc+ ;
    
! ORL A,@R1
: (opcode-47) ( cpu -- )
    [ A> ] keep
    [ @R1> ] keep
    [ bitor 8 bits ] dip
    [ >A ] keep
    pc+ ;
    
    
! ORL A,R0
: (opcode-48) ( cpu -- )
    [ A> ] keep
    [ R0> ] keep
    [ bitor 8 bits ] dip
    [ >A ] keep
    pc+ ;       

! ORL A,R1
: (opcode-49) ( cpu -- )
    [ A> ] keep
    [ R1> ] keep
    [ bitor 8 bits ] dip
    [ >A ] keep
    pc+ ;           

! ORL A,R2
: (opcode-4A) ( cpu -- )
    [ A> ] keep
    [ R2> ] keep
    [ bitor 8 bits ] dip
    [ >A ] keep
    pc+ ;

! ORL A,R3
: (opcode-4B) ( cpu -- )
    [ A> ] keep
    [ R3> ] keep
    [ bitor 8 bits ] dip
    [ >A ] keep
    pc+ ;           

! ORL A,R4
: (opcode-4C) ( cpu -- )
    [ A> ] keep
    [ R4> ] keep
    [ bitor 8 bits ] dip
    [ >A ] keep
    pc+ ;       

! ORL A,R5
: (opcode-4D) ( cpu -- )
    [ A> ] keep
    [ R5> ] keep
    [ bitor 8 bits ] dip
    [ >A ] keep
    pc+ ;    
    
! ORL A,R6
: (opcode-4E) ( cpu -- )
    [ A> ] keep
    [ R6> ] keep
    [ bitor 8 bits ] dip
    [ >A ] keep
    pc+ ;           

! ORL A,R7
: (opcode-4F) ( cpu -- )
    [ A> ] keep
    [ R7> ] keep
    [ bitor 8 bits ] dip
    [ >A ] keep
    pc+ ;

! JNC Rel
! Jump relative if carry is clear
: (opcode-50) ( cpu -- )
  [ psw>> psw-cy? ] keep  ! carry bit
  swap
  [ [ pc+ ] keep pc+ ]
  [
    [ pc+ ] keep
    [ rom-pc-read ] keep
    [ pc+ ] keep
    [ pc>> relative ] keep pc<<
  ] if ;    

: (opcode-51) ( cpu -- )
    (opcode-31) ;
    
! ANL direct,A
: (opcode-52) ( cpu -- )
  [ pc+ ] keep [ rom-pc-read dup ] keep [ memory>> ram-direct-read ] keep
  [ A> ] keep
  [ bitand 8 bits swap ] dip
  [ memory>> ram-direct-write ] keep
  pc+ ;

! ANL direct,#data
: (opcode-53) ( cpu -- )
    [ pc+ ] keep [ rom-pc-read dup ] keep [ memory>> ram-direct-read ] keep
    [ pc+ ] keep [ rom-pc-read ] keep
    [ bitand 8 bits swap ] dip
    [ memory>> ram-direct-write ] keep
    pc+ ;

! ANL A,#data
: (opcode-54) ( cpu -- )
    [ A> ] keep
    [ pc+ ] keep [ rom-pc-read ] keep
    [ bitand 8 bits ] dip
    [ >A ] keep
    pc+ ;

! ANL A,direct
: (opcode-55) ( cpu -- )
    [ A> ] keep
    [ pc+ ] keep [ rom-pc-read ] keep [ memory>> ram-direct-read ] keep
    [ bitand 8 bits ] dip
    [ >A ] keep
    pc+ ;

! ANL A,@R0
: (opcode-56) ( cpu -- )
    [ A> ] keep
    [ @R0> ] keep
    [ bitand 8 bits ] dip
    [ >A ] keep
    pc+ ;
    
! ANL A,@R1
: (opcode-57) ( cpu -- )
    [ A> ] keep
    [ @R1> ] keep
    [ bitand 8 bits ] dip
    [ >A ] keep
    pc+ ;
    
    
! ANL A,R0
: (opcode-58) ( cpu -- )
    [ A> ] keep
    [ R0> ] keep
    [ bitand 8 bits ] dip
    [ >A ] keep
    pc+ ;       

! ANL A,R1
: (opcode-59) ( cpu -- )
    [ A> ] keep
    [ R1> ] keep
    [ bitand 8 bits ] dip
    [ >A ] keep
    pc+ ;           

! ANL A,R2
: (opcode-5A) ( cpu -- )
    [ A> ] keep
    [ R2> ] keep
    [ bitand 8 bits ] dip
    [ >A ] keep
    pc+ ;

! ANL A,R3
: (opcode-5B) ( cpu -- )
    [ A> ] keep
    [ R3> ] keep
    [ bitand 8 bits ] dip
    [ >A ] keep
    pc+ ;           

! ANL A,R4
: (opcode-5C) ( cpu -- )
    [ A> ] keep
    [ R4> ] keep
    [ bitand 8 bits ] dip
    [ >A ] keep
    pc+ ;       

! ANL A,R5
: (opcode-5D) ( cpu -- )
    [ A> ] keep
    [ R5> ] keep
    [ bitand 8 bits ] dip
    [ >A ] keep
    pc+ ;    
    
! ANL A,R6
: (opcode-5E) ( cpu -- )
    [ A> ] keep
    [ R6> ] keep
    [ bitand 8 bits ] dip
    [ >A ] keep
    pc+ ;           

! ANL A,R7
: (opcode-5F) ( cpu -- )
    [ A> ] keep
    [ R7> ] keep
    [ bitand 8 bits ] dip
    [ >A ] keep
    pc+ ;


! JZ
! if A = 0 jump rel
: (opcode-60) ( cpu -- )
  [ A> 0 = ] keep  ! carry bit
  swap
  [
    [ pc+ ] keep
    [ rom-pc-read ] keep
    [ pc+ ] keep
    [ pc>> relative ] keep pc<<
  ]
  [ [ pc+ ] keep pc+ ] if ;    

!
: (opcode-61) ( cpu -- )
    (opcode-41) ;


! XRL direct,A
: (opcode-62) ( cpu -- )
  [ pc+ ] keep [ rom-pc-read dup ] keep [ memory>> ram-direct-read ] keep
  [ A> ] keep
  [ bitxor 8 bits swap ] dip
  [ memory>> ram-direct-write ] keep
  pc+ ;

! XRL direct,#data
: (opcode-63) ( cpu -- )
    [ pc+ ] keep [ rom-pc-read dup ] keep [ memory>> ram-direct-read ] keep
    [ pc+ ] keep [ rom-pc-read ] keep
    [ bitxor 8 bits swap ] dip
    [ memory>> ram-direct-write ] keep
    pc+ ;

! XRL A,#data
: (opcode-64) ( cpu -- )
    [ A> ] keep
    [ pc+ ] keep [ rom-pc-read ] keep
    [ bitxor 8 bits ] dip
    [ >A ] keep
    pc+ ;

! XRL A,direct
: (opcode-65) ( cpu -- )
    [ A> ] keep
    [ pc+ ] keep [ rom-pc-read ] keep [ memory>> ram-direct-read ] keep
    [ bitxor 8 bits ] dip
    [ >A ] keep
    pc+ ;

! XRL A,@R0
: (opcode-66) ( cpu -- )
    [ A> ] keep
    [ @R0> ] keep
    [ bitxor 8 bits ] dip
    [ >A ] keep
    pc+ ;
    
! XRL A,@R1
: (opcode-67) ( cpu -- )
    [ A> ] keep
    [ @R1> ] keep
    [ bitxor 8 bits ] dip
    [ >A ] keep
    pc+ ;
    
    
! XRL A,R0
: (opcode-68) ( cpu -- )
    [ A> ] keep
    [ R0> ] keep
    [ bitxor 8 bits ] dip
    [ >A ] keep
    pc+ ;       

! XRL A,R1
: (opcode-69) ( cpu -- )
    [ A> ] keep
    [ R1> ] keep
    [ bitxor 8 bits ] dip
    [ >A ] keep
    pc+ ;           

! XRL A,R2
: (opcode-6A) ( cpu -- )
    [ A> ] keep
    [ R2> ] keep
    [ bitxor 8 bits ] dip
    [ >A ] keep
    pc+ ;

! XRL A,R3
: (opcode-6B) ( cpu -- )
    [ A> ] keep
    [ R3> ] keep
    [ bitxor 8 bits ] dip
    [ >A ] keep
    pc+ ;           

! XRL A,R4
: (opcode-6C) ( cpu -- )
    [ A> ] keep
    [ R4> ] keep
    [ bitxor 8 bits ] dip
    [ >A ] keep
    pc+ ;       

! XRL A,R5
: (opcode-6D) ( cpu -- )
    [ A> ] keep
    [ R5> ] keep
    [ bitxor 8 bits ] dip
    [ >A ] keep
    pc+ ;    
    
! XRL A,R6
: (opcode-6E) ( cpu -- )
    [ A> ] keep
    [ R6> ] keep
    [ bitxor 8 bits ] dip
    [ >A ] keep
    pc+ ;           

! XRL A,R7
: (opcode-6F) ( cpu -- )
    [ A> ] keep
    [ R7> ] keep
    [ bitxor 8 bits ] dip
    [ >A ] keep
    pc+ ;    

! JNZ
! if A != 0 jump rel
: (opcode-70) ( cpu -- )
  [ A> 0 = ] keep  ! carry bit
  swap
  [ [ pc+ ] keep pc+ ]
  [
    [ pc+ ] keep
    [ rom-pc-read ] keep
    [ pc+ ] keep
    [ pc>> relative ] keep pc<<
  ] if ;  

: (opcode-71) ( cpu -- )
    (opcode-51) ;

! ORL C,bit
: (opcode-72) ( cpu -- )
    [ psw>> psw-cy? ] keep
    [ pc+ ] keep [ rom-pc-read ] keep
    [ memory>> ram-bitstatus ] keep
    [ or ] dip
    [ psw>> >psw-cy ] keep
    pc+ ;

! JMP @A+DPTR    
: (opcode-73) ( cpu -- )
    [ A> ] keep
    [ DPTR> ] keep
    [ + 16 bits ] dip pc<< ;

! MOV A,#data
: (opcode-74) ( cpu -- )
    [ pc+ ] keep [ rom-pc-read ] keep [ >A ] keep pc+ ;
    
! MOV direct,#data
: (opcode-75) ( cpu -- )
    [ pc+ ] keep [ rom-pc-read ] keep    ! Direct Address
    [ pc+ ] keep [ rom-pc-read ] keep    ! imediate data
    [ swap ] dip
    [ memory>> ram-direct-write ] keep
    pc+ ;
    
 
! MOV @R0,#data
: (opcode-76) ( cpu -- )
    [ pc+ ] keep [ rom-pc-read ] keep
    [ >@R0 ] keep pc+ ;
 
! MOV @R1,#data
: (opcode-77) ( cpu -- )
    [ pc+ ] keep [ rom-pc-read ] keep
    [ >@R1 ] keep pc+ ;
 
! MOV R0,#data
: (opcode-78) ( cpu -- )
    [ pc+ ] keep [ rom-pc-read ] keep
    [ >R0 ] keep pc+ ;

! MOV R1,#data
: (opcode-79) ( cpu -- )
    [ pc+ ] keep [ rom-pc-read ] keep
    [ >R1 ] keep pc+ ;   

! MOV R2,#data
: (opcode-7A) ( cpu -- )
    [ pc+ ] keep [ rom-pc-read ] keep
    [ >R2 ] keep pc+ ;

! MOV R3,#data
: (opcode-7B) ( cpu -- )
    [ pc+ ] keep [ rom-pc-read ] keep
    [ >R3 ] keep pc+ ;

! MOV R4,#data
: (opcode-7C) ( cpu -- )
    [ pc+ ] keep [ rom-pc-read ] keep
    [ >R4 ] keep pc+ ;

! MOV R5,#data
: (opcode-7D) ( cpu -- )
    [ pc+ ] keep [ rom-pc-read ] keep
    [ >R5 ] keep pc+ ;

! MOV R6,#data
: (opcode-7E) ( cpu -- )
    [ pc+ ] keep [ rom-pc-read ] keep
    [ >R6 ] keep pc+ ;

! MOV R7,#data
: (opcode-7F) ( cpu -- )
    [ pc+ ] keep [ rom-pc-read ] keep
    [ >R7 ] keep pc+ ;

! SJMP rel
: (opcode-80) ( cpu -- )
    [ pc+ ] keep [ rom-pc-read ] keep [ pc+ ] keep
    [ pc>> relative ] keep pc<< ;

: (opcode-81) ( cpu -- )
    (opcode-61) ;
    
! ANL C,bit
: (opcode-82) ( cpu -- )
    [ psw>> psw-cy? ] keep
    [ pc+ ] keep [ rom-pc-read ] keep
    [ memory>> ram-bitstatus ] keep
    [ and ] dip
    [ psw>> >psw-cy ] keep
    pc+ ;

! MOVC A,@A+PC
: (opcode-83) ( cpu -- )
    [ pc+ ] keep
    [ A> ] keep
    [ pc>> ] keep
    [ + 16 bits ] dip [ rom-read ] keep >A ;
 
! DIV AB 
: (opcode-84) ( cpu -- )
    [ A> ] keep
    [ B> ] keep
    [ psw>> psw-div ] keep
    [ >B ] keep
    [ >A ] keep
    pc+ ;

! MOV direct,direct
: (opcode-85) ( cpu -- )
    [ pc+ ] keep [ rom-pc-read ] keep
    [ pc+ ] keep [ rom-pc-read ] keep [ memory>> ram-direct-read ] keep
    [ swap ] dip
    [ memory>> ram-direct-write ] keep
    pc+ ;

! MOV direct,@R0
: (opcode-86) ( cpu -- )
    [ @R0> ] keep
    [ pc+ ] keep [ rom-pc-read ] keep
    [ memory>> ram-direct-write ] keep
    pc+ ;
    
! MOV direct,@R1
: (opcode-87) ( cpu -- )
    [ @R1> ] keep
    [ pc+ ] keep [ rom-pc-read ] keep
    [ memory>> ram-direct-write ] keep
    pc+ ;
    
! MOV direct,R0
: (opcode-88) ( cpu -- )
    [ R0> ] keep
    [ pc+ ] keep [ rom-pc-read ] keep
    [ memory>> ram-direct-write ] keep
    pc+ ;

! MOV direct,R1
: (opcode-89) ( cpu -- )
    [ R1> ] keep
    [ pc+ ] keep [ rom-pc-read ] keep
    [ memory>> ram-direct-write ] keep
    pc+ ;    

! MOV direct,R2
: (opcode-8A) ( cpu -- )
    [ R2> ] keep
    [ pc+ ] keep [ rom-pc-read ] keep
    [ memory>> ram-direct-write ] keep
    pc+ ;    

! MOV direct,R3
: (opcode-8B) ( cpu -- )
    [ R3> ] keep
    [ pc+ ] keep [ rom-pc-read ] keep
    [ memory>> ram-direct-write ] keep
    pc+ ;

! MOV direct,R4
: (opcode-8C) ( cpu -- )
    [ R4> ] keep
    [ pc+ ] keep [ rom-pc-read ] keep
    [ memory>> ram-direct-write ] keep
    pc+ ;

! MOV direct,R5
: (opcode-8D) ( cpu -- )
    [ R5> ] keep
    [ pc+ ] keep [ rom-pc-read ] keep
    [ memory>> ram-direct-write ] keep
    pc+ ;

! MOV direct,R6
: (opcode-8E) ( cpu -- )
    [ R6> ] keep
    [ pc+ ] keep [ rom-pc-read ] keep
    [ memory>> ram-direct-write ] keep
    pc+ ;

! MOV direct,R7
: (opcode-8F) ( cpu -- )
    [ R7> ] keep
    [ pc+ ] keep [ rom-pc-read ] keep
    [ memory>> ram-direct-write ] keep
    pc+ ;

! MOV DPTR,#data16
: (opcode-90) ( cpu -- )
    [ pc+ ] keep [ rom-pc-read ] keep
    [ RAM_DPH ] dip [ memory>> ram-direct-write ] keep
    [ pc+ ] keep [ rom-pc-read ] keep
    [ RAM_DPL ] dip [ memory>> ram-direct-write ] keep
    pc+ ;

: (opcode-91) ( cpu -- )
    (opcode-71) ;

! MOV bit,C
: (opcode-92) ( cpu -- )
    [ psw>> psw-cy? ] keep
    [ pc+ ] keep [ rom-pc-read ] keep
    [ memory>> >ram-bit ] keep
    pc+ ;

! MOVC A,@A+DPTR    
: (opcode-93) ( cpu -- )
    [ A> ] keep
    [ DPTR> ] keep
    [ + 16 bits ] dip [ rom-read ] keep [ >A ] keep
    pc+ ;

! SUBB A,#data
: (opcode-94) ( cpu -- )
    [ A> ] keep
    [ pc+ ] keep [ rom-pc-read ] keep
    [ psw>> psw-cy ] keep
    [ psw>> psw-sub ] keep
    [ >A ] keep
    pc+ ;
 
! SUBB A,direct 
: (opcode-95) ( cpu -- )
    [ A> ] keep
    [ pc+ ] keep [ rom-pc-read ] keep [ memory>> ram-direct-read ] keep
    [ psw>> psw-cy ] keep
    [ psw>> psw-sub ] keep
    [ >A ] keep
    pc+ ;
    
! SUBB A,@R0
: (opcode-96) ( cpu -- )
  [ A> ] keep
  [ @R0> ] keep
  [ psw>> psw-cy ] keep
  [ psw>> psw-sub ] keep
  [ >A ] keep pc+ ;

! SUBB A,@R1
: (opcode-97) ( cpu -- )
  [ A> ] keep
  [ @R1> ] keep
  [ psw>> psw-cy ] keep
  [ psw>> psw-sub ] keep
  [ >A ] keep pc+ ;

! SUBB A,R0
: (opcode-98) ( cpu -- )
    [ A> ] keep
    [ R0> ] keep
    [ psw>> psw-cy ] keep
    [ psw>> psw-sub ] keep
    [ >A ] keep pc+ ;

! SUBB A,R1
: (opcode-99) ( cpu -- )
    [ A> ] keep
    [ R1> ] keep
    [ psw>> psw-cy ] keep
    [ psw>> psw-sub ] keep
    [ >A ] keep pc+ ;    

! SUBB A,R2
: (opcode-9A) ( cpu -- )
    [ A> ] keep
    [ R2> ] keep
    [ psw>> psw-cy ] keep
    [ psw>> psw-sub ] keep
    [ >A ] keep pc+ ;

! SUBB A,R3
: (opcode-9B) ( cpu -- )
    [ A> ] keep
    [ R3> ] keep
    [ psw>> psw-cy ] keep
    [ psw>> psw-sub ] keep
    [ >A ] keep pc+ ;

! SUBB A,R4
: (opcode-9C) ( cpu -- )
    [ A> ] keep
    [ R4> ] keep
    [ psw>> psw-cy ] keep
    [ psw>> psw-sub ] keep
    [ >A ] keep pc+ ;

! SUBB A,R5
: (opcode-9D) ( cpu -- )
    [ A> ] keep
    [ R5> ] keep
    [ psw>> psw-cy ] keep
    [ psw>> psw-sub ] keep
    [ >A ] keep pc+ ;

! SUBB A,R6
: (opcode-9E) ( cpu -- )
    [ A> ] keep
    [ R6> ] keep
    [ psw>> psw-cy ] keep
    [ psw>> psw-sub ] keep
    [ >A ] keep pc+ ;

! SUBB A,R7
: (opcode-9F) ( cpu -- )
    [ A> ] keep
    [ R7> ] keep
    [ psw>> psw-cy ] keep
    [ psw>> psw-sub ] keep
    [ >A ] keep pc+ ;    

! ORL C,/bit
: (opcode-A0) ( cpu -- )
    [ psw>> psw-cy? ] keep
    [ pc+ ] keep [ rom-pc-read ] keep
    [ memory>> ram-bitstatus not ] keep
    [ or ] dip
    [ psw>> >psw-cy ] keep
    pc+ ;

: (opcode-A1) ( cpu -- )
    (opcode-81) ;
    
    
! MOV C,bit
: (opcode-A2) ( cpu -- )
    [ pc+ ] keep [ rom-pc-read ] keep
    [ memory>> ram-bitstatus ] keep
    [ psw>> >psw-cy ] keep
    pc+ ;    
    
! INC DPTR
: (opcode-A3) ( cpu -- )
    [ DPTR> ] keep
    [ 1 + ] dip
    [ >DPTR ] keep
    pc+ ;
    

! MUL AB
: (opcode-A4) ( cpu -- )
    [ A> ] keep [ B> ] keep [ psw>> psw-mul ] keep
    [ >B ] keep [ >A ] keep pc+ ;
    
: (opcode-A5) ( cpu -- )
    (opcode-00) ;


! MOV @R0,direct
: (opcode-A6) ( cpu -- )
    [ pc+ ] keep [ rom-pc-read ] keep [ memory>> ram-direct-read ] keep
    [ >@R0 ] keep pc+ ;

! MOV @R0,direct
: (opcode-A7) ( cpu -- )
    [ pc+ ] keep [ rom-pc-read ] keep [ memory>> ram-direct-read ] keep
    [ >@R1 ] keep pc+ ;   

! MOV A,R0
: (opcode-A8) ( cpu -- )
    [ R0> ] keep
    [ >A ] keep pc+ ;

! MOV A,R1
: (opcode-A9) ( cpu -- )
    [ R1> ] keep
    [ >A ] keep pc+ ;

! MOV A,R2
: (opcode-AA) ( cpu -- )
    [ R2> ] keep
    [ >A ] keep pc+ ;

! MOV A,R3
: (opcode-AB) ( cpu -- )
    [ R3> ] keep
    [ >A ] keep pc+ ;

! MOV A,R4
: (opcode-AC) ( cpu -- )
    [ R4> ] keep
    [ >A ] keep pc+ ;

! MOV A,R5
: (opcode-AD) ( cpu -- )
    [ R5> ] keep
    [ >A ] keep pc+ ;

! MOV A,R6
: (opcode-AE) ( cpu -- )
    [ R6> ] keep
    [ >A ] keep pc+ ;

! MOV A,R7
: (opcode-AF) ( cpu -- )
    [ R7> ] keep
    [ >A ] keep pc+ ;

! ANL C,/bit
: (opcode-B0) ( cpu -- )
    [ psw>> psw-cy? not ] keep
    [ pc+ ] keep [ rom-pc-read ] keep
    [ memory>> ram-bitstatus ] keep
    [ and ] dip
    [ psw>> >psw-cy ] keep
    pc+ ;

: (opcode-B1) ( cpu -- )
    (opcode-91) ;

! CPL bit
: (opcode-B2) ( cpu -- )
    [ pc+ ] keep [ rom-pc-read ] keep
    [ memory>> ram-bitstatus ] keep swap
    [
        [ rom-pc-read ] keep
        [ memory>> ram-bitclr ] keep
    ]
    [
        [ rom-pc-read ] keep
        [ memory>> ram-bitset ] keep
    ] if
    pc+ ;

! CPL C
: (opcode-B3) ( cpu -- )
    [ psw>> psw-cy? not ] keep
    [ psw>> >psw-cy ] keep
    pc+ ;

! CJNE A,#data,rel
! (PC) ← (PC) + 3
! IF (A) < > data THEN (PC) ← (PC) + relative offset
! IF (A) < data THEN (C) ← 1 ELSE(C) ← 0
: (opcode-B4) ( cpu -- )
    [ A> ] keep
    [ pc+ ] keep [ rom-pc-read ] keep
    [ = ] dip swap
    [
        [ A> ] keep
        [ rom-pc-read ] keep
        [ < ] dip swap
        [ [ psw>> psw-cy-set ] keep ]
        [ [ psw>> psw-cy-clr ] keep ] if
        [ pc+ ] keep pc+
    ]
    [
        [ pc+ ] keep [ rom-pc-read ] keep
        [ pc+ ] keep
        [ pc>> relative ] keep pc<<
    ] if ;

! CJNE A,direct,rel
: (opcode-B5) ( cpu -- )
    [ A> ] keep
    [ pc+ ] keep [ rom-pc-read ] keep [ memory>> ram-direct-read ] keep
    [ = ] dip swap
    [
        [ A> ] keep
        [ rom-pc-read ] keep [ memory>> ram-direct-read ] keep
        [ < ] dip swap
        [ [ psw>> psw-cy-set ] keep ]
        [ [ psw>> psw-cy-clr ] keep ] if
        [ pc+ ] keep pc+
    ]
    [
        [ pc+ ] keep [ rom-pc-read ] keep
        [ pc+ ] keep
        [ pc>> relative ] keep pc<<
    ] if ;    

! CJNE @R0,data,rel
: (opcode-B6) ( cpu -- )
    [ @R0> ] keep
    [ pc+ ] keep [ rom-pc-read ] keep
    [ = ] dip swap
    [
        [ @R0> ] keep
        [ rom-pc-read ] keep
        [ < ] dip swap
        [ [ psw>> psw-cy-set ] keep ]
        [ [ psw>> psw-cy-clr ] keep ] if
        [ pc+ ] keep pc+
    ]
    [
        [ pc+ ] keep [ rom-pc-read ] keep
        [ pc+ ] keep
        [ pc>> relative ] keep pc<<
    ] if ;

! CJNE @R1,data,rel
: (opcode-B7) ( cpu -- )
    [ @R1> ] keep
    [ pc+ ] keep [ rom-pc-read ] keep
    [ = ] dip swap
    [
        [ @R1> ] keep
        [ rom-pc-read ] keep
        [ < ] dip swap
        [ [ psw>> psw-cy-set ] keep ]
        [ [ psw>> psw-cy-clr ] keep ] if
        [ pc+ ] keep pc+
    ]
    [
        [ pc+ ] keep [ rom-pc-read ] keep
        [ pc+ ] keep
        [ pc>> relative ] keep pc<<
    ] if ;

! CJNE R0,#data,rel
: (opcode-B8) ( cpu -- )
    [ R0> ] keep
    [ pc+ ] keep [ rom-pc-read ] keep
    [ < ] dip swap
    [ [ psw>> psw-cy-set ] keep ] [ [ psw>> psw-cy-clr ] keep ] if
    [ R0> ] keep
    [ rom-pc-read ] keep
    [ = ] dip swap
    [
        [ pc+ ] keep pc+
    ]
    [
        [ pc+ ] keep [ rom-pc-read ] keep
        [ pc+ ] keep
        [ pc>> relative ] keep pc<<
    ] if ;

! CJNE R1,#data,rel
: (opcode-B9) ( cpu -- )
    [ R1> ] keep
    [ pc+ ] keep [ rom-pc-read ] keep
    [ < ] dip swap
    [ [ psw>> psw-cy-set ] keep ] [ [ psw>> psw-cy-clr ] keep ] if
    [ R1> ] keep
    [ rom-pc-read ] keep
    [ = ] dip swap
    [
        [ pc+ ] keep pc+
    ]
    [
        [ pc+ ] keep [ rom-pc-read ] keep
        [ pc+ ] keep
        [ pc>> relative ] keep pc<<
    ] if ;

! CJNE R2,#data,rel
: (opcode-BA) ( cpu -- )
    [ R2> ] keep
    [ pc+ ] keep [ rom-pc-read ] keep
    [ < ] dip swap
    [ [ psw>> psw-cy-set ] keep ] [ [ psw>> psw-cy-clr ] keep ] if
    [ R2> ] keep
    [ rom-pc-read ] keep
    [ = ] dip swap
    [
        [ pc+ ] keep pc+
    ]
    [
        [ pc+ ] keep [ rom-pc-read ] keep
        [ pc+ ] keep
        [ pc>> relative ] keep pc<<
    ] if ;

! CJNE R3,#data,rel
: (opcode-BB) ( cpu -- )
    [ R3> ] keep
    [ pc+ ] keep [ rom-pc-read ] keep
    [ < ] dip swap
    [ [ psw>> psw-cy-set ] keep ] [ [ psw>> psw-cy-clr ] keep ] if
    [ R3> ] keep
    [ rom-pc-read ] keep
    [ = ] dip swap
    [
        [ pc+ ] keep pc+
    ]
    [
        [ pc+ ] keep [ rom-pc-read ] keep
        [ pc+ ] keep
        [ pc>> relative ] keep pc<<
    ] if ;

! CJNE R4,#data,rel
: (opcode-BC) ( cpu -- )
    [ R4> ] keep
    [ pc+ ] keep [ rom-pc-read ] keep
    [ < ] dip swap
    [ [ psw>> psw-cy-set ] keep ] [ [ psw>> psw-cy-clr ] keep ] if
    [ R4> ] keep
    [ rom-pc-read ] keep
    [ = ] dip swap
    [
        [ pc+ ] keep pc+
    ]
    [
        [ pc+ ] keep [ rom-pc-read ] keep
        [ pc+ ] keep
        [ pc>> relative ] keep pc<<
    ] if ;

! CJNE R5,#data,rel
: (opcode-BD) ( cpu -- )
    [ R5> ] keep
    [ pc+ ] keep [ rom-pc-read ] keep
    [ < ] dip swap
    [ [ psw>> psw-cy-set ] keep ] [ [ psw>> psw-cy-clr ] keep ] if
    [ R5> ] keep
    [ rom-pc-read ] keep
    [ = ] dip swap
    [
        [ pc+ ] keep pc+
    ]
    [
        [ pc+ ] keep [ rom-pc-read ] keep
        [ pc+ ] keep
        [ pc>> relative ] keep pc<<
    ] if ;

! CJNE R6,#data,rel
: (opcode-BE) ( cpu -- )
    [ R6> ] keep
    [ rom-pc-read ] keep
    [ < ] dip swap
    [ [ psw>> psw-cy-set ] keep ] [ [ psw>> psw-cy-clr ] keep ] if
    [ R6> ] keep
    [ pc+ ] keep [ rom-pc-read ] keep
    [ = ] dip swap
    [
        [ pc+ ] keep pc+
    ]
    [
        [ pc+ ] keep [ rom-pc-read ] keep
        [ pc+ ] keep
        [ pc>> relative ] keep pc<<
    ] if ;

! CJNE R7,#data,rel
: (opcode-BF) ( cpu -- )
    [ R7> ] keep
    [ pc+ ] keep [ rom-pc-read ] keep
    [ < ] dip swap
    [ [ psw>> psw-cy-set ] keep ] [ [ psw>> psw-cy-clr ] keep ] if
    [ R7> ] keep
    [ rom-pc-read ] keep
    [ = ] dip swap
    [
        [ pc+ ] keep pc+
    ]
    [
        [ pc+ ] keep [ rom-pc-read ] keep
        [ pc+ ] keep
        [ pc>> relative ] keep pc<<
    ] if ;


! PUSH direct
: (opcode-C0) ( cpu -- )
    [ pc+ ] keep [ rom-pc-read ] keep [ memory>> ram-direct-read ] keep
    [ sp-push ] keep
    pc+ ;

: (opcode-C1) ( cpu -- )
    (opcode-A1) ;

! CLR bit
: (opcode-C2) ( cpu -- )
    [ pc+ ] keep [ rom-pc-read ] keep
    [ memory>> ram-bitclr ] keep
    pc+ ;

! CLR C
: (opcode-C3) ( cpu -- )
    [ psw>> psw-cy-clr ] keep pc+ ;

! SWAP A
: (opcode-C4) ( cpu -- )
    [ A> ] keep [ [ 7 4 bit-range ] keep 3 0 bit-range 4 shift bitor 8 bits ] dip
    [ >A ] keep pc+ ;

! XCH A,direct
: (opcode-C5) ( cpu -- )
    [ pc+ ] keep [ rom-pc-read ] keep [ memory>> ram-direct-read ] keep
    [ A> ] keep [ swap ] dip
    [ >A ] keep
    [ rom-pc-read ] keep [ memory>> ram-direct-write ] keep
    pc+ ;

! XCH A,@R0
: (opcode-C6) ( cpu -- )
    [ @R0> ] keep
    [ A> ] keep [ swap ] dip
    [ >A ] keep
    [ >@R0 ] keep
    pc+ ;

! XCH A,@R1
: (opcode-C7) ( cpu -- )
    [ @R1> ] keep
    [ A> ] keep [ swap ] dip
    [ >A ] keep
    [ >@R1 ] keep
    pc+ ;

! XCH A,R0
: (opcode-C8) ( cpu -- )
    [ R0> ] keep
    [ A> ] keep [ swap ] dip
    [ >A ] keep
    [ >R0 ] keep
    pc+ ;

! XCH A,R1
: (opcode-C9) ( cpu -- )
    [ R1> ] keep
    [ A> ] keep [ swap ] dip
    [ >A ] keep
    [ >R1 ] keep
    pc+ ;

! XCH A,R2
: (opcode-CA) ( cpu -- )
    [ R2> ] keep
    [ A> ] keep [ swap ] dip
    [ >A ] keep
    [ >R2 ] keep
    pc+ ;

! XCH A,R3
: (opcode-CB) ( cpu -- )
    [ R3> ] keep
    [ A> ] keep [ swap ] dip
    [ >A ] keep
    [ >R3 ] keep
    pc+ ;

! XCH A,R4
: (opcode-CC) ( cpu -- )
    [ R4> ] keep
    [ A> ] keep [ swap ] dip
    [ >A ] keep
    [ >R4 ] keep
    pc+ ;

! XCH A,R5
: (opcode-CD) ( cpu -- )
    [ R5> ] keep
    [ A> ] keep [ swap ] dip
    [ >A ] keep
    [ >R5 ] keep
    pc+ ;

! XCH A,R6
: (opcode-CE) ( cpu -- )
    [ R6> ] keep
    [ A> ] keep [ swap ] dip
    [ >A ] keep
    [ >R6 ] keep
    pc+ ;

! XCH A,R7
: (opcode-CF) ( cpu -- )
    [ R7> ] keep
    [ A> ] keep [ swap ] dip
    [ >A ] keep
    [ >R7 ] keep
    pc+ ;

! POP direct
: (opcode-D0) ( cpu -- )
    [ sp-pop ] keep
    [ pc+ ] keep [ rom-pc-read ] keep [ memory>> ram-direct-write ] keep
    pc+ ;

: (opcode-D1) ( cpu -- )
    (opcode-B1) ;


! SETB bit
: (opcode-D2) ( cpu -- )
    [ pc+ ] keep [ rom-pc-read ] keep
    [ memory>> ram-bitset ] keep
    pc+ ;

! SETB C
: (opcode-D3) ( cpu -- )
    [ psw>> psw-cy-set ] keep
    pc+ ;

! DA A
: (opcode-D4) ( cpu -- )
    [ A> ] keep
    [ psw>> psw-decimaladjust ] keep
    [ >A ] keep
    pc+ ;

! DJNZ direct,rel
: (opcode-D5) ( cpu -- )
    [ pc+ ] keep [ rom-pc-read ] keep [ memory>> ram-direct-read ] keep
    [ 1 - 8 bits dup ] dip [ rom-pc-read ] keep [ memory>> ram-direct-write ] keep
    [ 0 = ] dip swap
    [
        [ pc+ ] keep pc+
    ]
    [ 
        [ pc+ ] keep [ rom-pc-read ] keep [ pc+ ] keep
        [ pc>> relative ] keep pc<<
    ] if ;

! split 8 bits into 2 4 bits
: nibble ( n -- hn ln )
    8 bits [ 7 4 bit-range ] keep 3 0 bit-range ;

! return the two 4 bit nibble back into on 8 bit
: denibble ( hn ln -- n )
    [ -4 shift ] dip bitor 8 bits ;


! XCHD A,@R0
: (opcode-D6) ( cpu -- )
    [ @R0> nibble ] keep
    [ A> nibble ] keep
    [ swap [ swap ] dip swap ] dip
    [ denibble ] dip [ >A ] keep
    [ denibble ] dip [ >@R0 ] keep
    pc+ ;

! XCHD A,@R1
: (opcode-D7) ( cpu -- )
    [ @R1> nibble ] keep
    [ A> nibble ] keep
    [ swap [ swap ] dip swap ] dip
    [ denibble ] dip [ >A ] keep
    [ denibble ] dip [ >@R1 ] keep
    pc+ ;

! DJNZ R0,rel
: (opcode-D8) ( cpu -- )
    [ R0> ] keep
    [ 1 - 8 bits dup ] dip [ >R0 ] keep
    [ 0 = ] dip swap
    [
        [ pc+ ] keep pc+
    ]
    [ 
        [ pc+ ] keep [ rom-pc-read ] keep [ pc+ ] keep
        [ pc>> relative ] keep pc<<
    ] if ;

! DJNZ R1,rel
: (opcode-D9) ( cpu -- )
    [ R1> ] keep
    [ 1 - 8 bits dup ] dip [ >R1 ] keep
    [ 0 = ] dip swap
    [
        [ pc+ ] keep pc+
    ]
    [ 
        [ pc+ ] keep [ rom-pc-read ] keep [ pc+ ] keep
        [ pc>> relative ] keep pc<<
    ] if ;

! DJNZ R2,rel
: (opcode-DA) ( cpu -- )
    [ R2> ] keep
    [ 1 - 8 bits dup ] dip [ >R2 ] keep
    [ 0 = ] dip swap
    [
        [ pc+ ] keep pc+
    ]
    [ 
        [ pc+ ] keep [ rom-pc-read ] keep [ pc+ ] keep
        [ pc>> relative ] keep pc<<
    ] if ;

! DJNZ R3,rel
: (opcode-DB) ( cpu -- )
    [ R3> ] keep
    [ 1 - 8 bits dup ] dip [ >R3 ] keep
    [ 0 = ] dip swap
    [
        [ pc+ ] keep pc+
    ]
    [ 
        [ pc+ ] keep [ rom-pc-read ] keep [ pc+ ] keep
        [ pc>> relative ] keep pc<<
    ] if ;

! DJNZ R4,rel
: (opcode-DC) ( cpu -- )
    [ R4> ] keep
    [ 1 - 8 bits dup ] dip [ >R4 ] keep
    [ 0 = ] dip swap
    [
        [ pc+ ] keep pc+
    ]
    [ 
        [ pc+ ] keep [ rom-pc-read ] keep [ pc+ ] keep
        [ pc>> relative ] keep pc<<
    ] if ;

! DJNZ R5,rel
: (opcode-DD) ( cpu -- )
    [ R5> ] keep
    [ 1 - 8 bits dup ] dip [ >R5 ] keep
    [ 0 = ] dip swap
    [
        [ pc+ ] keep pc+
    ]
    [ 
        [ pc+ ] keep [ rom-pc-read ] keep [ pc+ ] keep
        [ pc>> relative ] keep pc<<
    ] if ;

! DJNZ R6,rel
: (opcode-DE) ( cpu -- )
    [ R6> ] keep
    [ 1 - 8 bits dup ] dip [ >R6 ] keep
    [ 0 = ] dip swap
    [
        [ pc+ ] keep pc+
    ]
    [ 
        [ pc+ ] keep [ rom-pc-read ] keep [ pc+ ] keep
        [ pc>> relative ] keep pc<<
    ] if ;

! DJNZ R7,rel
: (opcode-DF) ( cpu -- )
    [ R7> ] keep
    [ 1 - 8 bits dup ] dip [ >R7 ] keep
    [ 0 = ] dip swap
    [
        [ pc+ ] keep pc+
    ]
    [ 
        [ pc+ ] keep [ rom-pc-read ] keep [ pc+ ] keep
        [ pc>> relative ] keep pc<<
    ] if ;

! MOVX A,@DPTR
: (opcode-E0) ( cpu -- )
    [ DPTR> ] keep [ memory>> ext-read ] keep [ >A ] keep pc+ ;

: (opcode-E1) ( cpu -- )
    (opcode-C1) ;

! MOVX A,@R0
: (opcode-E2) ( cpu -- )
    [ @R0> ] keep [ memory>> ext-read ] keep [ >A ] keep pc+ ;

! MOVX A,@R1
: (opcode-E3) ( cpu -- )
    [ @R1> ] keep [ memory>> ext-read ] keep [ >A ] keep pc+ ;

! CLR A
: (opcode-E4) ( cpu -- )
    [ 0 ] dip [ >A ] keep pc+ ;

! MOV A,direct
: (opcode-E5) ( cpu -- )
    [ pc+ ] keep [ rom-pc-read ] keep [ memory>> ram-direct-read ] keep
    [ >A ] keep pc+ ;


! MOV A,@R0
: (opcode-E6) ( cpu -- )
    [ @R0> ] keep [ >A ] keep pc+ ;


! MOV A,@R1
: (opcode-E7) ( cpu -- )
    [ @R1> ] keep [ >A ] keep pc+ ;

! MOV A,R0
: (opcode-E8) ( cpu -- )
    [ R0> ] keep [ >A ] keep pc+ ;

! MOV A,R1
: (opcode-E9) ( cpu -- )
    [ R1> ] keep [ >A ] keep pc+ ;

! MOV A,R2
: (opcode-EA) ( cpu -- )
    [ R2> ] keep [ >A ] keep pc+ ;

! MOV A,R3
: (opcode-EB) ( cpu -- )
    [ R3> ] keep [ >A ] keep pc+ ;
 
! MOV A,R4
: (opcode-EC) ( cpu -- )
    [ R4> ] keep [ >A ] keep pc+ ;

! MOV A,R5
: (opcode-ED) ( cpu -- )
    [ R5> ] keep [ >A ] keep pc+ ;

! MOV A,R6
: (opcode-EE) ( cpu -- )
    [ R6> ] keep [ >A ] keep pc+ ;

! MOV A,R7
: (opcode-EF) ( cpu -- )
    [ R7> ] keep [ >A ] keep pc+ ;

! MOVX @DPTR,A
: (opcode-F0) ( cpu -- )
    [ A> ] keep [ DPTR> ] keep [ memory>> ext-write ] keep pc+ ;

: (opcode-F1) ( cpu -- )
    (opcode-D1) ;

! MOVX @R0,A
: (opcode-F2) ( cpu -- )
    [ A> ] keep [ R0> ] keep [ memory>> ext-write ] keep pc+ ;

! MOVX @R1,A
: (opcode-F3) ( cpu -- )
    [ A> ] keep [ R1> ] keep [ memory>> ext-write ] keep pc+ ;

! CPL A
: (opcode-F4) ( cpu -- )
    [ A> ] keep [ bitnot 8 bits ] dip [ >A ] keep pc+ ;

! MOV direct,A
: (opcode-F5) ( cpu -- )
    [ A> ] keep [ pc+ ] keep [ rom-pc-read ] keep
    [ memory>> ram-direct-write ] keep pc+ ;

! MOV @R0,A
: (opcode-F6) ( cpu -- )
    [ A> ] keep [ >@R0 ] keep pc+ ;

! MOV @R1,A
: (opcode-F7) ( cpu -- )
    [ A> ] keep [ >@R1 ] keep pc+ ;

! MOV R0,A
: (opcode-F8) ( cpu -- )
    [ A> ] keep [ >R0 ] keep pc+ ;

! MOV R1,A
: (opcode-F9) ( cpu -- )
    [ A> ] keep [ >R1 ] keep pc+ ;

! MOV R2,A
: (opcode-FA) ( cpu -- )
    [ A> ] keep [ >R2 ] keep pc+ ;

! MOV R3,A
: (opcode-FB) ( cpu -- )
    [ A> ] keep [ >R3 ] keep pc+ ;

! MOV R4,A
: (opcode-FC) ( cpu -- )
    [ A> ] keep [ >R4 ] keep pc+ ;

! MOV R5,A
: (opcode-FD) ( cpu -- )
    [ A> ] keep [ >R5 ] keep pc+ ;

! MOV R6,A
: (opcode-FE) ( cpu -- )
    [ A> ] keep [ >R6 ] keep pc+ ;

! MOV R7,A
: (opcode-FF) ( cpu -- )
    [ A> ] keep [ >R7 ] keep pc+ ;


: <cpu> ( -- cpu )
    cpu new
    f >>hp    ! High Priority Interrupt
    f >>lp    ! Low Priority Interrupt
    0 >>pc
    0 >>b
    0 <psw> >>psw
    0 >>dptr
    0 >>sp
    <memory> >>memory
    256 [ not-implemented ] <array> >>opcodes
;


: emu-test ( -- c )
  break
  "work/intel/hex/EZSHOT.HEX"
   <ihex> array>> <cpu> swap >>rom ;
