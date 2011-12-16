#!/usr/bin/perl -w
#
# ch05/fetchall_arrayref/ex3: Complete example that connects to a database,
#                             executes a SQL statement, then fetches all the
#                             data rows out into a data structure. This
#                             structure is then traversed and printed.

use DBI;

### The database handle
my $dbh = DBI->connect( undef, undef, undef, {
    RaiseError => 1,
} );

### The statement handle
my $sth = $dbh->prepare( " SELECT name, location, mapref FROM megaliths " );

### Execute the statement
$sth->execute();

### Fetch all the data into an array reference of hash references!
my $array_ref = $sth->fetchall_arrayref( { name => 1, location => 1 } );

### Traverse the data structure and dump each piece of data out
###
### For each row in the returned array reference.....
foreach my $row (@$array_ref) {
    ### Get the appropriate fields out the hashref and print...
    print "\tMegalithic site $row->{name}, found in $row->{location}\n";
}

exit;
