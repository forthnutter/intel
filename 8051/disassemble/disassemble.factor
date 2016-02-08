! Copyright (C) 2013 Joseph Moschini.
! See http://factorcode.org/license.txt for BSD license.
!

USING: accessors kernel sequences unicode.case tools.continuations
       math math.bitwise math.parser assocs namespaces hashtables
       intel.8051.emulator byte-arrays ;


IN: intel.8051.disassemble


TUPLE: mnemonic code ;

! symbols to hold names
SYMBOL: address-names
SYMBOL: port-names
SYMBOL: port-bit-names

! 8051 bit memory returns address of bit memory
: bit-address ( n -- a )
    dup 0x7f >
    [ 6 3 bit-range 3 shift ]
    [ 6 3 bit-range 0x20 + ] if ;

! 8051 bit number
: bit-number ( n -- b )
    2 0 bit-range ;

! turn a two element array into a word
: >word< ( byte-array -- word )
  >byte-array ! make sure its abyte array
  0 swap
  [ [ 8 shift ] dip bitor ] each ;

! Label hash special function register
: bit-sfr ( b -- value/f ? )
    H{
        { 0x80 "P0.0" } { 0x81 "P0.1" } { 0x82 "P0.2" } { 0x83 "P0.3" }
        { 0x84 "P0.4" } { 0x85 "P0.5" } { 0x86 "P0.6" } { 0x87 "P0.7" }
        { 0x88 "TCON.IT0" } { 0x89 "TCON.IE0" } { 0x8A "TCON.IT1" } { 0x8B "TCON.IE1" }
        { 0x8C "TCON.TR0" } { 0x8D "TCON.TF0" } { 0x8E "TCON.TR1" } { 0x8F "TCON.TF1" }
        { 0x90 "P1.0" } { 0x91 "P1.1" } { 0x92 "P1.2" } { 0x93 "P1.3" }
        { 0x94 "P1.4" } { 0x95 "P1.5" } { 0x96 "P1.6" } { 0x97 "P1.7" }
        { 0x98 "SCON.RI" } { 0x99 "SCON.TI" } { 0x9A "SCON.RB8" } { 0x9B "SCON.TB8" }
        { 0x9C "SCON.REN" } { 0x9D "SCON.SM2" } { 0x9E "SCON.SM1" } { 0x9F "SCON.SM0" }
        { 0xA0 "P2.0" } { 0xA1 "P2.1" } { 0xA2 "P2.2" } { 0xA3 "P2.3" }
        { 0xA4 "P2.4" } { 0xA5 "P2.5" } { 0xA6 "P2.6" } { 0xA7 "P2.7" }
        { 0xA8 "IE.EX0" } { 0xA9 "IE.ET0" } { 0xAA "IE.EX1" } { 0xAB "IE.ET1" }
        { 0xAC "IE.ES" } { 0xAD "IE.ET2" } { 0xAE "IE.EC" } { 0xAF "IE.EA" }
        { 0xB0 "P3.0" } { 0xB1 "P3.1" } { 0xB2 "P3.2" } { 0xB3 "P3.3" }
        { 0xB4 "P3.4" } { 0xB5 "P3.5" } { 0xB6 "P3.6" } { 0xB7 "P3.7" }
        { 0xB8 "IP.PX0" } { 0xB9 "IP.PT0" } { 0xBA "IP.PX1" } { 0xBB "IP.PT1" }
        { 0xBC "IP.PS" } { 0xBD "IP.PT2" }
        { 0xC8 "T2CON.CP" } { 0xC9 "T2CON.C" } { 0xCA "T2CON.TR2" }
        { 0xCB "T2CON.EXEN2" } { 0xCC "T2CON.TLCK" }
        { 0xCD "T2CON.RCLK" } { 0xCE "T2CON.EXF2" }
        { 0xCF "T2CON.TF2" }
        { 0xD0 "PSW.P" } { 0xD2 "PSW.OV" } { 0xD3 "PSW.RS0" }
        { 0xD4 "PSW.RS1" } { 0xD5 "PSW.F0" } { 0xD6 "PSW.AC" }
        { 0xD7 "PSW.CY" } { 0xE0 "ACC" }
        { 0xE0 "ACC.0" } { 0xE1 "ACC.1" } { 0xE2 "ACC.2" } { 0xE3 "ACC.3" }
        { 0xE4 "ACC.4" } { 0xE5 "ACC.5" } { 0xE6 "ACC.6" } { 0xE7 "ACC.7" }
        { 0xF0 "B.0" } { 0xF1 "B.1" } { 0xF2 "B.2" } { 0xF3 "B.3" }
        { 0xF4 "B.4" } { 0xF5 "B.5" } { 0xF6 "B.6" } { 0xF7 "B.7" }
    } at* ;

