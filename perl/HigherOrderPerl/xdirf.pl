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

use File::Find;

foreach my $d (@ARGV) {

    find( sub{ printf "%7d %s\n", -s $File::Find::name, $File::Find::name, "\n" } , $d);

}
