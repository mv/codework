#!/usr/bin/perl -w
#
# ch04/connect/ex1: Connects to an Oracle database.

use DBI;            # Load the DBI module

### Perform the connection using the Oracle driver
my $dbh = DBI->connect( undef, undef, undef )
    or die "Can't connect to Oracle database: $DBI::errstr\n";

exit;
