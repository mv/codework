#!/usr/bin/perl -w
#
# ch02/marshal/storablecumultest: Creates some Perl variables and dumps them
#                                 out cumulatively. Then, we read the data file
#                                 and print out the stored values.

use Storable qw( store_fd retrieve_fd );

### Create some Perl variables
my %stonehenge = (
    name => 'Stonehenge',
    mapref => 'SU 123 400',
    location => 'Wiltshire'
);
my %avebury = (
    name => 'Avebury',
    mapref => 'SU 103 700',
    location => 'Wiltshire'
);
my %brodgar = (
    name => 'Ring of Brodgar',
    mapref => 'HY 294 133',
    location => 'Orkney'
);

### Open up the output file to which we're going to store the data...
open OUTFILE, ">test.dat"
    or die "Can't open test.dat for writing: $!\n";

### Print them out, then store them cumulatively via Storable...
foreach my $ref ( \%stonehenge, \%avebury, \%brodgar ) {
    print "Initial Values:   name     = $ref->{name}\n" .
          "                  mapref   = $ref->{mapref}\n" .
          "                  location = $ref->{location}\n\n";
    store_fd( \%{ $ref }, \*OUTFILE );
}

### Close the data file and checks for errors like disk full
close OUTFILE
    or die "Error writing and closing test.dat: $!";

### Open the datafile for reading...
open INFILE, "<test.dat"
    or die "Can't open data file for reading: $!\n";

### Retrieve the values from the file into a *reference* to a hash!
for ( my $i = 0 ; $i < 3 ; $i++ ) {
    my $ref = retrieve_fd( \*INFILE );
    print "Re-loaded Values: name     = $ref->{name}\n" .
          "                  mapref   = $ref->{mapref}\n" .
          "                  location = $ref->{location}\n\n";
}

### Close the datafile
close INFILE;

exit;
