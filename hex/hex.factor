! Copyright (C) 2013 Joseph Moschini.
! See http://factorcode.org/license.txt for BSD license.
!

USING: accessors grouping io.encodings.utf8 io.files kernel math math.parser
       sequences tools.continuations ;

IN: intel.hex

CONSTANT: IHEX_MAX_DATA_LEN 512

TUPLE: ihex offset extend data len type checksum ;


: <ihex> ( -- ihex )
    ihex new ;

! # extract the length of the line
: ihex-len ( str -- len )
    2 cut drop hex>
    ;

: ihex-read ( path -- ? )
    utf8 file-lines
    [
        dup length 0 >
        [
            [ CHAR: : = ] trim-head
            dup length 0 >
            [
                break
                2 group
                <ihex>   ! create one tuple
                [ swap pop ]
                swap 4 cut swap rot swap hex> >>offset
                swap 2 cut swap rot swap hex> >>type
                swap 2 group
            ] when
        ] when
    ] each
    
    ;