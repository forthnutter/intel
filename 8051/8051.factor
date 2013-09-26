! Copyright (C) 2013 Joseph Moschini.
! See http://factorcode.org/license.txt for BSD license.
!

USING:
    accessors kernel intel.8051.emulator intel.hex sequences tools.continuations
    math.parser unicode.case words quotations io
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


! single step execute one instruction then displays all registers
: single-step ( cpu -- )
    [ execute-opcode ] keep
    [ string-a-reg ] keep [ " "  append ] dip [ string-b-reg append ] keep [ print ] dip
    drop
;

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
