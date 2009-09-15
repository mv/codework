#!/usr/bin/perl -w
#
# ch02/deletemegadata/deletemegadata: Deletes the record for the given
#                                     megalithic site. Uses
#                                     colon-separated data
#

### Check the user has supplied an argument to scan for
###     1) The name of the file containing the data
###     2) The name of the site to delete
die "Usage: deletemegadata <data file> <site name>\n"
    unless @ARGV == 2;

my $megalithFile  = $ARGV[0];
my $siteName      = $ARGV[1];
my $tempFile      = "tmp.$$";

### Open the data file for reading, and die upon failure
open MEGADATA, "<$megalithFile"
    or die "Can't open $megalithFile: $!\n";

### Open the temporary megalith data file for writing
open TMPMEGADATA, ">$tempFile"
    or die "Can't open temporary file $tempFile: $!\n";

### Scan through all the entries for the desired site
while ( <MEGADATA> ) {

    ### Extract the site name (the first field) from the record
    my ( $name ) = split( /:/, $_ );

    ### Test the sitename against the record's name
    if ( $siteName eq $name ) {

        ### We've found the record to delete, so skip it and move to next record
        next;
    }

    ### Write the original record out to the temporary file
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
