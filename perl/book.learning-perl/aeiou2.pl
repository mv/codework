#!/usr/bin/perl


# aeiou1.pl

# mostra linhas com qq seq a e i o u
while ( <STDIN> ) {
    if ( /a/i && /e/i && /i/i && /o/i && /u/i   ) {
        print ;
    }
}

