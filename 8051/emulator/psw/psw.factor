! ! Copyright (C) 2013 Joseph Moschini.
! See http://factorcode.org/license.txt for BSD license.
!

USING: accessors arrays io io.encodings.binary io.files
       kernel lexer math math.bitwise models namespaces sequences
       tools.continuations ;
   
IN: intel.8051.emulator.psw


TUPLE: psw < model ;


! Create a PSW
: <psw> ( value -- psw )
    psw new-model ;


: psw-cy-set ( psw -- )
    dup psw?
    [
       [ value>> 0b10000000 bitor ] keep set-model
    ]
    [ drop ] if ;


: psw-cy-clr ( psw -- )
    dup psw?
    [
        [ value>> 0b10000000 bitnot bitand ] keep set-model
    ]
    [ drop ] if ;

: psw-ac-set ( psw -- )
    dup psw?
    [
        [ value>> 0b01000000 bitor ] keep set-model
    ]
    [ drop ] if ;

: psw-ac-clr ( psw -- )
    dup psw?
    [
        [ value>> 0b01000000 bitnot bitand ] keep set-model
    ]
    [ drop ] if ;


: psw-f0-set ( psw -- )
    dup psw?
    [
        [ value>> 0b00100000 bitor ] keep set-model
    ]
    [ drop ] if ;

: psw-f0-clr ( psw -- )
    dup psw?
    [
        [ value>> 0b00100000 bitnot bitand ] keep set-model
    ]
    [ drop ] if ;

: psw-r1-set ( psw -- )
    dup psw?
    [
        [ value>> 0b00100000 bitor ] keep set-model
    ]
    [ drop ] if ;

: psw-r1-clr ( psw -- )
    dup psw?
    [
        [ value>> 0b00100000 bitnot bitand ] keep set-model
    ]
    [ drop ] if ;

: psw-r0-set ( psw -- )
    dup psw?
    [
        [ value>> 0b00010000 bitor ] keep set-model
    ]
    [ drop ] if ;

: psw-r0-clr ( psw -- )
    dup psw?
    [
        [ value>> 0b00010000 bitnot bitand ] keep set-model
    ]
    [ drop ] if ;

: psw-bank0 ( psw -- )
    dup psw?
    [
        [ value>> 0b00110000 bitnot bitand ] keep set-model
    ]
    [ drop ] if ;

: psw-bank1 ( psw -- )
    dup psw?
    [
        [ value>> 0b00010000 bitor 0b00100000 bitnot bitand ] keep set-model
    ]
    [ drop ] if ;

: psw-bank2 ( psw -- )
    dup psw?
    [
        [ value>> 0b00100000 bitor 0b00010000 bitnot bitand ] keep set-model
    ]
    [ drop ] if ;

: psw-bank3 ( psw -- )
    dup psw?
    [
        [ vale>> 0b00110000 bitor ] keep set-model
    ]
    [ drop ] if ;


