#!perl -w
# $Id$
#
# file:///C:/pub/doc/perldoc-5.8.8/Test/Tutorial.html
#

use Test::More tests => 8;

use Date::ICal;

my $ical = Date::ICal->new;         # create an object
   $ical = Date::ICal->new( year => 1964, month => 10, day => 16,
                            hour => 16, min => 12, sec => 47,
                            tz => '0530' );

ok( defined $ical           , 'new() returned something');      # check that we got something
ok( $ical->isa('Date::ICal'), "  and it's the right class" );   # and it's the right class

is( $ical->sec   ,  47,       '  sec()'   );
is( $ical->min   ,  12,       '  min()'   );
is( $ical->hour  ,  19,       '  hour()'  );
is( $ical->day   ,  16,       '  day()'   );
is( $ical->month ,  10,       '  month()' );
is( $ical->year  ,  1964,     '  year()'  );
