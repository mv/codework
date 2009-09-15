#!/usr/bin/perl -w
#
# ch04/util/neat2: Tests out the DBI::neat_list() utility function

use DBI qw( neat_list );

### Declare some strings to neatify
my @list = ( 'String-a-string-a-string-a-string-a-string', 42, 0, '', undef );

### Neatify the strings into an array
print neat_list( \@list, 40, ", " ), "\n";

exit;
