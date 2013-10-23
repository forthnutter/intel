! Copyright (C) 2013 Joseph Moschini.
! See http://factorcode.org/license.txt for BSD license.
!

USING: kernel intel.8051.emulator ;


IN: intel.8051.disassemble


TUPLE: mnemonic code ;


! NOP Instruction
: $(opcode-00) ( cpu -- str )
    drop
    "NOP" ;

! AJMP
! Absolute Jump
: $(opcode-01) ( cpu -- str )
    drop
    "AJMP" ;

! LJMP
! Long Jump
: $(opcode-02) ( cpu -- str )
    drop
    "LJMP" ;

! RR A
! Rotate Accumulator Right
: $(opcode-03) ( cpu -- str )
    drop
    "RR A" ;


! INC A
! Increment Accumulator
: $(opcode-04) ( cpu -- str )
    drop "INC A" ;

! INC (DIR)
! Increment Data RAM or SFR
: $(opcode-05) ( cpu -- str )
    drop "INC (DIR)" ;

! INC @R0
! Increment 8-bit internal data RAM location (0-255) addressed
! indirectly through register R0.
: $(opcode-06) ( cpu -- str )
    drop "INC @R0" ;

! INC @R1
! Increment 8-bit internal RAM location (0 - 255) addressed
! indirectly through Register R1
: $(opcode-07) ( cpu -- str )
    drop "INC @R1" ;

! INC R0
! Increment R0
: $(opcode-08) ( cpu -- str )
    drop "INC R0" ;


! INC R1
! Increment R1
: $(opcode-09) ( cpu -- str )
    drop "INC R1" ;

! INC R2
! Increment R2
: $(opcode-0A) ( cpu -- str )
    drop "INC R2" ;


! INC R3
! Increment R3
: $(opcode-0B) ( cpu -- str )
    drop "INC R3" ;


! INC R4
! Increment R4
: $(opcode-0C) ( cpu -- str )
    drop "INC R4" ;

! INC R5
! Increment R5
: $(opcode-0D) ( cpu -- str )
    drop "INC R5" ;


! INC R6
! Increment R6
: $(opcode-0E) ( cpu -- str )
    drop "INC R6" ;

! INC R7
! Increment R7
: $(opcode-0F) ( cpu -- str )
    drop "INC R7" ;


! JBC bit,rel
! clear bit and Jump relative if bit is set
: $(opcode-10) ( cpu -- str )
    drop "JBC BIT,REL" ;

! ACALL
! Absolute Call
: $(opcode-11) ( cpu -- str )
    drop "ACALL" ;

! LCALL
! Long Call
: $(opcode-12) ( cpu -- str )
    drop "LCALL" ;

! RRC A
! Rotate Right A through Carry
: $(opcode-13) ( cpu -- str )
    drop "RRC A" ;

! DEC A
: $(opcode-14) ( cpu -- str )
    drop "DEC A" ;

! DEC (DIR)
! Decrement Data RAM or SFR
: $(opcode-15) ( cpu -- str )
    drop "DEC " ;

! DEC @R0
! Decrement 8-bit internal data RAM location (0-255) addressed
! indirectly through register R0.
: $(opcode-16) ( cpu -- str )
    drop "DEC @R0" ;

! DEC @R1
! Decrement 8-bit internal data RAM location (0-255) addressed
! indirectly through register R1.
: $(opcode-17) ( cpu -- str )
    drop "DEC @R1" ;

! DEC R0
! Decrement R0
: $(opcode-18) ( cpu -- str )
    drop "DEC R0" ;

! DEC R1
! Decrement R1
: $(opcode-19) ( cpu -- str )
    drop "DEC R1" ;

! DEC R2
! Decrement R2
: $(opcode-1A) ( cpu -- str )
    drop "DEC R2" ;

! DEC R3
! Decrement R3
: $(opcode-1B) ( cpu -- str )
    drop "DEC R3" ;

! DEC R4
! Decrement R4
: $(opcode-1C) ( cpu -- str )
    drop "DEC R4" ;

