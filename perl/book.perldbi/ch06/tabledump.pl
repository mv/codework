#!/usr/bin/perl -w
#
# ch06/tabledump: Dumps information about all the tables.

use DBI;

### Connect to the database
my $dbh = DBI->connect( undef, undef, undef, {
    RaiseError => 1
});

### Create a new statement handle to fetch table information
my $tabsth = $dbh->table_info();

### Iterate through all the tables...
while ( my ( $qual, $owner, $name, $type ) = $tabsth->fetchrow_array() ) {

    ### The table to fetch data for
    my $table = $name;

    ### Build the full table name with quoting if required
    $table = qq{"$owner"."$table"} if defined $owner;

    ### The SQL statement to fetch the table metadata
    my $statement = "SELECT * FROM $table";

    print "\n";
    print "Table Information\n";
    print "=================\n\n";
    print "Statement:     $statement\n";

    ### Prepare and execute the SQL statement
    my $sth = $dbh->prepare( $statement );
    $sth->execute();

    my $fields = $sth->{NUM_OF_FIELDS};
    print "NUM_OF_FIELDS: $fields\n\n";

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
        printf "%-30s %5d      %4d   %4d   %s\n",
                $name, $type, $prec, $scale, $nullable;
    }

    ### Explicitly de-allocate the statement resources
    ### because we didn't fetch all the data
    $sth->finish();
}

exit;
