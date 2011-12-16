#!/usr/bin/perl -w
#
# ch02/DBM/simple3: Creates a Berkeley DB, inserts some complex test data
#                   and dumps it out again

use DB_File;
use Megalith;

### Initialize the Berkeley DB
my %database;
tie %database, 'DB_File', "simple3.dat"
    or die "Can't initialize database: $!\n";

### Insert some data rows
$database{'Callanish I'} =
    new Megalith( 'Callanish I', 
                  "Western Isles",
                  "NB 213 330",
                  "Stone Circle",
                  "Description of Callanish I" );

$database{'Avebury'} =
    new Megalith( "Avebury",
                  "Wiltshire",
                  "SU 103 700",
                  "Stone Circle and Henge",
                  "Description of Avebury" );

$database{'Lundin Links'} =
    new Megalith( "Lundin Links",
                  "Fife",
                  "NO 404 027",
                  "Standing Stones",
                  "Description of Lundin Links" );

### Dump the database
foreach my $key ( keys %database ) {

    print "$key\n", ( "=" x length( $key ) ), "\n\n";

    my $megalith = new Megalith( $database{$key} );
    $megalith->dump();
}

### Close the Berkeley DB
untie %database;

exit;
