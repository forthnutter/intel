! ! Copyright (C) 2013 Joseph Moschini.
! See http://factorcode.org/license.txt for BSD license.
!

USING: accessors arrays io io.encodings.binary io.files
       kernel lexer math math.bitwise models namespaces sequences
       tools.continuations ;
   
IN: intel.8051.emulator.psw


TUPLE: psw < model ;


! Create a PSW
: <psw> ( value -- psw )
    psw new-model ;


: psw-cy-set ( psw -- )
    dup psw?
    [
       [ value>> 0b10000000 bitor ] keep set-model
    ]
    [ drop ] if ;


: psw-cy-clr ( psw -- )
    d