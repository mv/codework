#!/usr/bin/perl -w
#
# ch02/mldbmtest: Demonstrates storing complex data structures in a DBM
#                 file using the MLDBM module.

use MLDBM qw( DB_File Data::Dumper );
use Fcntl;

### Remove the test file in case it exists already...
unlink 'mldbmtest.dat';

tie my %database1, 'MLDBM', 'mldbmtest.dat', O_CREAT | O_RDWR, 0666
    or die "Can't initialize MLDBM file: $!\n";

### Create some megalith records in the database
%database1 = (
    'Avebury' => {
        name => 'Avebury',
        mapref => 'SU 103 700',
        location => 'Wiltshire'
    },
    'Ring of Brodgar' => {
        name => 'Ring of Brodgar',
        mapref => 'HY 294 133',
        location => 'Orkney'
    }
);

### Un-tie and re-tie to show data is stored in the file
untie %database1;

tie my %database2, 'MLDBM', 'mldbmtest.dat', O_RDWR, 0666
    or die "Can't initialize MLDBM file: $!\n";

### Dump out via Data::Dumper what's been stored...
print Data::Dumper->Dump( [ \%database2 ] );

untie %database2;

exit;
