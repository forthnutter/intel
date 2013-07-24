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
: inc-pc ( cpu -- )
  dup pc>> 1 + swap pc<< ;

! read the rom addressed by pc
: readrom-pc ( cpu -- dd )
  dup pc>> swap rom>> ?nth ;

! read 16 bit data from ROM
: readromword ( address cpu -- dddd )
  [ rom>> ?nth 8 shift ] 2keep swap 1 + swap rom>> ?nth bitor 16 bits ;



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
  inc-pc ;

! AJMP
! Absolute Jump
: (opcode-01) ( cpu -- )
  [ readrom-pc 0xe0 bitand 3 shift ] keep ! the instruction has part of address
  [ inc-pc ] keep [ readrom-pc ] keep -rot bitor swap pc<< ;

! LJMP
! Long Jump
: (opcode-02) ( cpu -- )
  [ inc-pc ] keep
  [ pc>> ] keep
  [ readromword ] keep pc<< ;

! RR A
! Rotate Accumulator Right
: (opcode-03) ( cpu -- )
  [ a>> -1 8 bitroll ] keep swap >>a inc-pc ;
  
! INC A
! Increment Accumulator
: (opcode-04) ( cpu -- )
  [ a>> 1 + 8 bits ] keep swap >>a inc-pc ;

! INC (DIR)
! Increment Data RAM or SFR
: (opcode-05) ( cpu -- )
  [ dup inc-pc readrom-pc ] keep
  [ ram-readbyte ] keep
  swap 1 + swap [ readrom-pc ] keep 
  [ ram-writebyte ] keep inc-pc ;

! INC @R0
! Increment 8-bit internal data RAM location (0-255) addressed
! indirectly through register R0.
: (opcode-06) ( cpu -- )
  [ R0> ] keep ! get r0 value this is the adderss
  [ ram-readbyte 1 + ] keep  ! get data from ram add 1 to data
  [ R0> ] keep      ! get the r0 address value
  [ ram-writebyte ] keep inc-pc ;   ! data is now save back into ram

! INC @R1
! Increment 8-bit internal RAM location (0 - 255) addressed
! indirectly through Register R1
: (opcode-07) ( cpu -- )
  [ R1> ] keep [ ram-readbyte 1 + ] keep [ R1> ] keep
  [ ram-writebyte ] keep inc-pc ;

! INC R0
! Increment R0
: (opcode-08) ( cpu -- )
  [ R0> 1 + ] keep [ >R0 ] keep inc-pc ;


: emu-test ( -- c )
  break
  "work/intel/hex/EZSHOT.HEX"
<ihex> array>> <cpu> swap >>rom ;
