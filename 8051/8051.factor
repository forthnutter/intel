! Copyright (C) 2013 Joseph Moschini.
! See http://factorcode.org/license.txt for BSD license.
!

USING:
    accessors kernel intel.8051.emulator intel.8051.emulator.psw 
    intel.hex sequences tools.continuations math.parser unicode.case words quotations io
;

IN: intel.8051


! execute one instruction
: execute-opcode ( cpu -- )
    [ rom-pcread ] keep [ opcodes>> nth [ break ] prepose ] keep swap call( cpu -- ) ;

! build string of register A
! A HH BBBBBBBB DDD
: string-a-reg ( cpu -- s )
    [ "A " ] dip
    [ A> ] keep [ >hex 2 CHAR: 0 pad-head append " " append ] dip
    [ A> ] keep [ >bin 8 CHAR: 0 pad-head append " " append ] dip
    A> number>string 3 32 pad-head append ; 

! build string of Register B
! B HH BBBBBBBB DDD
: string-b-reg ( cpu -- s )
    [ "B " ] dip
    [ B> ] keep [ >hex 2 CHAR: 0 pad-head append " " append ] dip
    [ B> ] keep [ >bin 8 CHAR: 0 pad-head append " " append ] dip
    B> number>string 3 32 pad-head append ;

! lets string a and b together
! A HH BBBBBBBB DDD B HH BBBBBBBB DDD
: string-ab-reg ( cpu -- s )
    [ string-a-reg ] keep [ " "  append ] dip string-b-reg append ;

! build a string for PSW
: string-psw-reg ( cpu -- s )
    [ "PSW " ] dip
    [ PSW> ] keep [ >hex 2 CHAR: 0 pad-head append " " append ] dip
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


! print registers
: print-registers ( cpu -- )
    [ string-ab-reg ] keep [ print ] dip
    [ string-psw-reg ] keep [ print ] dip
    drop ;

! single step execute one instruction then displays all registers
: single-step ( cpu -- )
    [ execute-opcode ] keep
    print-registers ;

! generate the opcode array here
: opcode-build ( cpu -- )
    opcodes>> dup
    [
        [ drop ] dip
        [
            >hex 2 CHAR: 0 pad-head >upper
            "(opcode-" swap append ")" append
            "intel.8051.emulator" lookup-word 1quotation
        ] keep
        [ swap ] dip swap [ set-nth ] keep
    ] each-index drop ;

: start-test ( -- cpu )
    "work/intel/hex/EZSHOT.HEX" <ihex> array>>
    <cpu> swap >>rom 
    [ opcode-build ] keep ;
