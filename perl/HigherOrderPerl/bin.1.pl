#!/usr/bin/perl -w
use strict;

use FindBin qw($Bin);
use lib "$Bin/../lib";
use lib "$Bin";

use hop;


die <<Thanatos unless (@ARGV);

    Usage: $0 <numbers>

Thanatos

foreach my $number (@ARGV) {
    printf "%16s : %4d\n", binary($number),$number;
}