! Label hash special function register via direct instruction
: direct-sfr ( b -- value/f ? )
    H{
      { 0x80 "P0" } { 0x81 "SP" } { 0x82 "DPL" } { 0x83 "DPH" }
      { 0x87 "PCON" }
      { 0x88 "TCON" } { 0x89 "TMOD" } { 0x8A "TL0" } { 0x8B "TL1" }
      { 0x8C "TH0" } { 0x8D "TH1" }
      { 0x8E "AUXR" }
      { 0x90 "P1" }
      { 0x98 "SCON" } { 0x99 "SBUF" }
      { 0xA0 "P2" }
      { 0xA2 "AUXR1" }
      { 0xA8 "IE" }
      { 0xB0 "P3" }
      { 0xB7 "IPH" }
      { 0xB8 "IP" }
      { 0xC8 "T2CON" } { 0xCA "RCAP2L" }  { 0xCB "RCAP2H" }
      { 0xCC "TL2" } { 0xCD "TH2" }
      { 0xD0 "PSW" }
      { 0xD8 "CCON" }
      { 0xD9 "CMOD" }
      { 0xDA "CCAPM0" }
      { 0xDB "CCAPM1" }
      { 0xDC "CCAPM2" }
      { 0xDD "CCAPM3" }
      { 0xDE "CCAPM4" }
      { 0xE0 "ACC" }
      { 0xF0 "B" }
    } at* ;

! look up label with address to if we got something
: address-lookup ( address -- string ? )
  address-names get at* ;

: address-set ( value address -- )
  address-names get dup
  [ ?set-at drop ]
  [ ?set-at address-names set ] if ;

! look up label for por bit map
: bit-port-lookup ( port -- string ? )
  port-bit-names get at* ;

! Build a bit port names
: bit-port-set ( value port -- )
  port-bit-names get dup
  [ ?set-at drop ]
  [ ?set-at port-bit-names set ] if ;


! turn 8 bit number in 8 signed number
: byte>sign-string ( byte -- string )
  8 >signed number>string ;

! binary data to hex byte string
: byte>hex-string ( byte -- string )
  8 bits >hex 2 CHAR: 0 pad-head >upper ;

: word>hex-string ( word -- string )
  16 bits >hex 4 CHAR: 0 pad-head >upper ;

: relative-string ( byte -- string )
  [ byte>hex-string ] keep
  [ "; " append ] dip byte>sign-string append ;

! look up direct tables to get labels string
: direct-string ( byte -- string )
  [ direct-sfr ] keep swap
  [ drop ]
  [ [ drop ] dip byte>hex-string ] if ;

: bit-string ( byte -- string )
  [ bit-sfr ] keep swap
  [ drop ]
  [ [ drop ] dip [ bit-address byte>hex-string "." append ] keep
    2 0 bit-range number>string append
  ] if ;

: address-get ( address -- string )
  [ word>hex-string ] keep
  address-lookup
  [ " ; " swap append append ] [ drop ] if ;

: bit-port-comment ( port -- string )
  bit-port-lookup
  [ " ; " swap append ] [ drop " ; " ] if ;


! NOP Instruction
: $(opcode-00) ( array -- str )
    drop "NOP" ;

! AJMP
! Absolute Jump
: $(opcode-01) ( array -- str )
  [ first 7 5 bit-range 8 shift ] keep
  second bitor word>hex-string
  "AJMP" swap append ;

