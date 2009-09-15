#!/usr/bin/perl -w
#
# ch02/DBM/delete: Creates a Berkeley DB, inserts some test data then
#                  deletes some of it

use strict;

use DB_File;

### Initialize the Berkeley DB
my  %database;
tie %database, 'DB_File', "delete.dat"
    or die "Can't initialize database: $!\n";

### Insert some data rows
$database{'Callanish I'}  = "Western Isles";
$database{'Avebury'}      = "Wiltshire";
$database{'Lundin Links'} = "Fife";

### Dump the database
print "Dumping the entire database...\n";
foreach my $key ( keys %database ) {
    printf "%15s - %s\n", $key, $database{$key};
}
print "\n";

### Delete a row
delete $database{'Avebury'};

### Re-dump the database
print "Dumping the database after deletions...\n";
foreach my $key ( keys %database ) {
    printf "%15s - %s\n", $key, $database{$key};
}

### Close the Berkeley DB
untie %database;

exit;
