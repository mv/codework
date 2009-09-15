#!/usr/bin/perl -w
#
# ch02/marshal/storabletest: Create a Perl hash and store it externally. Then, 
#                            we reset the hash and reload the saved one.

use Storable qw( freeze thaw );

### Create some values in a hash
my $megalith = {
    'name' => 'Stonehenge',
    'mapref' => 'SU 123 400',
    'location' => 'Wiltshire',
};

### Print them out
print "Initial Values:   megalith = $megalith->{name}\n" .
      "                  mapref   = $megalith->{mapref}\n" .
      "                  location = $megalith->{location}\n\n";

### Store the values to a string
my $storedValues = freeze( $megalith );

### Reset the variables to rubbish values
$megalith = {
    'name' => 'Flibble Flabble',
    'mapref' => 'XX 000 000',
    'location' => 'Saturn',
};

### Print out the rubbish values
print "Rubbish Values:   megalith = $megalith->{name}\n" .
      "                  mapref   = $megalith->{mapref}\n" .
      "                  location = $megalith->{location}\n\n";

### Retrieve the values from the string
$megalith = thaw( $storedValues );

### Display the re-loaded values
print "Re-loaded Values: megalith = $megalith->{name}\n" .
      "                  mapref   = $megalith->{mapref}\n" .
      "                  location = $megalith->{location}\n\n";

exit;

