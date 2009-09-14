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

    dir_walk( $d, sub{ printf $_[0], "\n" if -l $_[0] && ! -e $_[0] } );

}