! LJMP
! Long Jump
: $(opcode-02) ( array -- str )
    1 swap 3 swap <slice> >word< address-get ! word>hex-string
    "LJMP " swap append ;

! RR A
! Rotate Accumulator Right
: $(opcode-03) ( array -- str )
    drop "RR A" ;

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
: $(opcode-12) ( array -- str )
  1 swap 3 swap <slice> >word< address-get
  "LCALL " swap append ;

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
: $(opcode-20) ( array -- str )
  [ second ] keep swap bit-string "," append swap
  third relative-string append
  "JB " swap append ;


! AJMP
! Absolute Jump
: $(opcode-21) ( cpu --  str )
  $(opcode-01) ;

! RET
! Return from subroutine pop PC off the stack
: $(opcode-22) ( cpu -- str )
    drop "RET" ;

! RL A
! Rotate Accumulator Left
: $(opcode-23) ( cpu -- str )
    drop "RL A" ;

! ADD A,#data
: $(opcode-24) ( cpu -- str )
    drop "ADD A" ;

! ADD A,dir
: $(opcode-25) ( cpu -- str )
    drop "ADD A" ;

! ADD A,@R0
: $(opcode-26) ( cpu -- str )
    drop "ADD A,@R0" ;

! ADD A,@R1
: $(opcode-27) ( cpu -- str )
    drop "ADD A,@R1" ;

! ADD A,R0
: $(opcode-28) ( cpu -- str )
    drop "ADD A,R0" ;

! ADD A,R1
: $(opcode-29) ( cpu -- str )
    drop "ADD A,R1" ;

! ADD A,R2
: $(opcode-2A) ( cpu -- str )
    drop "ADD A,R2" ;

! ADD A,R3
: $(opcode-2B) ( cpu -- str )
    drop "ADD A,R3" ;

! ADD A,R4
: $(opcode-2C) ( cpu -- str )
    drop "ADD A,R4" ;

! ADD A,R5
: $(opcode-2D) ( cpu -- str )
    drop "ADD A,R5" ;

! ADD A,R6
: $(opcode-2E) ( cpu -- str )
    drop "ADD A,R6" ;

! ADD A,R7
: $(opcode-2F) ( cpu -- str )
    drop "ADD A,R7" ;

! JNB bit,rel
! Jump relative if bit is clear
: $(opcode-30) ( array -- str )
  [ second ] keep swap
  [ bit-address byte>hex-string "." append ] keep
  2 0 bit-range number>string append "," append swap
  third relative-string append
  "JNB " swap append ;

! ACALL
: $(opcode-31) ( cpu -- str )
    $(opcode-11) ;

! RETI
: $(opcode-32) ( array -- str )
    drop "RETI" ;

! RLC A
: $(opcode-33) ( cpu -- str )
    drop "RLC A" ;

! ADDC A,#data
: $(opcode-34) ( cpu -- str )
    drop "ADDC A" ;

! ADDC A,dir
: $(opcode-35) ( cpu -- str )
    drop "ADDC A" ;

! ADDC A,@R0
: $(opcode-36) ( cpu -- str )
    drop "ADDC A,@R0" ;

! ADDC A,@R1
: $(opcode-37) ( cpu -- str )
    drop "ADDC A,@R1" ;

! ADDC A,R0
: $(opcode-38) ( cpu -- str )
    drop "ADDC A,R0" ;

! ADDC A,R1
: $(opcode-39) ( cpu -- str )
    drop "ADDC A,R1" ;

! ADDC A,R2
: $(opcode-3A) ( cpu -- str )
    drop "ADDC A,R2" ;

! ADDC A,R3
: $(opcode-3B) ( cpu -- str )
    drop "ADDC A,R3" ;

! ADDC A,R4
: $(opcode-3C) ( cpu -- str )
    drop "ADDC A,R4" ;

! ADDC A,R5
: $(opcode-3D) ( cpu -- str )
    drop "ADDC A,R5" ;

