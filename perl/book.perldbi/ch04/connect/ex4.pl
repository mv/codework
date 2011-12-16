#!/usr/bin/perl -w
#
# ch04/connect/ex4: Connects to two database, one Oracle, one mSQL
#                   simultaneously. The mSQL database handle has 
#                   auto-error-reporting disabled.

use DBI;            # Load the DBI module

### Perform the connection using the Oracle driver
my $dbh1 = DBI->connect( undef, undef, undef )
    or die "Can't connect to Oracle database: $DBI::errstr\n";

my $dbh2 = DBI->connect( "dbi:mSQL:seconddb", "descarte", "mypassword", {
            PrintError => 0
        } )
    or die "Can't connect to mSQL database: $DBI::errstr\n";

exit;
