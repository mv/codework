# YAML summary

## Remember

    #       comment
    ---     separate documents
    ...     ends a file
    ''      string
    ""      string, with escapes/encoding
    &       anchor: defines a reference
    *       alias: uses a reference     ('shipto: *billto' )
    <<      merge keys from a reference ('<<: *defaults'   )
    |       multiline string: preserves newlines
    >       multiline string: coalesce newlines

    Language Independent Scalar types
            { ~, null }              : Null (no value).
            [ 1234, 0x4D2, 02333 ]   : [ Decimal int, Hexadecimal int, Octal int ]
            [ 1_230.15, 12.3015e+02 ]: [ Fixed float, Exponential float ]
            [ .inf, -.Inf, .NAN ]    : [ Infinity (float), Negative, Not a number ]
            { Y, true, Yes, ON  }    : Boolean true
            { n, FALSE, No, off }    : Boolean false
            ? !!binary >
                R0lG...BADS=
            : >-
                Base 64 binary value.

    Escape codes:
            Numeric   : { "\x12": 8-bit, "\u1234": 16-bit, "\U00102030": 32-bit }
            Protective: { "\\": '\', "\"": '"', "\ ": ' ', "\<TAB>": TAB }
            C         : { "\0": NUL, "\a": BEL, "\b": BS, "\f": FF, "\n": LF, "\r": CR, "\t": TAB, "\v": VTAB }
            Additional: { "\e": ESC, "\_": NBSP, "\N": NEL, "\L": LS, "\P": PS }

## Arrays

    Explicit                          Inflow
    --------                          ------
    - Mark McGwire                    [ Mark McGwire, Sammy Sosa, Ken Griffey ]
    - Sammy Sosa
    - Ken Griffey


## Array of Arrays

    - [ name         , hr , avg   ]
    - [ Mark McGwire , 65 , 0.278 ]
    - [ Sammy Sosa   , 63 , 0.288 ]


## Array of Hashes

    Explicit                          Inflow
    --------                          ------
    -                                 - { name: Mark McGwire, hr: 65, avg: 0.278 }
        name: Mark McGwire            - { name: Sammy Sosa, hr: 63, avg: 0.288 }
        hr:   65
        avg:  0.278
    -
        name: Sammy Sosa
        hr:   63
        avg:  0.288


## Hashes

    Explicit                          Inflow
    --------                          ------
    hr:  65                           { hr:  65, avg: 0.278, rbi: 147 }
    avg: 0.278
    rbi: 147


## Hash of Arrays

    Explicit                          Inflow
    --------                          ------
    american:                         american: [ Boston Red Sox, Detroit Tigers, New York Yankees ]
        - Boston Red Sox              national: [ New York Mets,  Chicago Cubs,   Atlanta Braves   ]
        - Detroit Tigers
        - New York Yankees
    national:
        - New York Mets
        - Chicago Cubs
        - Atlanta Braves


## Hash of Hashes

    Mark McGwire: { hr: 65, avg: 0.278 }
    Sammy Sosa: {
        hr: 63,
        avg: 0.288
    }



# References


[YAML on Wikipedia](http://en.wikipedia.org/wiki/YAML#Advanced_components_of_YAML)

[Reference Card](http://www.yaml.org/refcard.html)

[Specification](http://www.yaml.org/spec/1.2/spec.html)

