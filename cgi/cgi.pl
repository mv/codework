#!/usr/bin/env perl
#
# http://perldoc.perl.org/CGI.html
#

use strict;
use warnings;

use CGI qw(:standard Vars);
use Data::Dumper;

$Data::Dumper::Indent = 1;


my $cgi = CGI->new;

print header;
print "<html><pre>\n\n";

print "Environment\n";
print "-----------\n";

foreach my $key (sort keys %ENV) {
    printf "%-20s = %s\n", $key, $ENV{$key};
}


my @names = $cgi->param;

print "\n\ncgi\n---\n";
print Dumper $cgi;

print "\ncgi.param\n----------\n";
print $names[0], " - ", $cgi->param( $names[0] ), "\n";

print "\ncgi.param keys\n---------------\n";
foreach my $key (sort $cgi->param ) {
    print "  ${key} = ", $cgi->param( $key ), "\n";
}
print "\n";

print "POSTDATA\n--------\n";
print $cgi->param('POSTDATA'),"\n";

print "PUTDATA\n-------\n";
print $cgi->param('PUTDATA'),"\n";

print "</pre></html>\n";

# print "\n", $cgi->redirect('http://somewhere.else/in/movie/land');

# vim:ft=perl:

