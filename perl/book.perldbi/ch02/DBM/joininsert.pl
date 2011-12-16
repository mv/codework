#!/usr/bin/perl -w
#
# ch02/DBM/joininsert: Creates a Berkeley DB, inserts some complex 
#                      test data and dumps it out again.

use DB_File;
use Fcntl ':flock';
use Megalith;

### Initialize the Berkeley DB
my %database;
my $db = tie %database, 'DB_File', "joininsert.dat"
    or die "Can't initialize database: $!\n";

my $fd = $db->fd();
open DATAFILE, "+<&=$fd"
    or die "Can't safely open file: $!\n";
print "Acquiring exclusive lock...";
flock( DATAFILE, LOCK_EX )
    or die "Unable to acquire lock: $!. Aborting";
print "Acquired lock. Ready to update database!\n\n";

### Insert some data rows
$database{'Callanish I'} =
    join( ':', 'Callanish I', 'Callanish, Western Isles', 'NB 213 330',
               'Stone Circle', 'Description of Callanish I' );

$database{'Avebury'} =
    join( ':', 'Avebury', 'Wiltshire', 'SU 103 700', 'Stone Circle and Henge',
               'Description of Avebury' );

$database{'Lundin Links'} =
    join( ':', 'Lundin Links', 'Fife', 'NO 404 027', 'Standing Stones',
               'Description of Lundin Links' );

### Dump the database
foreach my $key ( keys %database ) {
    my ( $name, $location, $mapref, $type, $description ) =
        split( /:/, $database{$key} );
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
