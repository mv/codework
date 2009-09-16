#!perl -w
# $Id$
#
# file:///C:/pub/doc/perldoc-5.8.8/Test/Tutorial.html
#

use Test::Simple tests => 2;

use Date::ICal;

my $ical = Date::ICal->new;         # create an object
ok( defined $ical           , 'new() returned something');      # check that we got something
ok( $ical->isa('Date::ICal'), "  and it's the right class" );   # and it's the right class

