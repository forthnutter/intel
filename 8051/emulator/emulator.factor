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



TUPLE: cpu hp lp b psw dptr sp pc rom ram ;

: <cpu> ( -- cpu )
  cpu new
  f >>hp    ! High Priority Interrupt
  f >>lp    ! Low Priority Interrupt
  0 >>pc
  0 >>b
  0 <psw> >>psw
  0 >>dptr
  0 >>sp
  <ram> >>ram
!  <reg> >>reg
;

! read 8 bit from RAM
! : ram-readbyte ( address cpu -- dd )
!  ram>> ram-read ;

! : ram-writebyte ( dd address cpu -- )
!  ram>> ram-write ;

! write to ACC
: >A ( b cpu -- )
  ram>>
  RAM_A swap
  ram-direct-write ;

! read ACC
: A> ( cpu -- b )
  ram>>
  RAM_A swap
  ram-direct-read  ;

! write to R0
: >R0 ( b cpu -- )
  [ psw>> psw-bank-read ] keep ! get the bank value
  -rot
  8 *                          ! 8 registers by bank number
  rot
  ram>> ram-direct-write
  ;

: R0> ( cpu -- b )
  [ psw>> psw-bank-read ] keep ! get the reg bank value
  swap 8 *  ! get the address
  swap ram>> ram-direct-read ;

: @R0> ( cpu -- b )
   [ R0> ] keep ram>> ram-indirect-read ;  

: >@R0 ( b cpu -- )
   [ R0> ] keep ram>> ram-indirect-write ;
   
: >R1 ( b cpu -- )
  [ psw>> psw-bank-read ] keep ! get the bank value
  -rot
  8 * 1 +                      ! 8 registers by bank number
  rot
  ram>> ram-direct-write ;

: R1> ( cpu -- b )
  [ psw>> psw-bank-read ] keep ! get the reg bank value
  swap 8 * 1 +  ! get the address
  swap ram>> ram-direct-read ;

: @R1> ( cpu -- b )
   [ R1> ] keep ram>> ram-indirect-read ;  

: >@R1 ( b cpu -- )
   [ R1> ] keep ram>> ram-indirect-write ;  
  

: >R2 ( b cpu -- )
  [ psw>> psw-bank-read ] keep ! get the bank value
  -rot
  8 * 2 +                      ! 8 registers by bank number
  rot
  ram>> ram-direct-write ;

: R2> ( cpu -- b )
  [ psw>> psw-bank-read ] keep ! get the reg bank value
  swap 8 * 2 + ! get the address
  swap ram>> ram-direct-read ;


: >R3 ( b cpu -- )
  [ psw>> psw-bank-read ] keep ! get the bank value
  -rot
  8 * 3 +                      ! 8 registers by bank number
  rot
  ram>> ram-direct-write ;

: R3> ( cpu -- b )
  [ psw>> psw-bank-read ] keep ! get the reg bank value
  swap 8 * 3 +  ! get the address
  swap ram>> ram-direct-read ;

: >R4 ( b cpu -- )
  [ psw>> psw-bank-read ] keep ! get the bank value
  -rot
  8 * 4 +                          ! 8 registers by bank number
  rot
  ram>> ram-direct-write ;

: R4> ( cpu -- b )
  [ psw>> psw-bank-read ] keep ! get the reg bank value
  swap 8 * 4 +  ! get the address
  swap ram>> ram-direct-read ;

: >R5 ( b cpu -- )
  [ psw>> psw-bank-read ] keep ! get the bank value
  -rot
  8 * 5 +                          ! 8 registers by bank number
  rot
  ram>> ram-direct-write ;

: R5> ( cpu -- b )
  [ psw>> psw-bank-read ] keep ! get the reg bank value
  swap 8 * 5 +  ! get the address
  swap ram>> ram-direct-read ;

: >R6 ( b cpu -- )
  [ psw>> psw-bank-read ] keep ! get the bank value
  -rot
  8 * 6 +                      ! 8 registers by bank number
  rot
  ram>> ram-direct-write
  ;

