#!/usr/bin/perl
# Dez/2007

use strict;
use FindBin qw($Bin);
use lib "$Bin/../lib";
use lib "$Bin";
use hop;

die <<Thanatos unless (@ARGV);

    Usage: $0 <dirs>

Thanatos

foreach my $d (@ARGV) {

    dir_walk( $d, \&mysize );

}

sub mysize {
    my $size;
    if( -l $_[0] ) {
        (undef,undef,undef,undef,undef,undef,undef,$size) = lstat($_[0])
    } else {
        (undef,undef,undef,undef,undef,undef,undef,$size) =  stat($_[0])
    };
    printf "%7d %s\n", $size, $_[0], "\n"
}
