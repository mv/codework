#!/usr/bin/env perl
#

use strict;
use warnings;

use CGI qw(:standard Vars);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);

use Data::Dumper;

print header;
print "<html><code>\n";

my %form = Vars();
my $json = $form{'keywords'};

print "\%form:\n", %form , "</br>\n";
print "\%form:\n", Dumper( %form ) , "</br>\n";
print "\$json:\n", Dumper( $json ) , "</br>\n";

# print "keywords:\n", $json, "\n\n";
# print "Repo: ", $j->{'repository'}->{'name'}, "\n\n";




print "</code></html>\n";

