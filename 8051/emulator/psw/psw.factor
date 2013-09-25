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
    [ value>> 7 bit? ]
    [ drop f ] if ;

! push b into cy
: >psw-cy ( ? psw -- )
    swap [ psw-cy-set ] [ psw-cy-clr ] if ;

! return the carry flag status
: psw-cy ( psw -- b )
    dup psw?
    [ value>> 7 7 bit-range ]
    [ drop 0 ] if ;

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

: psw-ac? ( psw -- ? )
    dup psw?
    [ value>> 6 bit? ]
    [ drop f ] if ;

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

! OV Flag set
: psw-ov-set ( psw -- )
    dup psw?
    [
       [ value>> 7 set-bit ] keep set-model
    ]
    [ drop ] if ;

! OV flag cleared
: psw-ov-clr ( psw -- )
    dup psw?
    [
        [ value>> 2 clear-bit ] keep set-model
    ]
    [ drop ] if ;

! OV Flage test
: psw-ov? ( psw -- ? )
    dup psw?
    [ value>> 2 bit? ]
    [ drop f ] if ;

! push b into OV
: >psw-ov ( ? psw -- )
    swap [ psw-ov-set ] [ psw-ov-clr ] if ;

! return the OV flag status
: psw-ov ( psw -- b )
    dup psw?
    [ value>> 7 7 bit-range ]
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

! RRC instruction affects the  flags so we do it here
! Rotate Right thrugh carry
! ------------------
! |                |
! ^                v
! 7 6 5 4 3 2 1 0<-C
: psw-rlc ( b psw -- b' )
    [ psw-cy? ] keep    ! get carry bit
    -rot swap rot [ swap 7 bit? [ psw-cy-set ] [ psw-cy-clr ] if ] 2keep
    drop 1 shift swap [ 0 set-bit ] [ 0 clear-bit ] if 7 0 bit-range
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
    [ 3dup [ 7 bits ] dip [ swap 7 bits swap ] dip + + 7 7 bit-range ] dip
    [ psw-cy ] keep [ bitxor 1 = ] dip [ >psw-ov ] keep
     drop + + 8 bits ;
     
! DIV AB divides the unsigned eight-bit integer in the Accumulator by the
! unsigned eight-bit integer in register B. The Accumulator receives the
! integer part of the quotient; register B receives the integer remainder.
! The carry and OV flags are cleared.
: psw-div ( a b psw -- q r )
    [ psw-cy-clr ] keep
    [ psw-ov-clr ] keep
    -rot [ 0 = ] keep swap
    [
        drop drop
        psw-ov-set
        0 0
    ]
    [
        rot drop
        /mod
    ] if ;
    
    
! SUBB subtracts the indicated variable and the carry flag together from the Accumulator,
! leaving the result in the Accumulator. SUBB sets the carry (borrow) flag if a borrow is
! needed for bit 7 and clears C otherwise. (If C was set before executing a SUBB instruction, this indicates that a borrow was needed for the previous step in a
! multiple-precision subtraction, so the carry is subtracted from the Accumulator along
! with the source operand.) AC is set if a borrow is needed for bit 3 and cleared otherwise.
! OV is set if a borrow is needed into bit 6, but not into bit 7, or into bit 7,
! but not bit 6. When subtracting signed integers, OV indicates a negative number
! produced when a negative value is subtracted from a positive value, or a positive
! result when a positive number is subtracted from a negative number.
: psw-sub ( a b c psw -- r )
    [ 3dup - - 8 8 bit-range 1 = ] dip [ >psw-cy ] keep ! carry
    [ 3dup [ 3 bits ] dip [ swap 3 bits swap ] dip - - 4 4 bit-range 1 = ] dip
    [ >psw-ac ] keep    
    [ 3dup [ 7 bits ] dip [ swap 7 bits swap ] dip - - 7 7 bit-range ] dip
    [ psw-cy ] keep [ bitxor 1 = ] dip [ >psw-ov ] keep
    drop - - 8 bits ;
    
    
! MUL multiplies the unsigned 8-bit integers in the Accumulator and register B.
! The low-order byte of the 16-bit product is left in the Accumulator,
! and the high-order byte in B. If the product is greater than 255 (0FFH),
! the overflow flag is set; otherwise it is cleared. The carry flag is always cleared.
: psw-mul ( a b psw -- x y )
    [ * ] dip
    [ dup 15 8 bit-range swap 7 0 bit-range swap ] dip
    [ dup 0 = not ] dip swap
    [
        dup psw-ov-set psw-cy-clr
    ]
    [
        dup psw-ov-clr psw-cy-clr
    ] if ;

! data sheets for this operation are a bit unclear..
! - should AC (or C) ever be cleared?
! - should this be done in two steps?
: psw-decimaladjust ( a psw -- b )
    [ dup ] dip
    [ 3 0 bit-range ] dip
    [ 9 > ] dip [ psw-ac? ] keep
    [ or ] dip
    [ [ 6 + ] when ] dip
    [ dup ] dip
    [ 11 4 bit-range ] dip
    [ 9 > ] dip [ psw-cy? ] keep [ or ] dip
    [ [ 0x60 + ] when ] dip
    [ dup 0x99 > ] dip swap
    [ psw-cy-set 8 bits ] [ drop 8 bits ] if ;

! return the binary string of psw
: psw-binary ( psw -- b )
;