! Copyright (C) 2013 Joseph Moschini.
! See http://factorcode.org/license.txt for BSD license.
!

USING: accessors arrays kernel math math.bitwise models sequences tools.continuations ;

IN: intel.8051.emulator.memory


CONSTANT: RAM_A 0xE0
CONSTANT: RAM_DPH 0x83
CONSTANT: RAM_DPL 0x82

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

! return ram cell
: ram-cell ( a ram -- cell/? )
    array>> ?nth ;



! read value from cell
: ram-cellvalue ( cell -- value/? )
    dup cell? [ value>> ] [ drop f ] if ;

! return the cell or address of bit
: ram-bitcell ( ba ram -- cell )
    swap dup 0x7f >
    [ 7 3 bit-range swap ram-cell ] [ 7 3 bit-range 0x20 + swap ram-cell ] if
;

    
: ram-bitstatus ( ba ram -- ? )
    [ ram-bitcell ram-cellvalue ] 2keep
    drop 2 0 bit-range bit? ;

: ram-bitclear ( ba ram -- )
    2dup ram-bitcell swap drop [ ram-cellvalue ] keep
    [ swap 2 0 bit-range clear-bit ] dip set-model
    ;

! for general testing ram fill
: ram-fill ( b ram -- )
    array>>
    swap [ swap set-model ] curry each
   
    ;

: sfr-cell ( a ram -- cell/? )
   sfr>> ?nth ;

: sfr-write ( b a ram -- )
    sfr-cell dup
    [ dup cell? [ set-model ] [ drop drop ] if ]
    [ drop drop ] if
    ;

: sfr-read ( address ram -- n )
    sfr-cell dup
    [ dup cell? [ value>> ] [ ] if ]
    [ drop 0 ]
    if ;



: ram-indirect-read ( address ram -- n )
    ram-cell dup
    [ dup cell? [ value>> ] [ ] if ]
    [ drop 0 ]
    if ;

: ram-direct-cell ( address ram -- cell/? )
    [ dup 0x80 < ] dip swap
    [ ram-cell ] [ [ 0x80 - ] dip sfr-cell ] if ; 
    
    
: ram-direct-read ( address ram -- n )
    ram-direct-cell
    dup cell?
    [ value>> ] [ drop 0 ] if ;


: ram-indirect-write ( n address ram -- )
    ram-cell dup
    [ dup cell? [ set-model ] [ drop drop ] if ]
    [ drop drop ] if
    ;


: ram-direct-write ( n address ram -- )
    ram-direct-cell
    dup cell?
    [ set-model ] [ drop drop ] if ;
    
 