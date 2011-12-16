#!/usr/bin/perl -w
#
# ch04/util/neat1: Tests out the DBI::neat() utility function.
#

use DBI;

### Declare some strings to neatify
my $str1 = "Alligator's an extremely neat() and tidy person";
my $str2 = "Oh no\nhe's not!";

### Neatify this first string to a maxlen of 40
print "String: " . DBI::neat( $str1, 40 ) . "\n";

### Neatify the second string to a default maxlen of 400
print "String: " . DBI::neat( $str2 ) . "\n";

### Neatify a number
print "Number: " . DBI::neat( 42 * 9 ) . "\n";

### Neatify an undef
print "Undef: " . DBI::neat( undef ) . "\n";

exit;
