#!/usr/bin/perl -w
use strict;

use FindBin qw($Bin);
use lib "$Bin/../lib";
use lib "$Bin";

use hop;


die <<Thanatos unless (@ARGV);

    Usage: $0 <numbers>

Thanatos

foreach my $number (0 .. $ARGV[0]) {
    printf "%4d : %d\n", $number, factorial($number);
}
