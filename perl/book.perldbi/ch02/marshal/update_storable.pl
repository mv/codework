#!/usr/bin/perl -w
#
# ch02/marshal/update_storable: Updates the given megalith data file
#                               for a given site. Uses Storable data
#                               and updates the map reference field.

use Storable qw( nfreeze thaw );

### Check the user has supplied an argument to scan for
###     1) The name of the file containing the data
###     2) The name of the site to search for
###     3) The new map reference
die "Usage: updatemegadata <data file> <site name> <new map reference>\n"
    unless @ARGV == 3;

my $megalithFile = $ARGV[0];
my $siteName     = $ARGV[1];
my $siteMapRef   = $ARGV[2];
my $tempFile     = "tmp.$$";

### Open the data file for reading, and die upon failure
open MEGADATA, "<$megalithFile"
    or die "Can't open $megalithFile: $!\n";

### Open the temporary megalith data file for writing
open TMPMEGADATA, ">$tempFile"
    or die "Can't open temporary file $tempFile: $!\n";

### Scan through all the entries for the desired site
while ( <MEGADATA> ) {

    ### Convert the ASCII encoded string back to binary
    ### (pack ignores the trailing newline record delimiter)
    my $frozen = pack "H*", $_;

    ### Thaw the frozen data structure
    my $fields = thaw( $frozen );

    ### Break up the record data into separate fields
    my ( $name, $location, $mapref, $type, $description ) = @$fields;

    ### Skip the record if the extracted site name field doesn't match
    next unless $siteName eq $name;

    ### We've found the record to update
    ### Create a new fields array with new map ref value
    $fields = [ $name, $location, $siteMapRef, $type, $description ];

    ### Freeze the data structure into a binary string
    $frozen = nfreeze( $fields );

    ### Encode the binary string as readable ASCII and append a newline
    $_ = unpack( "H*", $frozen ) . "\n";

}
continue {

    ### Write the record out to the temporary file
    print TMPMEGADATA $_
        or die "Error writing $tempFile: $!\n";
}

### Close the megalith input data file
close MEGADATA;

### Close the temporary megalith output data file
close TMPMEGADATA
    or die "Error closing $tempFile: $!\n";

### We now 'commit' the changes by deleting the old file...
unlink $megalithFile
    or die "Can't delete old $megalithFile: $!\n";

### and renaming the new file to replace the old one.
rename $tempFile, $megalithFile
    or die "Can't rename '$tempFile' to '$megalithFile': $!\n";

exit 0;
