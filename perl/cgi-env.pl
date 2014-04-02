#!/usr/bin/perl

use strict;
use warnings;

print "Content-type: text/html\n\n";
print "<html><code>\n";
foreach my $key (sort keys %ENV) {
    print "$key = '$ENV{$key}' <br>\n";
}
print "</code></html>\n";

