#!/usr/bin/perl -w
#
# ch02/DBM/simpleinsert: Creates a Berkeley DB, inserts some test data
#                        and dumps it out again

use DB_File;
use Fcntl ':flock';

### Initialize the Berkeley DB
my %database;
my $db = tie %database, 'DB_File', "simpleinsert.dat",
        O_CREAT | O_RDWR, 0666
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
    "This site, commonly known as the ``Stonehenge of the North'' is in the
form of a buckled Celtic cross.";

$database{'Avebury'} =
    "Avebury is a vast, sprawling site that features, amongst other marvels,
the largest stone circle in Britain. The henge itself is so large,
it almost completely surrounds the village of Avebury.";

$database{'Lundin Links'} =
    "Lundin Links is a megalithic curiosity, featuring 3 gnarled and
immensely tall monoliths arranged possibly in a 4-poster design.
Each monolith is over 5m tall.";

### Untie the database
undef $db;
untie %database;

### Close the file descriptor to release the lock
close DATAFILE;


### Retie the database to ensure we're reading the stored data
$db = tie %database, 'DB_File', "simpleinsert.dat", O_RDWR, 0444
    or die "Can't initialize database: $!\n";

### Only need to lock in shared mode this time because we're not updating..
$fd = $db->fd();
open DATAFILE, "+<&=$fd" or die "Can't safely open file: $!\n";
print "Acquiring shared lock...";
flock( DATAFILE, LOCK_SH )
    or die "Unable to acquire lock: $!. Aborting";
print "Acquired lock. Ready to read database!\n\n";

### Dump the database
foreach my $key ( keys %database ) {
    print "$key\n", ( "=" x ( length( $key ) + 1 ) ), "\n\n";
    print "$database{$key}\n\n";
}

### Close the Berkeley DB
undef $db;
untie %database;

### Close the file descriptor to release the lock
close DATAFILE;

exit;
