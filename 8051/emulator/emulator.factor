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



TUPLE: cpu a b r0 r1 r2 r3 r4 r5 r6 r7 psw dptr sp pc rom ram ;

: <cpu> ( -- cpu )
  cpu new
  0 >>pc
  0 >>a
  0 >>b
  0 <register> >>r0
  0 <register> >>r1
  0 <register> >>r2
  0 <register> >>r3
  0 <register> >>r4
  0 <register> >>r5
  0 <register> >>r6
  0 <register> >>r7
  0 <psw> >>psw
  0 >>dptr
  0 >>sp
  <ram> >>ram
!  <reg> >>reg
;


! increment the pc of cpu
: inc-pc ( cpu -- )
  dup pc>> 1 + swap pc<< ;

! read the rom addressed by pc
: readrom-pc ( cpu -- dd )
  dup pc>> swap rom>> ?nth ;

! read 16 bit data from ROM
: readromword ( address cpu -- dddd )
  [ rom>> ?nth 8 shift ] 2keep swap 1 + swap rom>> ?nth bitor 16 bits ;

! read 8 bit from RAM
: ram-readbyte ( address cpu -- dd )
  ram>> ram-read ;

: ram-writebyte ( dd address cpu -- )
  ram>> ?set-nth ;


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
  [ r0>> value>> ] keep
  [ ram-readbyte 1 + ] keep
  [ r0>> value>> ] keep
  ram-writebyte
  ;

! INC @R1
! Increment 8-bit internal RAM location (0 - 255) addressed
! indirectly through Register R1
: (opcode-07) ( cpu -- )
  [ r1>> value>> ] keep [ ram-readbyte 1 + ] keep [ r1>> reg-write ] call
  ;

: emu-test ( -- c )
  break
  "work/intel/hex/EZSHOT.HEX"
<ihex> array>> <cpu> swap >>rom ;
