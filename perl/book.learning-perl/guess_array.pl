#!/usr/bin/perl

# array
@words = ("camel","llama","alpaca"); # explicit
@words = qw( camel llama alpaca );   # qw: "quote words"

while ( $words[$i] ) {
    print "Element $i = [ $words[$i] ]\n";
    $i = $i + 1;
}

print "Array [ @words ]";