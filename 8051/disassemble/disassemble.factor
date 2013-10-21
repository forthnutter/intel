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



! ACALL
! Absolute Call
: $(opcode-11) ( -- str )
    "ACALL" ;

! LCALL
! Long Call
: $(opcode-12) ( -- str )
    "LCALL" ;

! RRC A
! Rotate Right A through Carry
: $(opcode-13) ( -- str )
    "RRC A" ;

! DEC A
: $(opcode-14) ( -- str )
    "DEC A" ;

! DEC (DIR)
! Decrement Data RAM or SFR
: $(opcode-15) ( -- str )
    "DEC " ;

! DEC @R0
! Decrement 8-bit internal data RAM location (0-255) addressed
! indirectly through register R0.
: $(opcode-16) ( -- str )
    "DEC @R0" ;

! DEC @R1
! Decrement 8-bit internal data RAM location (0-255) addressed
! indirectly through register R1.
: $(opcode-17) ( -- str )
    "DEC @R1" ;

! DEC R0
! Decrement R0
: $(opcode-18) ( -- str )
    "DEC R0" ;

! DEC R1
! Decrement R1
: $(opcode-19) ( -- str )
    "DEC R1" ;

! DEC R2
! Decrement R2
: $(opcode-1A) ( -- str )
    "DEC R2" ;

! DEC R3
! Decrement R3
: $(opcode-1B) ( -- str )
    "DEC R3" ;

! DEC R4
! Decrement R4
: $(opcode-1C) ( -- str )
    "DEC R4" ;

! DEC R5
! Decrement R5
: $(opcode-1D) ( -- str )
    "DEC R5" ;

! DEC R6
! Decrement R6
: $(opcode-1E) ( -- str )
    "DEC R6" ;

! DEC R7
! Decrement R7
: $(opcode-1F) ( -- str )
    "DEC R7" ;

! JB bit,rel
! Jump relative if bit is set
: $(opcode-20) ( -- str )
    "JB" ;

! AJMP
! Absolute Jump
: $(opcode-21) ( --  str )
  $(opcode-01) ;

! RET
! Return from subroutine pop PC off the stack
: $(opcode-22) ( -- str )
    "RET" ;
  
! RL A
! Rotate Accumulator Left
: $(opcode-23) ( -- str )
    "RL A" ;

! ADD A,#data
: $(opcode-24) ( -- str )
    "ADD A" ;

! ADD A,dir
: $(opcode-25) ( -- str )
    "ADD A" ;

! ADD A,@R0
: $(opcode-26) ( -- str )
    "ADD A,@R0" ;
  
! ADD A,@R1
: $(opcode-27) ( -- str )
    "ADD A,@R1" ;

! ADD A,R0
: $(opcode-28) ( -- str )
    "ADD A,R0" ;

! ADD A,R1
: $(opcode-29) ( -- str )
    "ADD A,R1" ;

! ADD A,R2
: $(opcode-2A) ( -- str )
    "ADD A,R2" ;

! ADD A,R3
: $(opcode-2B) ( -- str )
    "ADD A,R3" ;

! ADD A,R4
: $(opcode-2C) ( -- str )
    "ADD A,R4" ;

! ADD A,R5
: $(opcode-2D) ( -- str )
    "ADD A,R5" ;

! ADD A,R6
: $(opcode-2E) ( -- str )
    "ADD A,R6" ;

! ADD A,R7
: $(opcode-2F) ( -- str )
    "ADD A,R7" ;

! JNB bit,rel
! Jump relative if bit is clear
: $(opcode-30) ( -- str )
    "JNB" ;

! ACALL
: $(opcode-31) ( -- str )
    $(opcode-11) ;
    
! RETI
: $(opcode-32) ( -- str )
    "RETI" ;

! RLC A
: $(opcode-33) ( -- str )
    "RLC A" ;

! ADDC A,#data  
: $(opcode-34) ( -- str )
    "ADDC A" ;

! ADDC A,dir
: $(opcode-35) ( -- str )
    "ADDC A" ;

! ADDC A,@R0
: $(opcode-36) ( -- str )
    "ADDC A,@R0" ;

! ADDC A,@R1
: $(opcode-37) ( -- str )
    "ADDC A,@R1" ;

