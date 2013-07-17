! Copyright (C) 2013 Joseph Moschini.
! See http://factorcode.org/license.txt for BSD license.
!

USING: accessors arrays kernel math models sequences tools.continuations ;

IN: intel.8051.emulator.memory

TUPLE: cell < model ;

: <cell> ( n -- cell )
    cell new-model
    ;


TUPLE: ram array ;

: <ram> ( -- ram )
    ram new
    128 0 <array> [ <cell> ] map
    >>array ;


: ram-read ( address ram -- n )
    array>> ?nth dup
    [
        dup cell?
        [
            value>>
        ]
        [ drop ] if
    ] when ;

: ram-write ( n address ram -- )
    ;

        