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

    print "$d total size = ", dir_walk_cb( $d, sub{ -s $_[0]}, \&dir_size ), "\n";

}

sub dir_size {
    my $dir = shift;
    my $total = -s $dir;
    for my $n (@_) { $total += $n };
    printf "%8d %s\n", $total, $dir;
    return $total;
}