! DEC R5
! Decrement R5
: $(opcode-1D) ( cpu -- str )
    drop "DEC R5" ;

! DEC R6
! Decrement R6
: $(opcode-1E) ( cpu -- str )
    drop "DEC R6" ;

! DEC R7
! Decrement R7
: $(opcode-1F) ( cpu -- str )
    drop "DEC R7" ;

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
: $(opcode-63) ( -- str )
    "XRL ";

! XRL A,#data
: $(opcode-64) ( -- str )
    "XRL A," ;

! XRL A,direct
: $(opcode-65) ( -- str )
    "XRL A," ;

! XRL A,@R0
: $(opcode-66) ( -- str )
    "XRL A,@R0" ;
    
! XRL A,@R1
: $(opcode-67) ( -- str )
    "XRL A,@R1" ;
 
! XRL A,R0
: $(opcode-68) ( -- str )
    "XRL A,R0" ;

! XRL A,R1
: $(opcode-69) ( -- str )
    "XRL A,R1" ;

! XRL A,R2
: $(opcode-6A) ( -- str )
    "XRL A,R2" ;

! XRL A,R3
: $(opcode-6B) ( -- str )
    "XRL A,R3" ;

! XRL A,R4
: $(opcode-6C) ( -- str )
    "XRL A,R4" ;

! XRL A,R5
: $(opcode-6D) ( -- str )
    "XRL A,R5" ;
    
! XRL A,R6
: $(opcode-6E) ( -- str )
    "XRL A,R6" ;

! XRL A,R7
: $(opcode-6F) ( -- str )
    "XRL A,R7" ;

! JNZ
! if A != 0 jump rel
: $(opcode-70) ( -- str )
    "JNZ" ;

: $(opcode-71) ( -- str )
    $(opcode-51) ;

! ORL C,bit
: $(opcode-72) ( -- str )
    "ORL C," ;

! JMP @A+DPTR    
: $(opcode-73) ( -- str )
    "JMP @A+DPTR" ;

! MOV A,#data
: $(opcode-74) ( -- str )
    "MOV A," ;
    
! MOV direct,#data
: $(opcode-75) ( -- str )
    "MOV " ;

! MOV @R0,#data
: $(opcode-76) ( -- str )
    "MOV @R0," ;
 
! MOV @R1,#data
: $(opcode-77) ( -- str )
    "MOV @R1," ;
 
! MOV R0,#data
: $(opcode-78) ( -- str )
    "MOV R0,#" ;

! MOV R1,#data
: $(opcode-79) ( -- str )
    "MOV R1,#" ;

! MOV R2,#data
: $(opcode-7A) ( -- str )
    "MOV R2,#" ;

! MOV R3,#data
: $(opcode-7B) ( -- str )
    "MOV R3,#" ;

! MOV R4,#data
: $(opcode-7C) ( -- str )
    "MOV R4,#" ;

! MOV R5,#data
: $(opcode-7D) ( -- str )
    "MOV R5,#" ;

! MOV R6,#data
: $(opcode-7E) ( -- str )
    "MOV R6,#" ;

! MOV R7,#data
: $(opcode-7F) ( -- str )
    "MOV R7,#" ;

! SJMP rel
: $(opcode-80) ( -- str )
    "SJMP " ;

: $(opcode-81) ( -- str )
    $(opcode-61) ;
    
! ANL C,bit
: $(opcode-82) ( -- str )
    "ANL C," ;

! MOVC A,@A+PC
: $(opcode-83) ( -- str )
    "MOVC A,@A+PC" ;
 
! DIV AB 
: $(opcode-84) ( -- str )
    "DIV AB" ;

! MOV direct,direct
: $(opcode-85) ( -- str )
    "MOV" ;

! MOV direct,@R0
: $(opcode-86) ( -- str )
    "MOV ,@R0" ;
    
! MOV direct,@R1
: $(opcode-87) ( -- str )
    "MOV ,@R1" ;
    
