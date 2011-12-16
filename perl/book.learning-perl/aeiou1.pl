#!/usr/bin/perl


# aeiou1.pl

# mostra linhas com a seq a e i o u
while ( <STDIN> ) {
    if ( /a.*e.*i.*o.*u.*/i ) {
        print ;
    }
}

