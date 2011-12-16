#!/usr/bin/perl -w
#
# ch04/error/ex3: Small example using manual error-checking which also uses 
#                 handle-specific methods for reporting on the errors.

use DBI;            # Load the DBI module

### Attributes to pass to DBI->connect() to disable automatic
### error-checking
my %attr = (
    PrintError => 0,
    RaiseError => 0,
);

### Perform the connection using the Oracle driver
my $dbh = DBI->connect( undef, undef, undef, \%attr )
    or die "Can't connect to database: ", $DBI::errstr, "\n";

### Prepare a SQL statement for execution
my $sth = $dbh->prepare( "SELECT * FROM megaliths" )
    or die "Can't prepare SQL statement: ", $dbh->errstr(), "\n";

### Execute the statement in the database
$sth->execute
    or die "Can't execute SQL statement: ", $sth->errstr(), "\n";

### Retrieve the returned rows of data
while ( my @row = $sth->fetchrow_array() ) {
    print "Row: @row\n";
}
warn "Problem in fetchrow_array(): ", $sth->errstr(), "\n"
    if $sth->err();

### Disconnect from the database
$dbh->disconnect
    or warn "Failed to disconnect: ", $dbh->errstr(), "\n";

exit;
