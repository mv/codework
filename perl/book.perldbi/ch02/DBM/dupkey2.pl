#!/usr/bin/perl -w
#
# ch02/DBM/dupkey2: Creates a Berkeley DB with the DB_BTREE mechanism and 
#                   allows for duplicate keys. We then insert some test 
#                   object data with duplicate keys and dump the final
#                   database.

use DB_File;
use Fcntl ':flock';
use Megalith;

### Set Berkeley DB Btree mode to handle duplicate keys
$DB_BTREE->{'flags'} = R_DUP;

### Remove any existing database files
unlink 'dupkey2.dat';

### Open the database up
my %database;
my $db = tie %database, 'DB_File', "dupkey2.dat", 
                   O_CREAT | O_RDWR, 0666, $DB_BTREE
    or die "Can't initialize database: $!\n";

### Exclusively lock the database to ensure no-one's accessing it
my $fd = $db->fd();
open DATAFILE, "+<&=$fd"
    or die "Can't safely open file: $!\n";
print "Acquiring exclusive lock...";
flock( DATAFILE, LOCK_EX )
    or die "Unable to acquire lock: $!. Aborting";
print "Acquired lock. Ready to update database!\n\n";

### Create, pack and insert some rows with duplicate keys
$database{'Wiltshire'} = 
    new Megalith( 'Avebury',
                  'Wiltshire',
                  'SU 103 700',
                  'Stone Circle and Henge',
                  'Largest stone circle in Britain' )->pack();

$database{'Wiltshire'} =
    new Megalith( 'Stonehenge',
                  'Wiltshire',
                  'SU 123 400',
                  'Stone Circle and Henge',
                  'The most popularly known stone circle in the world' )->pack();

$database{'Wiltshire'} =
    new Megalith( 'The Sanctuary',
                  'Wiltshire',
                  'SU 118 680',
                  'Stone Circle ( destroyed )',
                  'No description available' )->pack();

### Dump the database
my ($key, $value, $status) = ('', '', 0);
for ( $status = $db->seq( $key, $value, R_FIRST ) ;
      $status == 0 ;
      $status = $db->seq( $key, $value, R_NEXT ) ) {

    ### Unpack the record into a new megalith object
    my $megalith = new Megalith( $value );

    ### And display the record
    $megalith->dump();
}

### Close the database
undef $db;
untie %database;

### Close the filehandle to release the lock
close DATAFILE;

exit;
