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
: ihex-offset-len ( ihex -- address )
    [ len>> ] [ offset>>  ] bi +
    ;

: ihex-line-ok ( ihex-line -- ? )
  [ ihex-line? ] keep swap
  [ len>> 0 = not ] [ drop f ] if ;



! find the address max
: ihex-line-max ( vector -- max )
    0 swap
    [
        [ ihex-line-ok ] keep swap   ! make sure have the correct tupple
        [
            [ type>> ] keep swap
            {
                { 0 [ ihex-offset-len max ] } ! cal end address
                { 2 [ drop ] }
                { 3 [ drop ] }
                { 4 [ break drop ] }
                { 5 [ drop ] }
                [ drop drop ]
            } case
        ] [ break drop ] if
    ] each
    ;



! test length
: ihex-length ( ihex-line -- len )
  len>> ;

: ihex-length? ( ihex-line -- ? )
  ihex-length 0 = not ;

: bytes>number ( seq -- number )
    0 [ [ 8 shift ] dip bitor ] reduce ;


TUPLE: ihex start path flines lba sba vector array ;

! Now turn the array ihex tuples into a binary array
: ihex-array ( ihex -- ihex )
    [ vector>> ihex-line-max ] keep swap ! find max memory
    <byte-array> >>array [ array>> ] keep
    [ vector>>
      [
          [ ihex-line-ok ] keep swap
          [
              [ type>> ] keep swap
              {
                  { 0
                    [
                      [ data>> ] keep
                      offset>> rot [ copy ] keep
                    ]
                  }
                  { 1 [ drop ] }
                  { 2 [ drop ] }
                  { 3 [ drop ] }
                  { 4 [
                        break
                        [ data>> ] keep swap bytes>number
                        drop drop
                    ]
                  }
                  { 5 [ drop ] }
              } case
          ] [ drop ] if
      ] each
      drop
    ] keep
    ;


! prase each line of file
: ihex-flines ( ihex -- ihex' )
    V{ } clone >>vector
    [ flines>> ] keep swap
    [
        dup length 0 >
        [
            [ CHAR: : = ] trim-head
            dup length 0 >
            [
                <ihex-line> ! one tuple
                [ 2 cut swap hex> ] dip swap >>len
                [ 4 cut swap hex> ] dip swap >>offset
                [ 2 cut swap hex> ] dip swap >>type
                [ len>> 2 * cut hex> ] keep swap >>checksum
                [ ihex-data ] dip swap >>data
            ] when
        ] when
        [ ihex-line? ] keep swap
        [
            dup ihex-line-checksum? not >>error 
            [ ihex-length? ] keep swap
            [ swap [ vector>> ] keep swap rot suffix >>vector ]
            [ drop ] if    
        ]
        [ drop ] if
    ] each ;

! hex line make an array ihex tuples
: ihex-read ( ihex -- ihex' )
    dup path>> utf8 file-lines >>flines ;

! make structure to store the lines of data
: <ihex> ( path -- ihex )
    ihex new swap >>path 0 >>start
    ihex-read
    ihex-flines
    ihex-array
    ;
