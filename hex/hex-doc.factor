USING: help help.markup help.syntax math kernel arrays ;
IN: intel.hex


HELP: ihex-read
{ $values
    { "path" string }
    { "ihexv" "vector of ihex tuples" }
}
{ $description
    "Read in the file and convert to an array tuples"
} ;

ARTICLE: "intel hex" "Intel Hex file reader and writer utilities"
"hex is Intel HEX file reader and writer"
{ $subsections
     ihex-read
} ;

ABOUT: "intel hex"