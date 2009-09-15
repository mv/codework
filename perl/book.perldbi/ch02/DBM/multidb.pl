#!/usr/bin/perl -w
#
# ch02/DBM/multidb: Creates a Berkeley DB and inserts some object test
#                   data. We then build a couple of referential hashes 
#                   that contain references to the original hash keyed
#                   on different terms.

use DB_File;
use Fcntl ':flock';
use Megalith;

### Initialize and lock the Berkeley DB
my %database;
my $db = tie %database, 'DB_File', "multidb.dat"
    or die "Can't initialize database: $!\n";

### Exclusively lock the database to ensure no-one's accessing it
my $fd = $db->fd();
open DATAFILE, "+<&=$fd"
    or die "Can't safely open file: $!\n";
print "Acquiring exclusive lock...";
flock( DATAFILE, LOCK_EX )
    or die "Unable to acquire lock: $!. Aborting";
print "Acquired lock. Ready to update database!\n\n";

$database{'Callanish I'} =
    new Megalith( 'Callanish I', 
                  'Western Isles',
                  'NB 213 330',
                  'Stone Circle',
                  'Description of Callanish I' )->pack();

$database{'Avebury'} =
    new Megalith( 'Avebury',
                  'Wiltshire',
                  'SU 103 700',
                  'Stone Circle and Henge',
                  'Description of Avebury' )->pack();

$database{'Lundin Links'} =
    new Megalith( 'Lundin Links',
                  'Fife',
                  'NO 404 027',
                  'Standing Stones',
                  'Description of Lundin Links' )->pack();

### Build a referential hash based on the location of each monument
my %locationDatabase;
$locationDatabase{'Wiltshire'}     = \$database{'Avebury'};
$locationDatabase{'Western Isles'} = \$database{'Callanish I'};
$locationDatabase{'Fife'}          = \$database{'Lundin Links'};

### Dump the location database
foreach my $key ( keys %locationDatabase ) {

    ### Unpack the record into a new megalith object
    my $megalith = new Megalith( ${ $locationDatabase{$key} } );

    ### And display the record
    $megalith->dump();
}

### Close the Berkeley DB
undef $db;
undef %locationDatabase;
untie %database;

### Close the associated file descriptor
close DATAFILE;

exit;