: R6> ( cpu -- b )
  [ psw>> psw-bank-read ] keep ! get the reg bank value
  swap 8 * 6 +  ! get the address
  swap ram>> ram-direct-read ;

: >R7 ( b cpu -- )
  [ psw>> psw-bank-read ] keep ! get the bank value
  -rot
  8 * 7 +                      ! 8 registers by bank number
  rot
  ram>> ram-direct-write ;

: R7> ( cpu -- b )
  [ psw>> psw-bank-read ] keep ! get the reg bank value
  swap 8 * 7 +  ! get the address
  swap ram>> ram-direct-read ;

! increment the pc of cpu
: pc+ ( cpu -- )
  dup pc>> 1 + 16 0 bit-range swap pc<< ;

! read the rom addressed by pc
: rom-pcread ( cpu -- dd )
  dup pc>> swap rom>> ?nth
  dup
  [ ]
  [ drop 0 ] if
  ;

: sp+ ( cpu -- )
  [ sp>> 1 + 8 bits ] keep sp<< ;

: sp- ( cpu -- )
  [ sp>> 1 - 8 bits ] keep sp<< ;

! write to ram sp has address
: sp-write ( n cpu -- )
  [ sp>> ] keep
  ram>> ram-indirect-write ;

! push a byte onto the stack pointer
: sp-push ( b cpu -- )
  [ 7 0 bit-range ] dip ! make sure its a byte
  [ sp+ ] keep
  sp-write
  ;

: sp-pop ( cpu -- b )
  [ sp>> ] keep [ sp- ] keep
  ram>> ram-indirect-read ;

! save the contents of pc to sp
: pc->(sp) ( cpu -- )
  [ pc>> 15 8 bit-range ] keep [ pc>> 7 0 bit-range ] keep
  [ sp-push ] keep sp-push ;

! get the data from stack pointer into PC
: (sp)->pc ( cpu -- )
  [ sp-pop 8 shift ] keep [ sp-pop 8 bits ] keep
  [ bitor 16 bits ] dip
  pc<< ;


! read 16 bit data from ROM
: readromword ( address cpu -- dddd )
  [ rom>> ?nth 8 shift ] 2keep swap 1 + swap rom>> ?nth bitor 16 bits ;


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
  ram>> swap binary
  [ 
    0 swap (load-rom)
  ] with-file-reader ;

: not-implemented ( cpu -- )
  drop ;

: instructions ( -- vector )
  \ instructions get-global
  [
    ! make sure we always return with array
    256 [ not-implemented ] <array> \ instructions set-global
  ] unless
  \ instructions get-global ;

: set-instruction ( quot n -- )
  instructions set-nth ;


! NOP Instruction
: (opcode-00) ( cpu -- )
  pc+ ;

! AJMP
! Absolute Jump
: (opcode-01) ( cpu -- )
  [ rom-pcread 0xe0 bitand 3 shift ] keep ! the instruction has part of address
  [ pc+ ] keep [ rom-pcread ] keep -rot bitor swap pc<< ;

! LJMP
! Long Jump
: (opcode-02) ( cpu -- )
  [ pc+ ] keep
  [ pc>> ] keep
  [ readromword ] keep pc<< ;

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
  [ dup pc+ rom-pcread ] keep
  [ ram>> ram-direct-read ] keep
  swap 1 + 8 bits swap [ rom-pcread ] keep 
  [ ram>> ram-direct-write ] keep pc+ ;

! INC @R0
! Increment 8-bit internal data RAM location (0-255) addressed
! indirectly through register R0.
: (opcode-06) ( cpu -- )
  [ R0> ] keep ! get r0 value this is the adderss
  [ ram>> ram-indirect-read 1 + ] keep  ! get data from ram add 1 to data
  [ R0> ] keep      ! get the r0 address value
  [ ram>> ram-indirect-write ] keep pc+ ;   ! data is now save back into ram

