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
