! Copyright (C) 2013 Joseph Moschini.
! See http://factorcode.org/license.txt for BSD license.
!

USING: accessors arrays io io.encodings.binary io.files
       kernel lexer math namespaces sequences tools.continuations ;


IN: intel.8051.emulator



TUPLE: cpu a b psw dptr sp pc rom ram ;

: <cpu> ( -- cpu )
  cpu new
  0 >>pc
  0 >>a
  0 >>b
  0 >>psw
  0 >>dptr
  0 >>sp
;

: (load-rom) ( n ram -- )
  read1
  [ ! n ram ch
    -rot [ set-nth ] 2keep [ 1 + ] dip (load-rom)
  ]
  [ 2drop ] if* ;

#! Reads the ROM from stdin and stores it in ROM from
#! offset n.
#! Load the contents of the file into ROM.
#! (address 0x0000-0x1FFF).
: load-rom ( filename cpu -- )
  ram>> swap binary
  [ 
    0 swap (load-rom)
  ] with-file-reader ;

: not-implemented ( cpu -- )
  drop ;

: instructions ( -- vector )
  \ instructions get-global
  [
    #! make sure we always return with array
    256 [ not-implemented ] <array> \ instructions set-global
  ] unless
  \ instructions get-global ;

: set-instruction ( quot n -- )
  instructions set-nth ;



: (opcode_00) ( cpu -- )
  drop ;

: (opcode_01) ( cpu -- )
  drop ;