! INC @R1
! Increment 8-bit internal RAM location (0 - 255) addressed
! indirectly through Register R1
: (opcode-07) ( cpu -- )
  [ R1> ] keep [ ram>> ram-indirect-read 1 + ] keep [ R1> ] keep
  [ ram>> ram-indirect-write ] keep pc+ ;

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
  [ rom-pcread ] keep ! read value
  [ ram>> ram-bitstatus ] keep  ! bit status should be on stack
  swap
  [
    [ rom-pcread ] keep
    [ ram>> ram-bitclear ] keep
    [ pc+ ] keep
    [ rom-pcread ] keep
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
    rom-pcread 15 13 bit-range 8 shift
  ] keep ! the instruction part of address
  [ pc+ ] keep
  [ rom-pcread ] keep
  [ pc+ ] keep
  [ pc->(sp) ] keep
  -rot bitor swap pc<< ;

! LCALL
! Long Call
: (opcode-12) ( cpu -- )
  [ pc+ ] keep
  [ rom-pcread ] keep
  [ pc+ ] keep
  [ rom-pcread ] keep
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
  [ dup pc+ rom-pcread ] keep
  [ ram>> ram-direct-read ] keep
  swap 1 - 8 bits swap [ rom-pcread ] keep 
  [ ram>> ram-direct-write ] keep pc+ ;

! DEC @R0
! Decrement 8-bit internal data RAM location (0-255) addressed
! indirectly through register R0.
: (opcode-16) ( cpu -- )
  [ R0> ] keep ! get r0 value this is the adderss
  [ ram>> ram-indirect-read 1 - 8 bits ] keep  ! get data from ram add 1 to data
  [ R0> ] keep      ! get the r0 address value
  [ ram>> ram-indirect-write ] keep pc+ ;   ! data is now save back into ram

! DEC @R1
! Decrement 8-bit internal data RAM location (0-255) addressed
! indirectly through register R1.
: (opcode-17) ( cpu -- )
  [ R1> ] keep ! get r0 value this is the adderss
  [ ram>> ram-indirect-read 1 - 8 bits ] keep  ! get data from ram add 1 to data
  [ R1> ] keep      ! get the r0 address value
  [ ram>> ram-indirect-write ] keep pc+ ;   ! data is now save back into ram


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
  [ rom-pcread ] keep ! read value
  [ ram>> ram-bitstatus ] keep  ! bit status should be on stack
  swap
  [
    [ pc+ ] keep
    [ rom-pcread ] keep
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
    [ A> ] keep [ pc+ ] keep [ rom-pcread ] keep
    0 swap ! carry bit
    [ psw>> psw-add ] keep
    [ >A ] keep pc+ ;

! ADD A,dir
: (opcode-25) ( cpu -- )
    [ A> ] keep
    [ dup pc+ rom-pcread ] keep [ ram>> ram-direct-read ] keep
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
  [ rom-pcread ] keep ! read value
  [ ram>> ram-bitstatus ] keep  ! bit status should be on stack
  swap
  [ [ pc+ ] keep pc+ ]
  [
    [ pc+ ] keep
    [ rom-pcread ] keep
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
    [ A> ] keep [ pc+ ] keep [ rom-pcread ] keep
    [ psw>> psw-cy ] keep ! carry bit
    [ psw>> psw-add ] keep
    [ >A ] keep pc+ ;

! ADDC A,dir
: (opcode-35) ( cpu -- )
    [ A> ] keep
    [ dup pc+ rom-pcread ] keep [ ram>> ram-direct-read ] keep
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
    [ rom-pcread ] keep
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
  [ pc+ ] keep [ rom-pcread dup ] keep [ ram>> ram-direct-read ] keep
  [ A> ] keep
  [ bitor 8 bits swap ] dip
  [ ram>> ram-direct-write ] keep
  pc+ ;
  
! ORL direct,#data
: (opcode-43) ( cpu -- )
    [ pc+ ] keep [ rom-pcread dup ] keep [ ram>> ram-direct-read ] keep
    [ pc+ ] keep [ rom-pcread ] keep
    [ bitor 8 bits swap ] dip
    [ ram>> ram-direct-write ] keep
    pc++ ;

    
  
: emu-test ( -- c )
  break
  "work/intel/hex/EZSHOT.HEX"
   <ihex> array>> <cpu> swap >>rom ;