! ADDC A,R6
: $(opcode-3E) ( cpu -- str )
    drop "ADDC A,R6" ;

! ADDC A,R7
: $(opcode-3F) ( cpu -- str )
    drop "ADDC A,R7" ;

! JC rel
! Jump relative if carry is set
: $(opcode-40) ( -- str )
    "JC" ;

! AJUMP
! Absolute Jump
: $(opcode-41) ( cpu -- str )
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
: $(opcode-50) ( array -- str )
  [ second ] keep swap
  [ bit-address byte>hex-string "." append ] keep
  2 0 bit-range number>string append "," append swap
  third relative-string append
  "JNC " swap append ;

: $(opcode-51) ( cpu -- str )
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
: $(opcode-55) ( array -- str )
  drop "ANL A," ;

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
: $(opcode-60) ( array -- str )
  second relative-string "JZ " swap append ;

!
: $(opcode-61) ( cpu -- str )
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
: $(opcode-70) ( cpu -- str )
    drop "JNZ" ;

: $(opcode-71) ( cpu -- str )
    $(opcode-51) ;

! ORL C,bit
: $(opcode-72) ( cpu -- str )
    drop "ORL C," ;

! JMP @A+DPTR
: $(opcode-73) ( cpu -- str )
    drop "JMP @A+DPTR" ;

! MOV A,#data
: $(opcode-74) ( array -- str )
  second byte>hex-string
  "MOV A,#" swap append ;

! MOV direct,#data
: $(opcode-75) ( array -- str )
  [ second direct-string ] keep swap ",#" append
  [ third ] dip swap byte>hex-string append
  "MOV " swap append ;


! MOV @R0,#data
: $(opcode-76) ( array -- str )
    second byte>hex-string ",#" swap append
    "MOV @R0" swap append ;

! MOV @R1,#data
: $(opcode-77) ( cpu -- str )
    drop "MOV @R1," ;

! MOV R0,#data
: $(opcode-78) ( array -- str )
    second byte>hex-string ",#" swap append
    "MOV R0" swap append ;

! MOV R1,#data
: $(opcode-79) ( array -- str )
    second byte>hex-string ",#" swap append
    "MOV R1" swap append ;

! MOV R2,#data
: $(opcode-7A) ( cpu -- str )
    drop "MOV R2,#" ;

! MOV R3,#data
: $(opcode-7B) ( cpu -- str )
    drop "MOV R3,#" ;

! MOV R4,#data
: $(opcode-7C) ( cpu -- str )
    drop "MOV R4,#" ;

! MOV R5,#data
: $(opcode-7D) ( cpu -- str )
    drop "MOV R5,#" ;

! MOV R6,#data
: $(opcode-7E) ( array -- str )
  second byte>hex-string "MOV R6,#" swap append ;

! MOV R7,#data
: $(opcode-7F) ( array -- str )
  second byte>hex-string "MOV R7,#" swap append ;

! SJMP rel
: $(opcode-80) ( array -- str )
  second relative-string "SJUMP " swap append ;


: $(opcode-81) ( cpu -- str )
    $(opcode-61) ;

! ANL C,bit
: $(opcode-82) ( cpu -- str )
    drop "ANL C," ;

! MOVC A,@A+PC
: $(opcode-83) ( cpu -- str )
    drop "MOVC A,@A+PC" ;

! DIV AB
: $(opcode-84) ( cpu -- str )
    drop "DIV AB" ;

! MOV direct,direct
: $(opcode-85) ( array -- str )
  [ second byte>hex-string "," append "MOV " swap append ] keep
  third byte>hex-string append ;

! MOV direct,@R0
: $(opcode-86) ( cpu -- str )
    drop "MOV ,@R0" ;

! MOV direct,@R1
: $(opcode-87) ( cpu -- str )
    drop "MOV ,@R1" ;

! MOV direct,R0
: $(opcode-88) ( cpu -- str )
    drop "MOV ,R0" ;

! MOV direct,R1
: $(opcode-89) ( cpu -- str )
    drop "MOV ,R1" ;

