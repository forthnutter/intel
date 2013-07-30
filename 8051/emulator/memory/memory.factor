! Copyright (C) 2013 Joseph Moschini.
! See http://factorcode.org/license.txt for BSD license.
!

USING: accessors arrays kernel math math.bitwise models sequences tools.continuations ;

IN: intel.8051.emulator.memory

TUPLE: cell < model ;

: <cell> ( n -- cell )
    cell new-model
    ;


TUPLE: ram array sfr ;

: <ram> ( -- ram )
    ram new
    256 0 <array> [ <cell> ] map
    >>array
    128 0 <array> [ <cell> ] map
    >>sfr ;



: ram-read ( address ram -- n )
    array>> ?nth dup
    [ dup cell? [ value>> ] [ ] if ]
    [ drop 0 ]
    if ;

: ram-write ( n address ram -- )
    array>> ?nth dup
    [ dup cell? [ set-model ] [ drop drop ] if ]
    [ drop drop ] if
    ;


: ram-bitstatus ( ba ram -- ? )
    [ swap dup 0x7f >
     [ 7 3 bit-range swap ram-read ] [ 7 3 bit-range 0x20 + swap ram-read ] if
    ] 2keep
    drop 2 0 bit-range bit? ;

: ram-bitclear ( ba ram -- )
    [ swap dup 0x7f >
      [ 7 3 bit-range swap ram-read ] [ 7 3 bit-range 0x20 + swap ram-read ] if
    ] 2keep
    ;