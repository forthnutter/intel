! Copyright (C) 2013 Joseph Moschini.
! See http://factorcode.org/license.txt for BSD license.
!

USING: accessors grouping io.encodings.utf8 io.files kernel math math.parser
       sequences tools.continuations ;

IN: intel.hex

CONSTANT: IHEX_MAX_DATA_LEN 512

TUPLE: ihex len offset type data extend checksum ;


: <ihex> ( -- ihex )
    ihex new ;

: ihex-data ( str -- array )
    2 group
    [ hex> ] B{ } map-as 
    ;


: ihex-read ( path -- vector )
    V{ } clone swap
    utf8 file-lines
    [
        dup length 0 >
        [
            [ CHAR: : = ] trim-head
            dup length 0 >
            [
                <ihex> ! create one tuple
                [ 2 cut swap hex> ] dip swap >>len
                [ 4 cut swap hex> ] dip swap >>offset
                [ 2 cut swap hex> ] dip swap >>type
                [ len>> 2 * cut hex> ] keep swap >>checksum
                [ ihex-data ] dip swap >>data
            ] when
        ] when
        break
        [ ihex? ] keep swap
        [ suffix ] when
    ] each
    ;