! MOV direct,R2
: $(opcode-8A) ( cpu --  str )
    drop "MOV ,R2" ;

! MOV direct,R3
: $(opcode-8B) ( cpu -- str )
    drop "MOV ,R3" ;

! MOV direct,R4
: $(opcode-8C) ( cpu -- str )
    drop "MOV ,R4" ;

! MOV direct,R5
: $(opcode-8D) ( cpu -- str )
    drop "MOV ,R5" ;

! MOV direct,R6
: $(opcode-8E) ( cpu -- str )
    drop "MOV ,R6" ;

! MOV direct,R7
: $(opcode-8F) ( cpu -- str )
    drop "MOV ,R7" ;

! MOV DPTR,#data16
: $(opcode-90) ( array -- str )
  1 swap 3 swap <slice> >word< word>hex-string
  "MOV DPTR," swap append ;

: $(opcode-91) ( cpu -- str )
    $(opcode-71) ;

! MOV bit,C
: $(opcode-92) ( array -- str )
  second [ bit-string ",C" append "MOV " swap append ] keep bit-port-comment append ;

! MOVC A,@A+DPTR
: $(opcode-93) ( cpu -- str )
    drop "MOVC A,@A+DPTR" ;

! SUBB A,#data
: $(opcode-94) ( cpu -- str )
    drop "SUBB A,#" ;

! SUBB A,direct
: $(opcode-95) ( cpu -- str )
    drop "SUBB A," ;

! SUBB A,@R0
: $(opcode-96) ( cpu -- str )
    drop "SUBB A,@R0" ;

! SUBB A,@R1
: $(opcode-97) ( cpu -- str )
    drop "SUBB A,@R1" ;

! SUBB A,R0
: $(opcode-98) ( cpu -- str )
    drop "SUBB A,R0" ;

! SUBB A,R1
: $(opcode-99) ( cpu -- str )
    drop "SUBB A,R1" ;

! SUBB A,R2
: $(opcode-9A) ( cpu -- str )
    drop "SUBB A,R2" ;

! SUBB A,R3
: $(opcode-9B) ( cpu -- str )
    drop "SUBB A,R3" ;

! SUBB A,R4
: $(opcode-9C) ( cpu -- str )
    drop "SUBB A,R4" ;

! SUBB A,R5
: $(opcode-9D) ( cpu -- str )
    drop "SUBB A,R5" ;

! SUBB A,R6
: $(opcode-9E) ( cpu -- str )
    drop "SUBB A,R6" ;

! SUBB A,R7
: $(opcode-9F) ( cpu -- str )
    drop "SUBB A,R7" ;

! ORL C,/bit
: $(opcode-A0) ( -- str )
    "ORL C,/" ;

: $(opcode-A1) ( cpu -- str )
    $(opcode-81) ;


! MOV C,bit
: $(opcode-A2) ( array -- str )
  second [ bit-string "MOV C," swap append ] keep bit-port-comment append ;

! INC DPTR
: $(opcode-A3) ( array -- str )
  drop "INC DPTR" ;

! MUL AB
: $(opcode-A4) ( -- str )
    "MUL AB" ;

: $(opcode-A5) ( cpu -- str )
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

: $(opcode-B1) ( cpu -- str )
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
: $(opcode-B4) ( array -- str )
  [ second byte>hex-string "CJNE A,#" swap append ] keep
  third relative-string "," swap append append ;

! CJNE A,direct,rel
: $(opcode-B5) ( array -- str )
  [ second byte>hex-string "CJNE A," swap append ] keep
  third relative-string "," swap append append ;

! CJNE @R0,data,rel
: $(opcode-B6) ( -- str )
    "CJNE @R0,," ;

! CJNE @R1,data,rel
: $(opcode-B7) ( -- str )
    "CJNE @R1,," ;

! CJNE R0,#data,rel
: $(opcode-B8) ( array -- str )
  [ second byte>hex-string "CJNE R0,#" swap append ] keep
  third byte>hex-string "," swap append append ;