! ADDC A,R0
: $(opcode-38) ( -- str )
    "ADDC A,R0" ;

! ADDC A,R1
: $(opcode-39) ( -- str )
    "ADDC A,R1" ;

! ADDC A,R2
: $(opcode-3A) ( -- str )
    "ADDC A,R2" ;

! ADDC A,R3
: $(opcode-3B) ( -- str )
    "ADDC A,R3" ;

! ADDC A,R4
: $(opcode-3C) ( -- str )
    "ADDC A,R4" ;

! ADDC A,R5
: $(opcode-3D) ( -- str )
    "ADDC A,R5" ;

! ADDC A,R6
: $(opcode-3E) ( -- str )
    "ADDC A,R6" ;

! ADDC A,R7
: $(opcode-3F) ( -- str )
    "ADDC A,R7" ;

! JC rel
! Jump relative if carry is set
: $(opcode-40) ( -- str )
    "JC" ;

! AJUMP
! Absolute Jump
: $(opcode-41) ( -- str )
    $(opcode-21) ;
    
! ORL dir,A
! Logical-OR for byte variables
: $(opcode-42) ( -- str )
    "ORL ,A" ;

! ORL direct,#data
: $(opcode-43) ( -- str )
    "ORL " ;

! ORL A,#data
: $(opcode-44) ( -- str )
    "ORL A" ;

! ORL A,direct
: $(opcode-45) ( -- str )
    "ORL A" ;

! ORL A,@R0
: $(opcode-46) ( -- str )
    "ORL A,@R0" ;

! ORL A,@R1
: $(opcode-47) ( -- str )
    "ORL A,@R1" ;
    
! ORL A,R0
: $(opcode-48) ( -- str )
    "ORL A,R0" ;

! ORL A,R1
: $(opcode-49) ( -- str )
    "ORL A,R1" ;

! ORL A,R2
: $(opcode-4A) ( -- str )
    "ORL A,R2" ;

! ORL A,R3
: $(opcode-4B) ( -- str )
    "ORL A,R3" ;

! ORL A,R4
: $(opcode-4C) ( -- str )
    "ORL A,R4" ;

! ORL A,R5
: $(opcode-4D) ( -- str )
    "ORL A,R5" ;

! ORL A,R6
: $(opcode-4E) ( -- str )
    "ORL A,R6" ;

! ORL A,R7
: $(opcode-4F) ( -- str )
    "ORL A,R7" ;

! JNC Rel
! Jump relative if carry is clear
: $(opcode-50) ( -- str )
    "JNC" ;

: $(opcode-51) ( -- str )
    $(opcode-31) ;
    
! ANL direct,A
: $(opcode-52) ( -- str )
    "ANL ,A" ;

! ANL direct,#data
: $(opcode-53) ( -- str )
    "ANL " ;

! ANL A,#data
: $(opcode-54) ( -- str )
    "ANL A," ;

! ANL A,direct
: $(opcode-55) ( -- str )
    "ANL A," ;

! ANL A,@R0
: $(opcode-56) ( -- str )
    "ANL A,@R0" ;

! ANL A,@R1
: $(opcode-57) ( -- str )
    "ANL A,@R1" ;
    
! ANL A,R0
: $(opcode-58) ( -- str )
    "ANL A,R0" ;

! ANL A,R1
: $(opcode-59) ( -- str )
    "ANL A,R1" ;

! ANL A,R2
: $(opcode-5A) ( -- str )
    "ANL A,R2" ;

! ANL A,R3
: $(opcode-5B) ( -- str )
    "ANL A,R4" ;

! ANL A,R4
: $(opcode-5C) ( -- str )
    "ANL A,R4" ;

! ANL A,R5
: $(opcode-5D) ( -- str )
    "ANL A,R5" ;

! ANL A,R6
: $(opcode-5E) ( -- str )
    "ANL A,R6" ;

! ANL A,R7
: $(opcode-5F) ( -- str )
    "ANL A,R7" ;

! JZ
! if A = 0 jump rel
: $(opcode-60) ( -- str )
    "JZ" ;

!
: $(opcode-61) ( -- str )
    $(opcode-41) ;


