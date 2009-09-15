#!/usr/bin/perl -w
#
# ch05/fetchall_arrayref/ex1: Complete example that connects to a database,
#                             executes a SQL statement, then fetches all the
#                             data rows out into a data structure. This
#                             structure is then traversed and printed.

use DBI;

### The database handle
my $dbh = DBI->connect( undef, undef, undef, {
    RaiseError => 1
});

### The statement handle
my $sth = $dbh->prepare( " SELECT name, location, mapref FROM megaliths " );

### Execute the statement
$sth->execute();

### Fetch all the data into a Perl data structure
my $array_ref = $sth->fetchall_arrayref();

### Traverse the data structure and dump each piece of data out
###
### For each row in the returned array reference.....
foreach my $row (@$array_ref) {
    ### Split the row up and print each field...
    my ( $name, $type, $location ) = @$row;
    print "\tMegalithic site $name, found in $location, is a $type\n";
}

exit;