! CJNE R1,#data,rel
: $(opcode-B9) ( array -- str )
  [ second byte>hex-string "CJNE R1,#" swap append ] keep
  third byte>hex-string "," swap append append ;

! CJNE R2,#data,rel
: $(opcode-BA) ( array -- str )
  [ second byte>hex-string "CJNE R2,#" swap append ] keep
  third byte>hex-string "," swap append append ;

! CJNE R3,#data,rel
: $(opcode-BB) ( array -- str )
  [ second byte>hex-string "CJNE R3,#" swap append ] keep
  third byte>hex-string "," swap append append ;

! CJNE R4,#data,rel
: $(opcode-BC) ( array -- str )
  [ second byte>hex-string "CJNE R4,#" swap append ] keep
  third byte>hex-string "," swap append append ;

! CJNE R5,#data,rel
: $(opcode-BD) ( array -- str )
  [ second byte>hex-string "CJNE R5,#" swap append ] keep
  third byte>hex-string "," swap append append ;

! CJNE R6,#data,rel
: $(opcode-BE) ( array -- str )
  [ second byte>hex-string "CJNE R6,#" swap append ] keep
  third byte>hex-string "," swap append append ;

! CJNE R7,#data,rel
: $(opcode-BF) ( array -- str )
  [ second byte>hex-string "CJNE R7,#" swap append ] keep
  third byte>hex-string "," swap append append ;


! PUSH direct
: $(opcode-C0) ( array -- str )
  second direct-string "PUSH " swap append ;

: $(opcode-C1) ( array -- str )
    $(opcode-A1) ;


! CLR bit
: $(opcode-C2) ( array -- str )
  second [ bit-string "CLR " swap append ] keep bit-port-comment append ;

! CLR C
: $(opcode-C3) ( array -- str )
  drop "CLR C" ;

! SWAP A
: $(opcode-C4) ( array -- str )
  drop "SWAP A" ;

! XCH A,direct
: $(opcode-C5) ( array -- str )
  drop "XCH A," ;

! XCH A,@R0
: $(opcode-C6) ( array -- str )
  drop "XCH A,@R0" ;

! XCH A,@R1
: $(opcode-C7) ( array -- str )
  drop "XCH A,@R1" ;

! XCH A,R0
: $(opcode-C8) ( array -- str )
  drop "XCH A,R0" ;

! XCH A,R1
: $(opcode-C9) ( array -- str )
  drop "XCH A,R1" ;

! XCH A,R2
: $(opcode-CA) ( array -- str )
  drop "XCH A,R2" ;

! XCH A,R3
: $(opcode-CB) ( array -- str )
  drop "XCH A,R3" ;

! XCH A,R4
: $(opcode-CC) ( array -- str )
  drop "XCH A,R4" ;

! XCH A,R5
: $(opcode-CD) ( array -- str )
  drop "XCH A,R5" ;

! XCH A,R6
: $(opcode-CE) ( array -- str )
  drop "XCH A,R6" ;

! XCH A,R7
: $(opcode-CF) ( array -- str )
  drop "XCH A,R7" ;

! POP direct
: $(opcode-D0) ( array -- str )
  second direct-string "POP " swap append ;

: $(opcode-D1) ( array -- str )
    $(opcode-B1) ;

! SETB bit
: $(opcode-D2) ( array -- str )
  second [ bit-string "SETB " swap append ] keep bit-port-comment append ;

! SETB C
: $(opcode-D3) ( cpu -- str )
    drop "SETB C" ;

! DA A
: $(opcode-D4) ( cpu -- str )
    drop "DA A" ;

! DJNZ direct,rel
: $(opcode-D5) ( array -- str )
  [ second byte>hex-string "," append ] keep
  third byte>hex-string append
  "DJNZ " swap append ;

! XCHD A,@R0
: $(opcode-D6) ( cpu -- str )
    drop "XCHD A,@R0" ;

! XCHD A,@R1
: $(opcode-D7) ( cpu -- str )
    drop "XCHD A,@R1" ;

! DJNZ R0,rel
: $(opcode-D8) ( array -- str )
  second relative-string "DJNZ R0," swap append ;

