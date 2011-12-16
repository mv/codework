#!/usr/bin/perl

# array
%words = qw( fred   camel
             barney llama
             betty  alpaca
             wilma  alpaca);   # qw: "quote words"

$i = 1;
while ( $i ) {
    print "\nEnter your name ";
    $name = <STDIN>;
    chomp ($name);

    print "For the name $name animais is $words{$name} . ";

    if ( $name eq "quit" ) {
        $i = 0 ;
    }
}
