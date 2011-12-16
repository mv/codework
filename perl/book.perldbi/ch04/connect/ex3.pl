#!/usr/bin/perl -w
#
# ch04/connect/ex3: Connects to two Oracle databases simultaneously.

use DBI;            # Load the DBI module

### Perform the connection using the Oracle driver
my $dbh1 = DBI->connect( undef, undef, undef )
    or die "Can't connect to 1st Oracle database: $DBI::errstr\n";

my $dbh2 = DBI->connect( "dbi:Oracle:seconddb", "username2", "password2" )
    or die "Can't connect to 2nd Oracle database: $DBI::errstr\n";

exit;
