! Copyright (C) 2013 Joseph Moschini.
! See http://factorcode.org/license.txt for BSD license.
!

USING: accessors arrays io io.encodings.binary io.files
       intel.hex
       kernel lexer math math.bitwise namespaces sequences
       tools.continuations ;


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


! increment the pc of cpu
: inc-pc ( cpu -- )
  dup pc>> 1 + swap pc<< ;

! read the rom addressed by pc
: read-pc ( cpu -- dd )
  dup pc>> swap rom>> ?nth ;

! read 16 bit data from ROM
: read-16 ( address cpu -- dddd )
  [ rom>> ?nth 8 shift ] 2keep swap 1 + swap rom>> ?nth bitor 16 bits ;

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


! NOP Instruction
: (opcode-00) ( cpu -- )
  inc-pc ;

! AJMP
! Absolute Jump
: (opcode-01) ( cpu -- )
  [ read-pc 0xe0 bitand 3 shift ] keep ! the instruction has part of address
  [ inc-pc ] keep [ read-pc ] keep -rot bitor swap pc<< ;

! LJMP
! Long Jump
: (opcode-02) ( cpu -- )
  [ inc-pc ] keep
  [ pc>> ] keep
  [ read-16 ] keep pc<< ;

! RR A
! Rotate Accumulator Right
: (opcode-03) ( cpu -- )
  [ a>> -1 8 bitroll ] keep swap >>a inc-pc ;
  
! INC A
! Increment Accumulator
: (opcode-04) ( cpu -- )
  [ a>> 1 + 8 bits ] keep swap >>a inc-pc ;
