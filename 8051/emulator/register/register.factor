! Copyright (C) 2013 Joseph Moschini.
! See http://factorcode.org/license.txt for BSD license.
!

USING: accessors arrays io io.encodings.binary io.files
       intel.hex
       kernel lexer intel.8051.emulator.psw
       math math.bitwise namespaces sequences
       tools.continuations ;



IN: intel.8051.emulator.register



TUPLE: register < model ;


! one register
: <register> ( value -- register )
    register new-model;
    ;
