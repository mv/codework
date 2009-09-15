#!/usr/bin/perl
# popgrep4 - grep for abbreviations of places that say "pop"
# version 4: use Regexp module
use Regexp;
@popstates = qw(CO ON MI WI MN);
@poppats   = map { Regexp->new( '\b' . $_ . '\b') } @popstates;
while (defined($line = <>)) {
    for $patobj (@poppats) {
        print $line if $patobj->match($line);
    }
}