! XRL direct,A
: $(opcode-62) ( -- str )
    "XRL ,A" ;

! XRL direct,#data
: $(opcode-63) ( cpu -- )
;

! XRL A,#data
: $(opcode-64) ( cpu -- )
;

! XRL A,direct
: $(opcode-65) ( cpu -- )
;

! XRL A,@R0
: $(opcode-66) ( cpu -- )
;
    
! XRL A,@R1
: $(opcode-67) ( cpu -- )
;
 
! XRL A,R0
: $(opcode-68) ( cpu -- )
;

! XRL A,R1
: $(opcode-69) ( cpu -- )
;

! XRL A,R2
: $(opcode-6A) ( cpu -- )
;

! XRL A,R3
: $(opcode-6B) ( cpu -- )
;

! XRL A,R4
: $(opcode-6C) ( cpu -- )
;

! XRL A,R5
: $(opcode-6D) ( cpu -- )
;
    
! XRL A,R6
: $(opcode-6E) ( cpu -- )
;

! XRL A,R7
: $(opcode-6F) ( cpu -- )
;

! JNZ
! if A != 0 jump rel
: $(opcode-70) ( cpu -- )
;

: $(opcode-71) ( cpu -- )
    $(opcode-51) ;

! ORL C,bit
: $(opcode-72) ( cpu -- )
;

! JMP @A+DPTR    
: $(opcode-73) ( cpu -- )
;

! MOV A,#data
: $(opcode-74) ( cpu -- )
;
    
! MOV direct,#data
: $(opcode-75) ( cpu -- )
;

! MOV @R0,#data
: $(opcode-76) ( cpu -- )
;
 
! MOV @R1,#data
: $(opcode-77) ( cpu -- )
;
 
! MOV R0,#data
: $(opcode-78) ( cpu -- )
;

! MOV R1,#data
: $(opcode-79) ( cpu -- )
;

! MOV R2,#data
: $(opcode-7A) ( cpu -- )
;

! MOV R3,#data
: $(opcode-7B) ( cpu -- )
;

! MOV R4,#data
: $(opcode-7C) ( cpu -- )
;

! MOV R5,#data
: $(opcode-7D) ( cpu -- )
;

! MOV R6,#data
: $(opcode-7E) ( cpu -- )
;

! MOV R7,#data
: $(opcode-7F) ( cpu -- )
;

! SJMP rel
: $(opcode-80) ( cpu -- )
;

: $(opcode-81) ( cpu -- )
    $(opcode-61) ;
    
! ANL C,bit
: $(opcode-82) ( cpu -- )
;

! MOVC A,@A+PC
: $(opcode-83) ( cpu -- )
;
 
! DIV AB 
: $(opcode-84) ( cpu -- )
;

! MOV direct,direct
: $(opcode-85) ( cpu -- )
;

! MOV direct,@R0
: $(opcode-86) ( cpu -- )
;
    
! MOV direct,@R1
: $(opcode-87) ( cpu -- )
;
    
! MOV direct,R0
: $(opcode-88) ( cpu -- )
;

! MOV direct,R1
: $(opcode-89) ( cpu -- )
;

! MOV direct,R2
: $(opcode-8A) ( cpu -- )
;

! MOV direct,R3
: $(opcode-8B) ( cpu -- )
;

! MOV direct,R4
: $(opcode-8C) ( cpu -- )
;

! MOV direct,R5
: $(opcode-8D) ( cpu -- )
;

! MOV direct,R6
: $(opcode-8E) ( cpu -- )
;

! MOV direct,R7
: $(opcode-8F) ( cpu -- )
;

! MOV DPTR,#data16
: $(opcode-90) ( cpu -- )
;

: $(opcode-91) ( cpu -- )
    $(opcode-71) ;

! MOV bit,C
: $(opcode-92) ( cpu -- )
;

! MOVC A,@A+DPTR    
: $(opcode-93) ( cpu -- )
;

! SUBB A,#data
: $(opcode-94) ( cpu -- )
;
 
! SUBB A,direct 
: $(opcode-95) ( cpu -- )
;
    
! SUBB A,@R0
: $(opcode-96) ( cpu -- )
;

