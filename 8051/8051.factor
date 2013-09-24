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
    [ pc>> ] keep [ opcodes>> nth [ break ] prepose ] keep swap call( cpu -- ) ;


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
