! ! Copyright (C) 2013 Joseph Moschini.
! See http://factorcode.org/license.txt for BSD license.
!

USING: accessors arrays io io.encodings.binary io.files
       kernel lexer math math.bitwise models namespaces sequences
       syntax tools.continuations ;
   
IN: intel.8051.emulator.psw

! 7   6   5   4   3   2   1   0
! CY  AC  F0 RS1 RS0  OV  F1  P




TUPLE: psw < model ;


! Create a PSW
: <psw> ( value -- psw )
    psw new-model ;


: psw-cy-set ( psw -- )
    dup psw?
    [
       [ value>> 7 set-bit ] keep set-model
    ]
    [ drop ] if ;


: psw-cy-clr ( psw -- )
    dup psw?
    [
        [ value>> 7 clear-bit ] keep set-model
    ]
    [ drop ] if ;

: psw-cy? ( psw -- ? )
    dup psw?
    [ value>> 1 bit? ]
    [ drop f ] if ;

! push b into cy
: >psw-cy ( ? psw -- )
    swap [ psw-cy-set ] [ psw-cy-clr ] if ;


: psw-ac-set ( psw -- )
    dup psw?
    [
        [ value>> 6 set-bit ] keep set-model
    ]
    [ drop ] if ;

: psw-ac-clr ( psw -- )
    dup psw?
    [
        [ value>> 6 clear-bit ] keep set-model
    ]
    [ drop ] if ;

! push b into cy
: >psw-ac ( ? psw -- )
    swap [ psw-ac-set ] [ psw-ac-clr ] if ;


: psw-f0-set ( psw -- )
    dup psw?
    [
        [ value>> 5 set-bit ] keep set-model
    ]
    [ drop ] if ;

: psw-f0-clr ( psw -- )
    dup psw?
    [
        [ value>> 5 clear-bit ] keep set-model
    ]
    [ drop ] if ;

: psw-br0-set ( psw -- )
    dup psw?
    [
        [ value>> 3 set-bit ] keep set-model
    ]
    [ drop ] if ;

: psw-br0-clr ( psw -- )
    dup psw?
    [
        [ value>> 3 clear-bit ] keep set-model
    ]
    [ drop ] if ;

: psw-br1-set ( psw -- )
    dup psw?
    [
        [ value>> 4 set-bit ] keep set-model
    ]
    [ drop ] if ;

: psw-br1-clr ( psw -- )
    dup psw?
    [
        [ value>> 4 clear-bit ] keep set-model
    ]
    [ drop ] if ;

: psw-bank0-set ( psw -- )
    dup psw?
    [
        [ value>> 4 clear-bit 3 clear-bit ] keep set-model
    ]
    [ drop ] if ;

: psw-bank1-set ( psw -- )
    dup psw?
    [
        [ value>> 4 clear-bit 3 set-bit ] keep set-model
    ]
    [ drop ] if ;

: psw-bank2-set ( psw -- )
    dup psw?
    [
        [ value>> 4 set-bit 3 clear-bit ] keep set-model
    ]
    [ drop ] if ;

: psw-bank3-set ( psw -- )
    dup psw?
    [
        [ value>> 4 set-bit 3 set-bit ] keep set-model
    ]
    [ drop ] if ;


: psw-bank-read ( psw -- n )
    dup psw?
    [
        value>> 4 2 bit-range
    ]
    [ drop 0 ] if ;


! RRC instruction affects the  flags so we do it here
! Rotate Right thrugh carry
! ------------------
! |                |
! v                ^
! 7 6 5 4 3 2 1 0->C
: psw-rrc ( b psw -- b' )
    [ value>> 0x80 bitand ] keep
    -rot swap rot [ swap 0 bit? [ psw-cy-set ] [ psw-cy-clr ] if ] 2keep
    drop -1 shift bitor 7 0 bit-range
    ;


! ADD Affects the flags so we have two values that
! are added and returns result
! CF set by bit 7
! AC set by bit 3
! OV set by 6 not 7 or 7 not 6
: psw-add ( a b c psw -- r )
    [ 3dup + + 8 8 bit-range 1 = ] dip [ >psw-cy ] keep ! carry
    [ 3dup [ 3 bits ] dip [ swap 3 bits swap ] dip + + 4 4 bit-range 1 = ] dip
    [ >psw-ac ] keep 
     drop + + 8 bits ;
    