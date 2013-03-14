! Copyright (C) 2013 Joseph Moschini.
! See http://factorcode.org/license.txt for BSD license.
!

USING: accessors combinators grouping io.encodings.utf8
       io.files kernel math math.order math.parser sequences
       tools.continuations ;

IN: intel.hex

CONSTANT: IHEX_MAX_DATA_LEN 512

TUPLE: ihex error len offset type data extend checksum ;


: <ihex> ( -- ihex )
    ihex new ;

: ihex-data ( str -- array )
    2 group
    [ hex> ] B{ } map-as 
    ;

! Calculate the checksum in the ihex tuple
: ihex-checksum ( ihex -- b )
    [ len>> ] keep
    [ type>> + ] keep
    [ offset>> 255 bitand + ] keep
    [ offset>> -8 shift 255 bitand + ] keep
    [ data>> [ + ] each ] keep
    drop
    neg 255 bitand
;

! Get Checksum and see if it matches
: ihex-checksum? ( ihex -- ? )
    [ ihex-checksum ] keep
    checksum>> = ;

! get end address
: ihex-endaddress ( ihex -- address )
    [ len>> ] keep [ offset>> + ] keep drop
    ;

! find the address max
: ihex-max ( ihexv -- max )
    0 swap
    [
        [ ihex? ] keep swap   ! make sure have the correct tupple
        [
            [ type>> ] keep swap
            {
                { 0 [ ihex-endaddress max ] }
                { 1 [ break drop ] }
                { 2 [ drop ] }
                { 3 [ drop ] }
            } case
        ] [ drop ] if
    ] each
    ;

! Now turn the array ihex tuples into a binary array
: ihex-binary ( ihexv -- barray )
    ;

! read in the hex line make an array ihex tuples
: ihex-read ( path -- ihexv )
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
        [ ihex? ] keep swap   ! make sure have the correct tupple
        [
            dup ihex-checksum? not >>error
            suffix
        ]
        [ drop ] if
    ] each
    ;
