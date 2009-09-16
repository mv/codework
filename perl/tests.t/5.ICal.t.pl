#!perl -w
# $Id$
#
# file:///C:/pub/doc/perldoc-5.8.8/Test/Tutorial.html
#

use Test::More 'no_plan'; # tests => 32;
use Date::ICal;

my %ICal_Dates = (
        # An ICal string     And the year, month, date
        #                    hour, minute and second we expect.
        '19971024T120000' =>    # from the docs.
                                [ 1997, 10, 24, 12,  0,  0 ],
        '20390123T232832' =>    # after the Unix epoch
                                [ 2039,  1, 23, 23, 28, 32 ],
        '19671225T000000' =>    # before the Unix epoch
                                [ 1967, 12, 25,  0,  0,  0 ],
        '18990505T232323' =>    # before the MacOS epoch
                                [ 1899,  5,  5, 23, 23, 23 ],
);

while( my($ical_str, $expect) = each %ICal_Dates ) {
    my $ical = Date::ICal->new( ical => $ical_str );

    ok( defined $ical,            "new(ical => '$ical_str')" );
    ok( $ical->isa('Date::ICal'), "  and it's the right class" );

    is( $ical->year,    $expect->[0],     '  year()'  );
    is( $ical->month,   $expect->[1],     '  month()' );
    is( $ical->day,     $expect->[2],     '  day()'   );
    is( $ical->hour,    $expect->[3],     '  hour()'  );
    is( $ical->min,     $expect->[4],     '  min()'   );
    is( $ical->sec,     $expect->[5],     '  sec()'   );
}