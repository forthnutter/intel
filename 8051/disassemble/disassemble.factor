! Copyright (C) 2013 Joseph Moschini.
! See http://factorcode.org/license.txt for BSD license.
!

USING: kernel ;


IN: intel.8051.disassemble


TUPLE: mnemonic code ;


! NOP Instruction
: $(opcode-00) ( -- )
  ;

! AJMP
! Absolute Jump
: $(opcode-01) ( -- )
  ;

! LJMP
! Long Jump
: $(opcode-02) ( -- )
  ;

! RR A
! Rotate Accumulator Right
: $(opcode-03) ( -- )
   ;


! INC A
! Increment Accumulator
: $(opcode-04) ( -- )
   ;

! INC (DIR)
! Increment Data RAM or SFR
: $(opcode-05) ( -- )
    ;

! INC @R0
! Increment 8-bit internal data RAM location (0-255) addressed
! indirectly through register R0.
: $(opcode-06) ( -- )
    ;

! INC @R1
! Increment 8-bit internal RAM location (0 - 255) addressed
! indirectly through Register R1
: $(opcode-07) ( -- )
    ;

! INC R0
! Increment R0
: $(opcode-08) ( -- )
    ;


! INC R1
! Increment R1
: $(opcode-09) ( -- )
    ;

! INC R2
! Increment R2
: $(opcode-0A) ( -- )
    ;


! INC R3
! Increment R3
: $(opcode-0B) ( -- )
    ;


! INC R4
! Increment R4
: $(opcode-0C) ( -- )
    ;

! INC R5
! Increment R5
: $(opcode-0D) ( -- )
    ;


! INC R6
! Increment R6
: $(opcode-0E) ( -- )
    ;

! INC R7
! Increment R7
: $(opcode-0F) ( -- )
    ;


! JBC bit,rel
! clear bit and Jump relative if bit is set
: $(opcode-10) ( -- )
    ;
