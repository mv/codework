#!/usr/bin/perl -w
#
# ch02/marshal/update_dumper: Updates the given megalith data file
#                             for a given site. Uses Data::Dumper data
#                             and updates the map reference field.

use Data::Dumper;

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

### Customise Data::Dumper's output style to be flat and pure
### Refer to Data::Dumper documentation for full details
$Data::Dumper::Indent = 0;
$Data::Dumper::Useqq  = 1;
$Data::Dumper::Purity = 1;

### Open the data file for reading, and die upon failure
open MEGADATA, "<$megalithFile"
    or die "Can't open $megalithFile: $!\n";

### Open the temporary megalith data file for writing
open TMPMEGADATA, ">$tempFile"
    or die "Can't open temporary file $tempFile: $!\n";

### Scan through all the entries for the desired site
while ( <MEGADATA> ) {

    ### Quick pre-check for maximum performance:
    ### Skip the record if the site name doesn't appear
    next unless m/\Q$siteName/;

    ### Evaluate perl record string to set $fields array reference
    my $fields;
    eval $_;
    die if $@;

    ### Break up the record data into separate fields
    my ( $name, $location, $mapref, $type, $description ) = @$fields;

    ### Skip the record if the extracted site name field doesn't match
    next unless $siteName eq $name;

    ### We've found the record to update
    ### Create a new fields array with new map ref value
    $fields = [ $name, $location, $siteMapRef, $type, $description ];

    ### Convert it into a line of perl code encoding our record string
    $_ = Data::Dumper->new( [ $fields ], [ 'fields' ] )->Dump();
    $_ .= "\n";

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
