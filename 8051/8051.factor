! Copyright (C) 2013 Joseph Moschini.
! See http://factorcode.org/license.txt for BSD license.
!

USING:
    accessors kernel intel.8051.emulator intel.8051.emulator.psw intel.8051.disassemble
    intel.hex sequences tools.continuations
    math.parser unicode.case words quotations io
    math.bitwise math math.order
;

IN: intel.8051


! rom dump number of bytes
: hexdump-rom ( n address cpu -- str )
    [
        16 bits
        [ dup 16 < ] dip
        [ swap [ + ] [ swap drop 16 + ] if ] keep
        [ 16 bits ] dip
        [ min ] [ max ] 2bi
        2dup
    ] dip 
    rom>> subseq [ drop ] dip
    [ >hex 4 CHAR: 0 pad-head >upper " " append ] dip
    [ >hex 2 CHAR: 0 pad-head >upper " " append ] { } map-as concat append

    ;



! build string from 8 bit data
! HH BBBBBBBB DDD
: string-data ( d -- str )
    8 bits 
    [ >hex 2 CHAR: 0 pad-head >upper " " append ] keep
    [ >bin 8 CHAR: 0 pad-head append " " append ] keep
    number>string 3 32 pad-head append ;

! build string of register A
! A HH BBBBBBBB DDD
: string-a-reg ( cpu -- s )
    [ "A " ] dip
    A> string-data append ; 

! build string of Register B
! B HH BBBBBBBB DDD
: string-b-reg ( cpu -- s )
    [ "B " ] dip
    B> string-data append ;

! lets string a and b together
! A HH BBBBBBBB DDD B HH BBBBBBBB DDD
: string-ab-reg ( cpu -- s )
    [ string-a-reg ] keep [ " "  append ] dip string-b-reg append ;

! build a string for PSW
: string-psw-reg ( cpu -- s )
    [ "PSW " ] dip
    [ PSW> ] keep [ >hex 2 CHAR: 0 pad-head >upper append " " append ] dip
    [ PSW> ] keep [ >bin 8 CHAR: 0 pad-head append " " append ] dip
    [ psw>> psw-cy? [ "CY " ] [ "-- " ] if append ] keep
    [ psw>> psw-ac? [ "AC " ] [ "-- " ] if append ] keep
    [ psw>> psw-f0? [ "F0 " ] [ "-- " ] if append ] keep
    [ psw>> psw-br1? [ "B1 " ] [ "-- " ] if append ] keep
    [ psw>> psw-br0? [ "B0 " ] [ "-- " ] if append ] keep
    [ psw>> psw-ov? [ "OV " ] [ "-- " ] if append ] keep
    [ psw>> psw-f1? [ "F1 " ] [ "-- " ] if append ] keep
    [ psw>> psw-p? [ "P " ] [ "- " ] if append ] keep
    [ "BANK " append ] dip
    [ psw>> psw-bank-read number>string 3 32 pad-head append ] keep
    drop ;

! make string R0
: string-sp-reg ( cpu -- str )
    [ "SP " ] dip 
    SP> string-data append ;

! create a string for PC
: string-pc-reg ( cpu -- s )
    [ "PC " ] dip
    [ rom-pc-nbytes ] keep [ pc>> ] keep [ hexdump-rom ] keep [ append ] dip
    [ string-pc-opcode ] keep [ append ] dip
    drop ;



! make string R0
: string-r0-reg ( cpu -- str )
    [ "R0 " ] dip 
    R0> string-data append ;

! make string @R0
: string-@r0-reg ( cpu -- str )
    [ "@R0 " ] dip 
    @R0> string-data append ;

! lets string R0 and @R0 together
: string-r0-all ( cpu -- str )
    [ string-r0-reg ] keep [ " " append ] dip
    string-@r0-reg append ;

! make string R1
: string-r1-reg ( cpu -- str )
    [ "R1 " ] dip 
    R1> string-data append ;

! make string @R1
: string-@r1-reg ( cpu -- str )
    [ "@R1 " ] dip 
    @R1> string-data append ;

! lets string R0 and @R0 together
: string-r1-all ( cpu -- str )
    [ string-r1-reg ] keep [ " " append ] dip
    string-@r1-reg append ;

! make string R2
: string-r2-reg ( cpu -- str )
    [ "R2 " ] dip 
    R2> string-data append ;

! make string R3
: string-r3-reg ( cpu -- str )
    [ "R3 " ] dip 
    R3> string-data append ;

! make string R4
: string-r4-reg ( cpu -- str )
    [ "R4 " ] dip 
    R4> string-data append ;

! make string R5
: string-r5-reg ( cpu -- str )
    [ "R5 " ] dip 
    R5> string-data append ;

! make string R6
: string-r6-reg ( cpu -- str )
    [ "R6 " ] dip 
    R6> string-data append ;

! make string R7
: string-r7-reg ( cpu -- str )
    [ "R7 " ] dip 
    R7> string-data append ;

! print registers
: print-registers ( cpu -- )
    [ string-ab-reg print ] keep
    [ string-psw-reg print ] keep
    [ string-sp-reg print ] keep
    [ string-pc-reg print ] keep
    [ string-r0-all print ] keep
    [ string-r1-all print ] keep
    [ string-r2-reg print ] keep
    [ string-r3-reg print ] keep
    [ string-r4-reg print ] keep
    [ string-r5-reg print ] keep
    [ string-r6-reg print ] keep
    [ string-r7-reg print ] keep
    drop ;

! single step execute one instruction then displays all registers
: single-step ( cpu -- )
    [ execute-pc-opcode ] keep
    print-registers ;

: run-to ( a cpu -- )
    [
        2dup [ pc>> ] keep [ = ] dip drop
    ]
    [
        [ execute-pc-opcode ] keep
    ] until 2drop ;


