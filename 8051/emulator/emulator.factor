! Copyright (C) 2011 Joseph L Moschini.
! See http://factorcode.org/license.txt for BSD license.
!


USING: kernel ;


IN: intel.8051.emulator


TUPLE: instruct opcode mneminic nobytes clock ;

: instructions ( -- )
    \ instructions get-global
    [
        T{ instruct f 0 "invalid" 0 0 } \ instructions
    ] until
    \ instructions get-global ;

: OP_00 ( -- )
    ;

