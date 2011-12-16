#!/usr/bin/perl -w
#
# ch06/dbhdump: Dumps information about a SQL statement.

use DBI;

### Connect to the database
my $dbh = DBI->connect( undef, undef, undef, {
    RaiseError => 1
} );

### Create a new statement handle to fetch table information
my $tabsth = $dbh->table_info();

### Print the header
print "Qualifier  Owner     Table Name                       Type   Remarks\n";
print "=========  ========  ===============================  =====  =======\n\n";

### Iterate through all the tables...
while ( my ( $qual, $owner, $name, $type, $remarks ) = 
            $tabsth->fetchrow_array() ) {

    ### Tidy up NULL fields
    foreach ($qual, $owner, $name, $type, $remarks) {
        $_ = "N/A" unless defined $_;
    }

    ### Print out the table metadata...
    printf "%-9s  %-9s %-32s %-6s %s\n", $qual, $owner, $name, $type, $remarks;
}

exit;
