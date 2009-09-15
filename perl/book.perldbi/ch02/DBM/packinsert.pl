#!/usr/bin/perl -w
#
# ch02/DBM/packinsert: Creates a Berkeley DB, inserts some complex
#                      test data and dumps it out again.

use DB_File;
use Fcntl ':flock';
use Megalith;

### Initialize the Berkeley DB
my %database;
my $db = tie %database, 'DB_File', "packinsert.dat"
    or die "Can't initialize database: $!\n";

### Exclusively lock the database to ensure no-one's accessing it
my $fd = $db->fd();
open DATAFILE, "+<&=$fd"
    or die "Can't safely open file: $!\n";
print "Acquiring exclusive lock...";
flock( DATAFILE, LOCK_EX )
    or die "Unable to acquire lock: $!. Aborting";
print "Acquired lock. Ready to update database!\n\n";

### Insert some data rows
$database{'Callanish I'} =
    pack( 'A64A64A16A32A256', 'Callanish I', 'Callanish, Western Isles', 
                              'NB 213 330', 'Stone Circle', 
                              'Description of Callanish I' );

$database{'Avebury'} =
    pack( 'A64A64A16A32A256', 'Avebury', 'Wiltshire', 'SU 103 700', 
                              'Stone Circle and Henge', 
                              'Description of Avebury' );

$database{'Lundin Links'} =
    pack( 'A64A64A16A32A256', 'Lundin Links', 'Fife', 'NO 404 027', 
                              'Standing Stones', 
                              'Description of Lundin Links' );

### Dump the database
foreach my $key ( keys %database ) {
    my ( $name, $location, $mapref, $type, $description ) =
        unpack( 'A64A64A16A32A256', $database{$key} );
    print "$name\n", ( "=" x length( $name ) ), "\n\n";
    print "Location: $location\tMap Reference: $mapref\n\n";
    print "$description\n\n";
}

### Close the Berkeley DB
undef $db;
untie %database;

### Close the file descriptor to release the lock
close DATAFILE;

exit;
