#!/usr/bin/perl -w
#
# ch02/updatemegadata/updatemegadatafixed: Updates the given megalith data file
#                                     for a given site.
#                                     Uses fixed-length data and updates the
#                                     map reference field.
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
    ### Skip the record if the site name doesn't appear at the start
    next unless m/^\Q$siteName/;

    ### Skip the record if the extracted site name field doesn't match
    next unless unpack( "x64 x64 A16", $_ ) eq $siteName;

    ### Perform in-place substitution to upate map reference field
    substr( $_, 64+64, 16, pack( "A16", $siteMapRef ) );

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
