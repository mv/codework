#!/usr/bin/perl -w
#
# ch04/util/trace1: Demonstrates the use of DBI tracing.

use DBI;

### Remove any old trace files
unlink 'dbitrace.log' if -e 'dbitrace.log';

### Connect to a database
my $dbh = DBI->connect( undef, undef, undef );

### Set the tracing level to 1 and prepare()
DBI->trace( 1 );
doPrepare();

### Set trace output to a file at level 2 and prepare()
DBI->trace( 2, 'dbitrace.log' );
doPrepare();

### Set the trace output back to STDERR at level 2 and prepare()
DBI->trace( 2, undef );
doPrepare();

exit;

### prepare a statement (invalid to demonstrate tracing)
sub doPrepare {
    print "Preparing and executing statement\n";
    my $sth = $dbh->prepare( "
        SELECT * FROM megalith
    " );
    $sth->execute();
    return;
}

exit;
