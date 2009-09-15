#!/usr/bin/perl -w
#
# ch04/disconnect/ex1: Connects to an Oracle database
#                      with auto-error-reporting disabled
#                      then performs an explicit disconnection.

use DBI;            # Load the DBI module

### Perform the connection using the Oracle driver
my $dbh = DBI->connect( undef, undef, undef, {
            PrintError => 0
        } )
    or die "Can't connect to Oracle database: $DBI::errstr\n";

### Now, disconnect from the database
$dbh->disconnect
    or warn "Disconnection failed: $DBI::errstr\n";

exit;