! MOV direct,R0
: $(opcode-88) ( -- str )
    "MOV ,R0" ;

! MOV direct,R1
: $(opcode-89) ( -- str )
    "MOV ,R1" ;

! MOV direct,R2
: $(opcode-8A) ( --  str )
    "MOV ,R2" ;

! MOV direct,R3
: $(opcode-8B) ( -- str )
    "MOV ,R3" ;

! MOV direct,R4
: $(opcode-8C) ( -- str )
    "MOV ,R4" ;

! MOV direct,R5
: $(opcode-8D) ( -- str )
    "MOV ,R5" ;

! MOV direct,R6
: $(opcode-8E) ( -- str )
    "MOV ,R6" ;

! MOV direct,R7
: $(opcode-8F) ( -- str )
    "MOV ,R7" ;

! MOV DPTR,#data16
: $(opcode-90) ( -- str )
    "MOV DPTR," ;

: $(opcode-91) ( -- str )
    $(opcode-71) ;

! MOV bit,C
: $(opcode-92) ( -- str )
    "MOV ,C" ;

! MOVC A,@A+DPTR    
: $(opcode-93) ( -- str )
    "MOVC A,@A+DPTR" ;

! SUBB A,#data
: $(opcode-94) ( -- str )
    "SUBB A,#" ;
 
! SUBB A,direct 
: $(opcode-95) ( -- str )
    "SUBB A," ;
    
! SUBB A,@R0
: $(opcode-96) ( -- str )
    "SUBB A,@R0" ;

! SUBB A,@R1
: $(opcode-97) ( -- str )
    "SUBB A,@R1" ;

! SUBB A,R0
: $(opcode-98) ( -- str )
    "SUBB A,R0" ;

! SUBB A,R1
: $(opcode-99) ( -- str )
    "SUBB A,R1" ;

! SUBB A,R2
: $(opcode-9A) ( -- str )
    "SUBB A,R2" ;

! SUBB A,R3
: $(opcode-9B) ( -- str )
    "SUBB A,R3" ;

! SUBB A,R4
: $(opcode-9C) ( -- str )
    "SUBB A,R4" ;

! SUBB A,R5
: $(opcode-9D) ( -- str )
    "SUBB A,R5" ;

! SUBB A,R6
: $(opcode-9E) ( -- str )
    "SUBB A,R6" ;

! SUBB A,R7
: $(opcode-9F) ( -- str )
    "SUBB A,R7" ;

! ORL C,/bit
: $(opcode-A0) ( -- str )
    "ORL C,/" ;

: $(opcode-A1) ( -- str )
    $(opcode-81) ;
    
    
! MOV C,bit
: $(opcode-A2) ( -- str )
    "MOV C," ;
    
! INC DPTR
: $(opcode-A3) ( -- str )
    "INC DPTR" ;

! MUL AB
: $(opcode-A4) ( -- str )
    "MUL AB" ;
    
: $(opcode-A5) ( -- str )
    $(opcode-00) ;


! MOV @R0,direct
: $(opcode-A6) ( -- str )
    "MOV @R0," ;

! MOV @R1,direct
: $(opcode-A7) ( -- str )
    "MOV @R1," ;

! MOV A,R0
: $(opcode-A8) ( -- str )
    "MOV A,R0" ;

! MOV A,R1
: $(opcode-A9) ( -- str )
    "MOV A,R1" ;

! MOV A,R2
: $(opcode-AA) ( -- str )
    "MOV A,R2" ;

! MOV A,R3
: $(opcode-AB) ( -- str )
    "MOV A,R4" ;

! MOV A,R4
: $(opcode-AC) ( -- str )
    "MOV A,R4" ;

! MOV A,R5
: $(opcode-AD) ( -- str )
    "MOV A,R5" ;

! MOV A,R6
: $(opcode-AE) ( -- str )
    "MOV A,R6" ;

! MOV A,R7
: $(opcode-AF) ( -- str )
    "MOV A,R7" ;

! ANL C,/bit
: $(opcode-B0) ( -- str )
    "ANL C,/" ;

