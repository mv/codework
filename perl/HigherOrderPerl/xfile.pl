#!/usr/bin/perl
# Dez/2007

use strict;

die <<Thanatos unless (@ARGV);

    Usage: $0 <numbers>

Thanatos

foreach my $file (@ARGV) {
    if( -f $file )      { printf "%30s : file\n", $file;
    } elsif (-d $file ) { printf "%30s : dir\n", $file;
    } else              { printf "%30s : special\n", $file;
    }
}
