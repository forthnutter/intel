! Copyright (C) 2013 Joseph Moschini.
! See http://factorcode.org/license.txt for BSD license.
!

USING: accessors arrays kernel math math.bitwise models sequences tools.continuations ;

IN: intel.8051.emulator.memory

CONSTANT: RAM_B 0xF0
CONSTANT: RAM_A 0xE0
CONSTANT: RAM_DPH 0x83
CONSTANT: RAM_DPL 0x82

TUPLE: cell < model ;

: <cell> ( n -- cell )
    cell new-model
    ;

GENERIC: read ( object -- n )
GENERIC: write ( n object -- )

M: cell read value>> ;

M: cell write set-model ;

TUPLE: memory ram sfr ext ;

! create a memory tuple
: <memory> ( -- memory )
    memory new
    256 0 <array> [ <cell> ] map
    >>ram
    128 0 <array> [ <cell> ] map
    >>sfr
    0x10000 0 <array> [ <cell> ] map
    >>ext ;


! return ram cell
: ram-cell ( a memory -- cell/? )
    ram>> ?nth ;



! read value from cell
: ram-cellvalue ( cell -- value/? )
    dup cell? [ value>> ] [ drop f ] if ;

! return the cell or address of bit
: ram-bitcell ( ba memory -- cell )
    swap dup 0x7f >
    [ 7 3 bit-range swap ram-cell ] [ 7 3 bit-range 0x20 + swap ram-cell ] if
;

    
: ram-bitstatus ( ba memory -- ? )
    [ ram-bitcell read ] 2keep  ! ram-cellvalue ] 2keep
    drop 2 0 bit-range bit? ;

: ram-bitclr ( ba memory -- )
    2dup ram-bitcell swap drop [ ram-cellvalue ] keep
    [ swap 2 0 bit-range clear-bit ] dip set-model ;
    
: ram-bitset ( ba memory -- )
    2dup ram-bitcell swap drop [ ram-cellvalue ] keep
    [ swap 2 0 bit-range set-bit ] dip set-model ;
    
: >ram-bit ( ? ba memory -- )
    rot [ ram-bitset ] [ ram-bitclr ] if ;

! for general testing ram fill
: ram-fill ( b memory -- )
    ram>> swap [ swap set-model ] curry each ;

: sfr-cell ( a memory -- cell/? )
   sfr>> ?nth ;

: sfr-write ( b a memory -- )
    sfr-cell dup
    [ dup cell? [ set-model ] [ drop drop ] if ]
    [ drop drop ] if
    ;

: sfr-read ( address memory -- n )
    sfr-cell dup
    [ dup cell? [ value>> ] [ ] if ]
    [ drop 0 ]
    if ;



: ram-indirect-read ( address memory -- n )
    ram-cell dup
    [ dup cell? [ value>> ] [ ] if ]
    [ drop 0 ]
    if ;

: ram-direct-cell ( address memory -- cell/? )
    [ dup 0x80 < ] dip swap
    [ ram-cell ] [ [ 0x80 - ] dip sfr-cell ] if ; 
    
    
: ram-direct-read ( address memory -- n )
    ram-direct-cell
    dup cell?
    [ value>> ] [ drop 0 ] if ;


: ram-indirect-write ( n address memory -- )
    ram-cell dup
    [ dup cell? [ set-model ] [ drop drop ] if ]
    [ drop drop ] if
    ;


: ram-direct-write ( n address memory -- )
    ram-direct-cell
    dup cell?
    [ set-model ] [ drop drop ] if ;

: ext-cell ( address memory -- cell )
    ext>> ?nth ;

! External memory
: ext-read ( address memory -- n )
    ext-cell read ;  ! ext-cell-read ;

! external memory write
: ext-write ( n address memory -- )
    ext-cell write ;




    