! DJNZ R1,rel
: $(opcode-D9) ( array -- str )
!  second byte>hex-string "DJNZ R1," swap append ;
  second relative-string "DJNZ R1," swap append ;

! DJNZ R2,rel
: $(opcode-DA) ( array -- str )
  second relative-string "DJNZ R2," swap append ;

! DJNZ R3,rel
: $(opcode-DB) ( array -- str )
  second relative-string "DJNZ R3," swap append ;

! DJNZ R4,rel
: $(opcode-DC) ( array -- str )
  second relative-string "DJNZ R4," swap append ;

! DJNZ R5,rel
: $(opcode-DD) ( array -- str )
  second relative-string "DJNZ R5," swap append ;

! DJNZ R6,rel
: $(opcode-DE) ( array -- str )
  second relative-string "DJNZ R6," swap append ;

! DJNZ R7,rel
: $(opcode-DF) ( array -- str )
  second relative-string "DJNZ R7," swap append ;

! MOVX A,@DPTR
: $(opcode-E0) ( -- str )
    "MOVX A,@DPTR" ;

: $(opcode-E1) ( cpu -- str )
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
: $(opcode-E5) ( array -- str )
  second direct-string "MOV A," swap append ;

! MOV A,@R0
: $(opcode-E6) ( array -- str )
  drop "MOV A,@R0" ;


! MOV A,@R1
: $(opcode-E7) ( array -- str )
  drop "MOV A,@R1" ;

! MOV A,R0
: $(opcode-E8) ( array -- str )
  drop "MOV A,R0" ;

! MOV A,R1
: $(opcode-E9) ( array -- str )
  drop "MOV A,R1" ;

! MOV A,R2
: $(opcode-EA) ( array -- str )
  drop "MOV A,R2" ;

! MOV A,R3
: $(opcode-EB) ( array -- str )
  drop "MOV A,R3" ;

! MOV A,R4
: $(opcode-EC) ( array -- str )
  drop "MOV A,R4" ;

! MOV A,R5
: $(opcode-ED) ( array -- str )
  drop "MOV A,R5" ;

! MOV A,R6
: $(opcode-EE) ( array -- str )
  drop "MOV A,R6" ;

! MOV A,R7
: $(opcode-EF) ( array -- str )
  drop "MOV A,R7" ;

! MOVX @DPTR,A
: $(opcode-F0) ( array -- str )
  drop "MOVX @DPTR,A" ;

: $(opcode-F1) ( array -- str )
    $(opcode-D1) ;

! MOVX @R0,A
: $(opcode-F2) ( array -- str )
  drop "MOVX @R0,A" ;

! MOVX @R1,A
: $(opcode-F3) ( array -- str )
  drop "MOVX @R1,A" ;

! CPL A
: $(opcode-F4) ( array -- str )
  drop "CPL A" ;

! MOV direct,A
: $(opcode-F5) ( array -- str )
  second byte>hex-string "MOV " swap append ",A" append ;

! MOV @R0,A
: $(opcode-F6) ( array -- str )
  drop "MOV @R0,A" ;

! MOV @R1,A
: $(opcode-F7) ( array -- str )
  drop "MOV @R1,A" ;

! MOV R0,A
: $(opcode-F8) ( array -- str )
  drop "MOV R0,A" ;

! MOV R1,A
: $(opcode-F9) ( array -- str )
  drop "MOV R1,A" ;

! MOV R2,A
: $(opcode-FA) ( array -- str )
  drop "MOV R2,A" ;

! MOV R3,A
: $(opcode-FB) ( array -- str )
  drop "MOV R3,A" ;

! MOV R4,A
: $(opcode-FC) ( array -- str )
  drop "MOV R4,A" ;

! MOV R5,A
: $(opcode-FD) ( array -- str )
  drop "MOV R5,A" ;

! MOV R6,A
: $(opcode-FE) ( array -- str )
  drop "MOV R6,A" ;

! MOV R7,A
: $(opcode-FF) ( array -- str )
  drop "MOV R7,A" ;
