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



TUPLE: cpu a b psw dptr sp pc rom ram ;

: <cpu> ( -- cpu )
  cpu new
  0 >>pc
  0 >>a
  0 >>b
  0 <psw> >>psw
  0 >>dptr
  0 >>sp
  <ram> >>ram
!  <reg> >>reg
;

! read 8 bit from RAM
: ram-readbyte ( address cpu -- dd )
  ram>> ram-read ;

: ram-writebyte ( dd address cpu -- )
  ram>> ram-write ;


: >R0 ( b cpu -- )
  [ psw>> psw-bank-read ] keep ! get the bank value
  -rot
  8 *                          ! 8 registers by bank number
  rot
  ram-writebyte
  ;

: R0> ( cpu -- b )
  [ psw>> psw-bank-read ] keep ! get the reg bank value
  swap 8 *  ! get the address
  swap ram-readbyte ;

: >R1 ( b cpu -- )
  [ psw>> psw-bank-read ] keep ! get the bank value
  -rot
  8 * 1 +                      ! 8 registers by bank number
  rot
  ram-writebyte
  ;

: R1> ( cpu -- b )
  [ psw>> psw-bank-read ] keep ! get the reg bank value
  swap 8 * 1 +  ! get the address
  swap ram-readbyte ;

: >R2 ( b cpu -- )
  [ psw>> psw-bank-read ] keep ! get the bank value
  -rot
  8 * 2 +                      ! 8 registers by bank number
  rot
  ram-writebyte
  ;

: R2> ( cpu -- b )
  [ psw>> psw-bank-read ] keep ! get the reg bank value
  swap 8 * 2 + ! get the address
  swap ram-readbyte ;


: >R3 ( b cpu -- )
  [ psw>> psw-bank-read ] keep ! get the bank value
  -rot
  8 * 3 +                      ! 8 registers by bank number
  rot
  ram-writebyte
  ;

: R3> ( cpu -- b )
  [ psw>> psw-bank-read ] keep ! get the reg bank value
  swap 8 * 3 +  ! get the address
  swap ram-readbyte ;

: >R4 ( b cpu -- )
  [ psw>> psw-bank-read ] keep ! get the bank value
  -rot
  8 * 4 +                          ! 8 registers by bank number
  rot
  ram-writebyte
  ;

: R4> ( cpu -- b )
  [ psw>> psw-bank-read ] keep ! get the reg bank value
  swap 8 * 4 +  ! get the address
  swap ram-readbyte ;

: >R5 ( b cpu -- )
  [ psw>> psw-bank-read ] keep ! get the bank value
  -rot
  8 * 5 +                          ! 8 registers by bank number
  rot
  ram-writebyte
  ;

: R5> ( cpu -- b )
  [ psw>> psw-bank-read ] keep ! get the reg bank value
  swap 8 * 5 +  ! get the address
  swap ram-readbyte ;

: >R6 ( b cpu -- )
  [ psw>> psw-bank-read ] keep ! get the bank value
  -rot
  8 * 6 +                      ! 8 registers by bank number
  rot
  ram-writebyte
  ;

: R6> ( cpu -- b )
  [ psw>> psw-bank-read ] keep ! get the reg bank value
  swap 8 * 6 +  ! get the address
  swap ram-readbyte ;

: >R7 ( b cpu -- )
  [ psw>> psw-bank-read ] keep ! get the bank value
  -rot
  8 * 7 +                      ! 8 registers by bank number
  rot
  ram-writebyte
  ;

: R7> ( cpu -- b )
  [ psw>> psw-bank-read ] keep ! get the reg bank value
  swap 8 * 7 +  ! get the address
  swap ram-readbyte ;

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
  [ sp>> 1 + 7 0 bit-range ] keep sp<< ;

! write to ram sp has address
: sp-write ( n cpu -- )
  [ sp>> ] keep
  ram-writebyte
  ;
! push a byte onto the stack pointer
: sp-push ( b cpu -- )
  [ 7 0 bit-range ] dip ! make sure its a byte
  [ sp+ ] keep
  sp-write
  ;

: sp-pop ( cpu -- b )
  [ sp>> ] keep
  ram-readbyte
  ;

! save the contents of pc to sp
: pc->sp ( cpu -- )
  [ pc>> 15 8 bit-range ] keep [ pc>> 7 0 bit-range ] keep
  [ sp-push ] keep sp-push ;


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

#! Reads the ROM from stdin and stores it in ROM from
#! offset n.
#! Load the contents of the file into ROM.
#! (address 0x0000-0x1FFF).
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
    #! make sure we always return with array
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
  [ a>> -1 8 bitroll ] keep swap >>a pc+ ;
  
! INC A
! Increment Accumulator
: (opcode-04) ( cpu -- )
  [ a>> 1 + 8 bits ] keep swap >>a pc+ ;

! INC (DIR)
! Increment Data RAM or SFR
: (opcode-05) ( cpu -- )
  [ dup pc+ rom-pcread ] keep
  [ ram-readbyte ] keep
  swap 1 + swap [ rom-pcread ] keep 
  [ ram-writebyte ] keep pc+ ;

! INC @R0
! Increment 8-bit internal data RAM location (0-255) addressed
! indirectly through register R0.
: (opcode-06) ( cpu -- )
  [ R0> ] keep ! get r0 value this is the adderss
  [ ram-readbyte 1 + ] keep  ! get data from ram add 1 to data
  [ R0> ] keep      ! get the r0 address value
  [ ram-writebyte ] keep pc+ ;   ! data is now save back into ram

! INC @R1
! Increment 8-bit internal RAM location (0 - 255) addressed
! indirectly through Register R1
: (opcode-07) ( cpu -- )
  [ R1> ] keep [ ram-readbyte 1 + ] keep [ R1> ] keep
  [ ram-writebyte ] keep pc+ ;

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
    break
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
  [ pc->sp ] keep
  -rot bitor swap pc<< ;

! LCALL
! Long Call
: (opcode-12) ( cpu -- )
  [ pc+ ] keep
  [ rom-pcread ] keep
  [ pc+ ] keep
  [ rom-pcread ] keep
  [ pc+ ] keep
  [ pc->sp ] keep
  -rot [ 8 shift ] dip bitor swap pc<< ;


! RRC A
! Rotate Right A through Carry


: emu-test ( -- c )
  break
  "work/intel/hex/EZSHOT.HEX"
<ihex> array>> <cpu> swap >>rom ;