: $(opcode-B1) ( -- str )
    $(opcode-91) ;

! CPL bit
: $(opcode-B2) ( -- str )
    "CPL " ;

! CPL C
: $(opcode-B3) ( -- str )
    "CPL C" ;

! CJNE A,#data,rel
! (PC) ← (PC) + 3
! IF (A) < > data THEN (PC) ← (PC) + relative offset
! IF (A) < data THEN (C) ← 1 ELSE(C) ← 0
: $(opcode-B4) ( -- str )
    "CJNE A,#," ;

! CJNE A,direct,rel
: $(opcode-B5) ( -- str )
    "CJNE A,," ;

! CJNE @R0,data,rel
: $(opcode-B6) ( -- str )
    "CJNE @R0,," ;

! CJNE @R1,data,rel
: $(opcode-B7) ( -- str )
    "CJNE @R1,," ;

! CJNE R0,#data,rel
: $(opcode-B8) ( -- str )
    "CJNE R0,#," ;

! CJNE R1,#data,rel
: $(opcode-B9) ( -- str )
    "CJNE R1,#," ;

! CJNE R2,#data,rel
: $(opcode-BA) ( -- str )
    "CJNE R2,#," ;

! CJNE R3,#data,rel
: $(opcode-BB) ( -- str )
    "CJNE R3,#," ;

! CJNE R4,#data,rel
: $(opcode-BC) ( -- str )
    "CJNE R4,#," ;

! CJNE R5,#data,rel
: $(opcode-BD) ( -- str )
    "CJNE R5,#," ;

! CJNE R6,#data,rel
: $(opcode-BE) ( -- str )
    "CJNE R6,#," ;

! CJNE R7,#data,rel
: $(opcode-BF) ( -- str )
    "CJNE R7,#," ;

! PUSH direct
: $(opcode-C0) ( -- str )
    "PUSH " ;

: $(opcode-C1) ( -- str )
    $(opcode-A1) ;

! CLR bit
: $(opcode-C2) ( -- str )
    "CLR " ;

! CLR C
: $(opcode-C3) ( -- str )
    "CLR C" ;

! SWAP A
: $(opcode-C4) ( -- str )
    "SWAP A" ;

! XCH A,direct
: $(opcode-C5) ( -- str )
    "XCH A," ;

! XCH A,@R0
: $(opcode-C6) ( -- str )
    "XCH A,@R0" ;

! XCH A,@R1
: $(opcode-C7) ( -- str )
    "XCH A,@R1" ;

! XCH A,R0
: $(opcode-C8) ( -- str )
    "XCH A,R0" ;

! XCH A,R1
: $(opcode-C9) ( -- str )
    "XCH A,R1" ;

! XCH A,R2
: $(opcode-CA) ( -- str )
    "XCH A,R2" ;

! XCH A,R3
: $(opcode-CB) ( -- str )
    "XCH A,R3" ;

! XCH A,R4
: $(opcode-CC) ( -- str )
    "XCH A,R4" ;

! XCH A,R5
: $(opcode-CD) ( -- str )
    "XCH A,R5" ;

! XCH A,R6
: $(opcode-CE) ( -- str )
    "XCH A,R6" ;

! XCH A,R7
: $(opcode-CF) ( -- str )
    "XCH A,R7" ;

! POP direct
: $(opcode-D0) ( -- str )
    "POP " ;

: $(opcode-D1) ( -- str )
    $(opcode-B1) ;


! SETB bit
: $(opcode-D2) ( -- str )
    "SETB " ;

! SETB C
: $(opcode-D3) ( -- str )
    "SETB C" ;

! DA A
: $(opcode-D4) ( -- str )
    "DA A" ;

! DJNZ direct,rel
: $(opcode-D5) ( -- str )
    "DJNZ" ;

! XCHD A,@R0
: $(opcode-D6) ( -- str )
    "XCHD A,@R0" ;

! XCHD A,@R1
: $(opcode-D7) ( -- str )
    "XCHD A,@R1" ;

