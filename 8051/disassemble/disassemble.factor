! Copyright (C) 2013 Joseph Moschini.
! See http://factorcode.org/license.txt for BSD license.
!

USING: kernel ;


IN: intel.8051.disassemble


TUPLE: mnemonic code ;


! NOP Instruction
: $(opcode-00) ( -- str )
    "NOP" 
  ;

! AJMP
! Absolute Jump
: $(opcode-01) ( -- str )
    "AJMP"
  ;

! LJMP
! Long Jump
: $(opcode-02) ( -- str )
    "LJMP"
  ;

! RR A
! Rotate Accumulator Right
: $(opcode-03) ( -- str )
    "RR A"
   ;


! INC A
! Increment Accumulator
: $(opcode-04) ( -- str )
    "INC A"
   ;

! INC (DIR)
! Increment Data RAM or SFR
: $(opcode-05) ( -- str )
    "INC (DIR)"
    ;

! INC @R0
! Increment 8-bit internal data RAM location (0-255) addressed
! indirectly through register R0.
: $(opcode-06) ( -- str )
    "INC @R0"
    ;

! INC @R1
! Increment 8-bit internal RAM location (0 - 255) addressed
! indirectly through Register R1
: $(opcode-07) ( -- str )
    "INC @R1"
    ;

! INC R0
! Increment R0
: $(opcode-08) ( -- str )
    "INC R0"
    ;


! INC R1
! Increment R1
: $(opcode-09) ( -- str )
    "INC R1"
    ;

! INC R2
! Increment R2
: $(opcode-0A) ( -- str )
    "INC R2"
    ;


! INC R3
! Increment R3
: $(opcode-0B) ( -- str )
    "INC R3"
    ;


! INC R4
! Increment R4
: $(opcode-0C) ( -- str )
    "INC R4"
    ;

! INC R5
! Increment R5
: $(opcode-0D) ( -- str )
    "INC R5"
    ;


! INC R6
! Increment R6
: $(opcode-0E) ( -- str )
    "INC R6"
    ;

! INC R7
! Increment R7
: $(opcode-0F) ( -- str )
    "INC R7"
    ;


! JBC bit,rel
! clear bit and Jump relative if bit is set
: $(opcode-10) ( -- str )
    "JBC BIT,REL"
    ;
