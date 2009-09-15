#!/usr/bin/perl -w
#
# ch02/updatemegadata/updatemegadata: Updates the given megalith data file
#                                     for a given site. Uses colon-separated 
#                                     data and updates the map reference field.
#

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

### Scan through all the records looking for the desired site
while ( <MEGADATA> ) {

    ### Quick pre-check for maximum performance:
    ### Skip the record if the site name doesn't appear as a field
    next unless m/^\Q$siteName:/;

    ### Break up the record data into separate fields
    ### (we let $description carry the newline for us)
    my ( $name, $location, $mapref, $type, $description ) =
        split( /:/, $_ );

    ### Skip the record if the site name doesn't match. (Redundant after the
    ### reliable pre-check above but kept for consistency with other examples.)
    next unless $siteName eq $name;

    ### We've found the record to update, so update the map ref value
    $mapref = $siteMapRef;

    ### Construct an updated record
    $_ = join( ":", $name, $location, $mapref, $type, $description );

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

### We now ``commit'' the changes by deleting the old file...
unlink $megalithFile
    or die "Can't delete old $megalithFile: $!\n";

### and renaming the new file to replace the old one.
rename $tempFile, $megalithFile
    or die "Can't rename '$tempFile' to '$megalithFile': $!\n";

exit 0;
