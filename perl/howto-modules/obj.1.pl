#!/usr/bin/perl -w

use strict;

use FindBin qw($Bin);
use lib "$Bin/../lib";
use lib "$Bin";

use Obj_Simple;


die <<Thanatos unless (@ARGV);

    Usage: $0 <numbers>

Thanatos

my $obj = Obj_Simple->new();
print "\n\n2nd call.\n";
$obj->new();

__END__

1st call.
    this     = Obj_Simple
    ref this =
    class    = Obj_Simple
    self     = Obj_Simple=HASH(0x660f20)

2nd call.
    this     = Obj_Simple=HASH(0x660f20)
    ref this = Obj_Simple
    class    = Obj_Simple
    self     = Obj_Simple=HASH(0x661058)
