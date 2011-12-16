#!/usr/bin/perl
#
# DBI Drivers installed
#
# Marcus Vinicius Ferreira
#

use DBI;

@driver_names = DBI->available_drivers;


foreach $driver_name (@driver_names)
{
    print "  Driver : $driver_name \n";

    @data_sources = DBI->data_sources($driver_name, \%attr);
    # next if ( $driver_name eq "Proxy" );
    foreach $data_source (@data_sources)
    {
        print "      DSN : $data_source \n";

    }
}
