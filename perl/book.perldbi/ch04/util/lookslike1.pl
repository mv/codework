#!/usr/bin/perl -w
#
# ch04/util/lookslike1: Tests out the DBI::looks_like_number() function.
#

use DBI;

### Declare a list of values
my @values = ( 333, 'Choronzon', 'Tim', undef, 'Alligator', 1234.34, 
               'Linda', 0x0F, '0x0F', 'Larry Wall' );

### Check to see which are numbers!
my @areNumbers = DBI::looks_like_number( @values );

for (my $i = 0; $i < @values; ++$i ) {

    my $value = (defined $values[$i]) ? $values[$i] : "undef";

    print "values[$i] -> $value ";

    if ( defined $areNumbers[$i] ) {
        if ( $areNumbers[$i] ) {
            print "is a number!\n";
        }
        else {
            print "is utterly unlike a number and should be quoted!\n";
        }
    }
    else {
        print "is undefined!\n";
    }
}

exit;