! DJNZ R0,rel
: $(opcode-D8) ( -- str )
    "DJNZ R0," ;

! DJNZ R1,rel
: $(opcode-D9) ( -- str )
    "DJNZ R1" ;

! DJNZ R2,rel
: $(opcode-DA) ( -- str )
    "DJNZ R2," ;

! DJNZ R3,rel
: $(opcode-DB) ( -- str )
    "DJNZ R3," ;

! DJNZ R4,rel
: $(opcode-DC) ( -- str )
    "DJNZ R4," ;

! DJNZ R5,rel
: $(opcode-DD) ( -- str )
    "DJNZ R5," ;

! DJNZ R6,rel
: $(opcode-DE) ( -- str )
    "DJNZ R6," ;

! DJNZ R7,rel
: $(opcode-DF) ( -- str )
    "DJNZ R7," ;

! MOVX A,@DPTR
: $(opcode-E0) ( -- str )
    "MOVX A,@DPTR" ;

: $(opcode-E1) ( -- str )
    $(opcode-C1) ;

! MOVX A,@R0
: $(opcode-E2) ( -- str )
    "MOVX A,@R0" ;

! MOVX A,@R1
: $(opcode-E3) ( -- str )
    "MOVX A,@R1" ;

! CLR A
: $(opcode-E4) ( -- str )
    "CLR A" ;

! MOV A,direct
: $(opcode-E5) ( -- str )
    "MOV A," ;

! MOV A,@R0
: $(opcode-E6) ( -- str )
    "MOV A,@R0" ;


! MOV A,@R1
: $(opcode-E7) ( -- str )
    "MOV A,@R1" ;

! MOV A,R0
: $(opcode-E8) ( -- str )
    "MOV A,R0" ;

! MOV A,R1
: $(opcode-E9) ( -- str )
    "MOV A,R1" ;

! MOV A,R2
: $(opcode-EA) ( -- str )
    "MOV A,R2" ;

! MOV A,R3
: $(opcode-EB) ( -- str )
    "MOV A,R3" ;
 
! MOV A,R4
: $(opcode-EC) ( -- str )
    "MOV A,R4" ;

! MOV A,R5
: $(opcode-ED) ( -- str )
    "MOV A,R5" ;

! MOV A,R6
: $(opcode-EE) ( -- str )
    "MOV A,R6" ;

! MOV A,R7
: $(opcode-EF) ( -- str )
    "MOV A,R7" ;

! MOVX @DPTR,A
: $(opcode-F0) ( -- str )
    "MOVX @DPTR,A" ;

: $(opcode-F1) ( -- str )
    $(opcode-D1) ;

! MOVX @R0,A
: $(opcode-F2) ( -- str )
    "MOVX @R0,A" ;

! MOVX @R1,A
: $(opcode-F3) ( -- str )
    "MOVX @R1,A" ;

! CPL A
: $(opcode-F4) ( -- str )
    "CPL A" ;

! MOV direct,A
: $(opcode-F5) ( -- str )
    "MOV ,A" ;

! MOV @R0,A
: $(opcode-F6) ( -- str )
    "MOV @R0,A" ;

! MOV @R1,A
: $(opcode-F7) ( -- str )
    "MOV @R1,A" ;

! MOV R0,A
: $(opcode-F8) ( -- str )
    "MOV @R0,A" ;

! MOV R1,A
: $(opcode-F9) ( -- str )
    "MOV R1,A" ;

! MOV R2,A
: $(opcode-FA) ( -- str )
    "MOV R2,A" ;

! MOV R3,A
: $(opcode-FB) ( -- str )
    "MOV R3,A" ;

! MOV R4,A
: $(opcode-FC) ( -- str )
    "MOV R4,A" ;

! MOV R5,A
: $(opcode-FD) ( -- str )
    "MOV R5,A" ;

! MOV R6,A
: $(opcode-FE) ( -- str )
    "MOV R6,A" ;

! MOV R7,A
: $(opcode-FF) ( -- str )
    "MOV R7,A" ;


