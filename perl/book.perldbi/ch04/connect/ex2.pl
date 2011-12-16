#!/usr/bin/perl -w
#
# ch04/connect/ex2: Connects to two Oracle databases simultaneously 
#                   with identical arguments. This is to illustrate 
#                   that each database handle, even if identical
#                   argument-wise, are completely separate from
#                   each other.

use DBI;            # Load the DBI module

### Perform the connection using the Oracle driver
my $dbh1 = DBI->connect( undef, undef, undef )
    or die "Can't make 1st database connect: $DBI::errstr\n";

my $dbh2 = DBI->connect( undef, undef, undef )
    or die "Can't make 2nd database connect: $DBI::errstr\n";

exit;
