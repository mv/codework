#!/usr/bin/perl -w
#
# ch05/prepare/ex1: Simply creates a database handle and a statement handle

use DBI;

### The database handle
my $dbh = DBI->connect( undef, undef, undef );

### The statement handle
my $sth = $dbh->prepare( "SELECT id, name FROM megaliths" );

exit;
