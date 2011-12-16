#!/usr/bin/perl -w
#
# ch02/scanmegadata/scanmegadatafixed: Scans the given megalith data
#                                      file for a given site.
#                                      Uses fixed-length data
#
#       Field           Required Bytes
#       -----           --------------
#       Name            64
#       Location        64
#       Map Reference   16
#       Type            32
#       Description     256

### Check the user has supplied an argument for
###     1) The name of the file containing the data
###     2) The name of the site to search for
die "Usage: scanmegadata <data file> <site name>\n" 
    unless @ARGV == 2;

my $megalithFile = $ARGV[0];
my $siteName     = $ARGV[1];

### Open the data file for reading, and die upon failure
open MEGADATA, "<$megalithFile"
    or die "Can't open $megalithFile: $!\n";

### Declare our row field variables
my ( $name, $location, $mapref, $type, $description );

### Declare our 'record found' flag
my $found;

### Scan through all the entries for the desired site
while ( <MEGADATA> ) {

    ### Remove the newline that acts as a record-delimiter
    chop;

    ### Break up the record data into separate fields
    ### using the data sizes listed above
    ( $name, $location, $mapref, $type, $description ) =
        unpack( "A64 A64 A16 A32 A256", $_ );

    ### Test the sitename against the record's name
    if ( $name eq $siteName ) {
        $found = $.;  # $. holds current line number in file
	last;
    }
}

### If we did find the site we wanted, print it out
if ( $found ) {
    print "Located site: $name on line $found\n\n";
    print "Information on $name ( $type )\n";
    print "===============",
        ( "=" x ( length($name) + length($type) + 5 ) ), "\n";
    print "Location:      $location\n";
    print "Map Reference: $mapref\n";
    print "Description:   $description\n";
}

### Close the megalith data file
close MEGADATA;

exit;