! SUBB A,@R1
: $(opcode-97) ( cpu -- )
;

! SUBB A,R0
: $(opcode-98) ( cpu -- )
;

! SUBB A,R1
: $(opcode-99) ( cpu -- )
;

! SUBB A,R2
: $(opcode-9A) ( cpu -- )
;

! SUBB A,R3
: $(opcode-9B) ( cpu -- )
;

! SUBB A,R4
: $(opcode-9C) ( cpu -- )
;

! SUBB A,R5
: $(opcode-9D) ( cpu -- )
;

! SUBB A,R6
: $(opcode-9E) ( cpu -- )
;

! SUBB A,R7
: $(opcode-9F) ( cpu -- )
;

! ORL C,/bit
: $(opcode-A0) ( cpu -- )
;

: $(opcode-A1) ( cpu -- )
    $(opcode-81) ;
    
    
! MOV C,bit
: $(opcode-A2) ( cpu -- )
;
    
! INC DPTR
: $(opcode-A3) ( cpu -- )
;

! MUL AB
: $(opcode-A4) ( cpu -- )
;
    
: $(opcode-A5) ( cpu -- )
    $(opcode-00) ;


! MOV @R0,direct
: $(opcode-A6) ( cpu -- )
;

! MOV @R0,direct
: $(opcode-A7) ( cpu -- )
;

! MOV A,R0
: $(opcode-A8) ( cpu -- )
;

! MOV A,R1
: $(opcode-A9) ( cpu -- )
;

! MOV A,R2
: $(opcode-AA) ( cpu -- )
;

! MOV A,R3
: $(opcode-AB) ( cpu -- )
;

! MOV A,R4
: $(opcode-AC) ( cpu -- )
;

! MOV A,R5
: $(opcode-AD) ( cpu -- )
;

! MOV A,R6
: $(opcode-AE) ( cpu -- )
;

! MOV A,R7
: $(opcode-AF) ( cpu -- )
;

! ANL C,/bit
: $(opcode-B0) ( cpu -- )
;

: $(opcode-B1) ( cpu -- )
    $(opcode-91) ;

! CPL bit
: $(opcode-B2) ( cpu -- )
;

! CPL C
: $(opcode-B3) ( cpu -- )
;

! CJNE A,#data,rel
! (PC) ← (PC) + 3
! IF (A) < > data THEN (PC) ← (PC) + relative offset
! IF (A) < data THEN (C) ← 1 ELSE(C) ← 0
: $(opcode-B4) ( cpu -- )
;

! CJNE A,direct,rel
: $(opcode-B5) ( cpu -- )
;

! CJNE @R0,data,rel
: $(opcode-B6) ( cpu -- )
;

! CJNE @R1,data,rel
: $(opcode-B7) ( cpu -- )
;

! CJNE R0,#data,rel
: $(opcode-B8) ( cpu -- )
;

! CJNE R1,#data,rel
: $(opcode-B9) ( cpu -- )
;

! CJNE R2,#data,rel
: $(opcode-BA) ( cpu -- )
;

! CJNE R3,#data,rel
: $(opcode-BB) ( cpu -- )
;

! CJNE R4,#data,rel
: $(opcode-BC) ( cpu -- )
;

! CJNE R5,#data,rel
: $(opcode-BD) ( cpu -- )
;

! CJNE R6,#data,rel
: $(opcode-BE) ( cpu -- )
;

! CJNE R7,#data,rel
: $(opcode-BF) ( cpu -- )
;

! PUSH direct
: $(opcode-C0) ( cpu -- )
;

: $(opcode-C1) ( cpu -- )
    $(opcode-A1) ;

! CLR bit
: $(opcode-C2) ( cpu -- )
;

! CLR C
: $(opcode-C3) ( cpu -- )
;

! SWAP A
: $(opcode-C4) ( cpu -- )
;

! XCH A,direct
: $(opcode-C5) ( cpu -- )
;

! XCH A,@R0
: $(opcode-C6) ( cpu -- )
;

! XCH A,@R1
: $(opcode-C7) ( cpu -- )
;

! XCH A,R0
: $(opcode-C8) ( cpu -- )
;

! XCH A,R1
: $(opcode-C9) ( cpu -- )
;

