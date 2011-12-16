#!/usr/bin/perl -w
#
# ch06/transact: Example showing transactions with RaiseError

use DBI;            # Load the DBI module


### Connect to the database with transactions and error handing enabled
my $dbh = DBI->connect( undef, undef, undef, {
    AutoCommit => 0,
    RaiseError => 1,
} )


foreach my $country_code ( qw(US GB IE FR) ) {

    print "Processing $country_code\n";

    ### Wrap all the work for one country inside an eval
    eval {

        ### Read, parse and sanity check the data file
        my $data = load_sales_data_file( "$country_file.csv" );

        ### Add data from the web (using the LWP modules)
	add_exchange_rates( $data, $country_code, "http://exchange-rate-service.com" );

	### Perform database loading steps
        insert_sales_data( $dbh, $data );
        update_country_summary_data( $dbh, $data );
        insert_processed_files( $dbh, $country_code );

	### Everything done okay for this file, so commit the database changes
	$dbh->commit;

    };

    ### if something went wrong...
    if ($@) {

	### tell the user that something went wrong, and what went wrong
        warn "Unable to process $country_code: $@\n";

	### Undo any database changes made before the error occured
	$dbh->rollback;

    }
}

$dbh->disconnect;

exit 0;
