! Copyright (C) 2013 Joseph Moschini.
! See http://factorcode.org/license.txt for BSD license.
!

USING: accessors byte-arrays combinators grouping io.encodings.utf8
       io.files kernel math math.order math.parser sequences
       tools.continuations ;

IN: intel.hex

CONSTANT: IHEX_MAX_DATA_LEN 512

TUPLE: ihex-line error len offset type data extend checksum ;

! make a place to store data
: <ihex-line> ( -- ihex-line )
    ihex-line new ;

: ihex-data ( str -- array )
    2 group
    [ hex> ] B{ } map-as 
    ;

! Calculate the checksum in the ihex tuple
: ihex-line-checksum ( ihex -- b )
    [ len>> ] keep
    [ type>> + ] keep
    [ offset>> 255 bitand + ] keep
    [ offset>> -8 shift 255 bitand + ] keep
    [ data>> [ + ] each ] keep
    drop
    neg 255 bitand
;



! Get Checksum and see if it matches
: ihex-line-checksum? ( ihex -- ? )
    [ ihex-line-checksum ] keep
    checksum>> = ;


! get end address
: ihex-line-endaddress ( ihex -- address )
    [ len>> ] keep [ offset>> + ] keep drop
    ;


! find the address max
: ihex-line-max ( vector -- max )
    0 swap
    [
        [ ihex-line? ] keep swap   ! make sure have the correct tupple
        [
            [ type>> ] keep swap
            {
                { 0 [ ihex-line-endaddress max ] } ! cal end address
                { 2 [ drop ] }
                { 3 [ drop ] }
                { 4 [ drop ] }
                { 5 [ drop ] }
                [ drop drop ]
            } case
        ] [ drop ] if
    ] each
    ;








TUPLE: ihex start path vector array ;

! Now turn the array ihex tuples into a binary array
: ihex-array ( ihex -- ihex )
    [ vector>> ihex-line-max ] keep swap ! find max memory
    <byte-array> >>array [ array>> ] keep
    [ vector>>
      [
          [ ihex-line? ] keep swap
          [
              [ type>> ] keep swap
              {
                  { 0 [ [ data>> ] keep offset>> rot [ copy ] keep ] }
                  { 1 [ drop ] }
                  { 2 [ drop ] }
                  { 3 [ drop ] }
                  { 4 [ drop ] }
                  { 5 [ drop ] }
              } case
          ] [ drop ] if
      ] each
      drop
    ] keep
    ;



! hex line make an array ihex tuples
: ihex-read ( ihex -- ihex )
    V{ } clone >>vector
    [ path>> utf8 file-lines ] keep swap
    [
        dup length 0 >
        [
            [ CHAR: : = ] trim-head
            dup length 0 >
            [
                <ihex-line> ! create one tuple
                [ 2 cut swap hex> ] dip swap >>len
                [ 4 cut swap hex> ] dip swap >>offset
                [ 2 cut swap hex> ] dip swap >>type
                [ len>> 2 * cut hex> ] keep swap >>checksum
                [ ihex-data ] dip swap >>data
            ] when
        ] when
        [ ihex-line? ] keep swap   ! make sure have the correct tupple
        [
            dup ihex-line-checksum? not >>error swap
            [ vector>> ] keep swap rot suffix >>vector
        ]
        [ drop ] if
    ] each
    ;


! make structure to store the lines of data
: <ihex> ( path -- ihex )
    ihex new swap >>path 0 >>start
    ihex-read ihex-array
    ;



