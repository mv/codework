#!/usr/bin/perl -w
#
# ch02/marshal/datadumpertest: Creates some Perl variables and dumps them out.
#                              Then, we reset the values of the variables and
#                              eval the dumped ones...

use Data::Dumper;

### Customise Data::Dumper's output style
### Refer to Data::Dumper documentation for full details
if ($ARGV[0] eq 'flat') {
    $Data::Dumper::Indent = 0;
    $Data::Dumper::Useqq  = 1;
}
$Data::Dumper::Purity = 1;

### Create some Perl variables
my $megalith  = 'Stonehenge';
my $districts = [ 'Wiltshire', 'Orkney', 'Dorset' ];

### Print them out
print "Initial Values: \$megalith  = " . $megalith . "\n" .
      "                \$districts = [ ". join(", ", @$districts) . " ]\n\n";

### Create a new Data::Dumper object from the database
my $dumper = Data::Dumper->new( [    $megalith, $districts  ],
                                [ qw( megalith  districts ) ] );

### Dump the Perl values out into a variable
my $dumpedValues = $dumper->Dump();

### Show what Data::Dumper has made of the variables!
print "Perl code produced by Data::Dumper:\n";
print $dumpedValues . "\n";

### Reset the variables to rubbish values
$megalith = 'Blah! Blah!';
$districts = [ 'Alderaan', 'Mordor', 'The Moon' ];

### Print out the rubbish values
print "Rubbish Values: \$megalith  = " . $megalith . "\n" .
      "                \$districts = [ ". join(", ", @$districts) . " ]\n\n";

### Eval the file to load up the Perl variables
eval $dumpedValues;
die if $@;

### Display the re-loaded values
print "Re-loaded Values: \$megalith  = " . $megalith . "\n" .
      "                  \$districts = [ ". join(", ", @$districts) . " ]\n\n";

exit;