! XCH A,R2
: $(opcode-CA) ( cpu -- )
;

! XCH A,R3
: $(opcode-CB) ( cpu -- )
;

! XCH A,R4
: $(opcode-CC) ( cpu -- )
;

! XCH A,R5
: $(opcode-CD) ( cpu -- )
;

! XCH A,R6
: $(opcode-CE) ( cpu -- )
;

! XCH A,R7
: $(opcode-CF) ( cpu -- )
;

! POP direct
: $(opcode-D0) ( cpu -- )
;

: $(opcode-D1) ( cpu -- )
    $(opcode-B1) ;


! SETB bit
: $(opcode-D2) ( cpu -- )
;

! SETB C
: $(opcode-D3) ( cpu -- )
;

! DA A
: $(opcode-D4) ( cpu -- )
;

! DJNZ direct,rel
: $(opcode-D5) ( cpu -- )
;

! XCHD A,@R0
: $(opcode-D6) ( cpu -- )
;

! XCHD A,@R1
: $(opcode-D7) ( cpu -- )
;

! DJNZ R0,rel
: $(opcode-D8) ( cpu -- )
;

! DJNZ R1,rel
: $(opcode-D9) ( cpu -- )
;

! DJNZ R2,rel
: $(opcode-DA) ( cpu -- )
;

! DJNZ R3,rel
: $(opcode-DB) ( cpu -- )
;

! DJNZ R4,rel
: $(opcode-DC) ( cpu -- )
;

! DJNZ R5,rel
: $(opcode-DD) ( cpu -- )
;

! DJNZ R6,rel
: $(opcode-DE) ( cpu -- )
;

! DJNZ R7,rel
: $(opcode-DF) ( cpu -- )
;

! MOVX A,@DPTR
: $(opcode-E0) ( cpu -- )
;

: $(opcode-E1) ( cpu -- )
    $(opcode-C1) ;

! MOVX A,@R0
: $(opcode-E2) ( cpu -- )
;

! MOVX A,@R1
: $(opcode-E3) ( cpu -- )
;

! CLR A
: $(opcode-E4) ( cpu -- )
;

! MOV A,direct
: $(opcode-E5) ( cpu -- )
;

! MOV A,@R0
: $(opcode-E6) ( cpu -- )
;


! MOV A,@R1
: $(opcode-E7) ( cpu -- )
;

! MOV A,R0
: $(opcode-E8) ( cpu -- )
;

! MOV A,R1
: $(opcode-E9) ( cpu -- )
;

! MOV A,R2
: $(opcode-EA) ( cpu -- )
;

! MOV A,R3
: $(opcode-EB) ( cpu -- )
;
 
! MOV A,R4
: $(opcode-EC) ( cpu -- )
;

! MOV A,R5
: $(opcode-ED) ( cpu -- )
;

! MOV A,R6
: $(opcode-EE) ( cpu -- )
;

! MOV A,R7
: $(opcode-EF) ( cpu -- )
;

! MOVX @DPTR,A
: $(opcode-F0) ( cpu -- )
;

: $(opcode-F1) ( cpu -- )
    $(opcode-D1) ;

! MOVX @R0,A
: $(opcode-F2) ( cpu -- )
;

! MOVX @R1,A
: $(opcode-F3) ( cpu -- )
;

! CPL A
: $(opcode-F4) ( cpu -- )
;

! MOV direct,A
: $(opcode-F5) ( cpu -- )
;

! MOV @R0,A
: $(opcode-F6) ( cpu -- )
;

! MOV @R1,A
: $(opcode-F7) ( cpu -- )
;

! MOV R0,A
: $(opcode-F8) ( cpu -- )
;

! MOV R1,A
: $(opcode-F9) ( cpu -- )
;

! MOV R2,A
: $(opcode-FA) ( cpu -- )
;

! MOV R3,A
: $(opcode-FB) ( cpu -- )
;

! MOV R4,A
: $(opcode-FC) ( cpu -- )
;

! MOV R5,A
: $(opcode-FD) ( cpu -- )
;

! MOV R6,A
: $(opcode-FE) ( cpu -- )
;

! MOV R7,A
: $(opcode-FF) ( cpu -- )
;
