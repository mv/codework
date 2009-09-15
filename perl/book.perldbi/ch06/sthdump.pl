#!/usr/bin/perl -w
#
# ch06/sthdump: Dumps information about a SQL statement

use DBI;

### Connect to the database
my $dbh = DBI->connect( undef, undef, undef, { RaiseError => 1 } );

### Prepare and execute an SQL statement
my $sth = $dbh->prepare( "SELECT * FROM user_tables--megaliths" );
$sth->execute();

print "\n";
print "Statement Info\n";
print "==============\n\n";
print "Statement:     $sth->{Statement}\n";
print "NUM_OF_FIELDS: $sth->{NUM_OF_FIELDS}\n";
print "NUM_OF_PARAMS: $sth->{NUM_OF_PARAMS}\n\n";

my $fields = $sth->{NUM_OF_FIELDS};

print "Column Name                     Type  Precision  Scale  Nullable?\n";
print "------------------------------  ----  ---------  -----  ---------\n\n";

### Iterate through all the fields and dump the field information
for ( my $i = 0 ; $i < $fields ; $i++ ) {

    my $name = $sth->{NAME}->[$i];

    ### Describe the NULLABLE value
    my $nullable = ("No", "Yes", "Unknown")[ $sth->{NULLABLE}->[$i] ];

    ### Tidy the other values, which some drivers don't provide
    my $scale = ($sth->{SCALE})     ? $sth->{SCALE}->[$i]     : "N/A";
    my $prec  = ($sth->{PRECISION}) ? $sth->{PRECISION}->[$i] : "N/A";
    my $type  = ($sth->{TYPE})      ? $sth->{TYPE}->[$i]      : "N/A";

    ### Display the field information
    printf "%30s  %4d      %4d   %4d   %s\n", $name, $type, $prec, $scale, $nullable;
}

exit;
