#!/usr/bin/perl -w
#
# ch04/error/ex2: Small example using automatic error-handling with 
#                 RaiseError, ie, the program will abort upon detection
#                 of any errors.

use DBI;            # Load the DBI module

my ($dbh, $sth, @row);

### Perform the connection using the Oracle driver
$dbh = DBI->connect( undef, undef, undef, {
    PrintError => 0,   ### Don't report errors via warn()
    RaiseError => 1    ### Do report errors via die()
} );

### Prepare a SQL statement for execution
$sth = $dbh->prepare( "SELECT * FROM megaliths" );

### Execute the statement in the database
$sth->execute();

### Retrieve the returned rows of data
while ( @row = $sth->fetchrow_array() ) {
    print "Row: @row\n";
}

### Disconnect from the database
$dbh->disconnect();

exit;
