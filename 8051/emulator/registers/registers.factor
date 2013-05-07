! Copyright (C) 2013 Joseph Moschini.
! See http://factorcode.org/license.txt for BSD license.
!

USING: accessors arrays io io.encodings.binary io.files
       intel.hex
       kernel lexer intel.8051.emulator.psw
       intel.8051.emulator.registers.register
       math math.bitwise models namespaces sequences
       tools.continuations ;


IN: intel.8051.emulator.registers



: registers-init ( -- )
    0 8 0 <array>
    [
        break
        <register>
    ] with map
    ;