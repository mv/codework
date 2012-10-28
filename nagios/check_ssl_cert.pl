#!/usr/bin/perl -w
#
# check_ssl_cert.pl
#
#     Check when a SSL certificate will expire.
#
#
# Marcus Vinicius Fereira            ferreira.mv[ at ].gmail.com
# 2012-10
#

###
### Plugin API
###
my $EXIT_OK       = 0;
my $EXIT_WARNING  = 1;
my $EXIT_CRITICAL = 2;
my $EXIT_UNKNOWN  = 3;

sub usage() {
    print "
Usage: $0 [-h] | -H www.example.com -w 60 -c 30

    This plugin checks when a SSL certificate will expire
    parsing the output of 'check_http -C'.

    -H : site URL.
    -w : warning  threshold. Default 60 days.
    -c : critical threshold. Default 30 days.
    -d : debug.

";
    exit 0;
}

###
### Command line processing
###
use Getopt::Std;

# Options defaults
my %opt =
    ( h => 0
    , H => ''
    , w => 60
    , c => 30
    , d => ''
    );

Getopt::Std::getopts('hH:w:c:d', \%opt);

if( $opt{'h'} ) {
    usage();
    exit 0;
}

if( !$opt{'H'} ) {
    usage();
    exit 4;
}

my $hostname = $opt{'H'};
my $warning  = $opt{'w'};
my $critical = $opt{'c'};
my $debug    = $opt{'d'};


###
### Parsing is here
###

#
# Force a big number (5 * 365)
# to have the following output:
#
#     WARNING - Certificate expires in 167 day(s) (04/13/2013 23:59).
#     WARNING - Certificate expires in \d+ day(s) (mm/dd/yyyy 23:59).
#

my $ssl_output = `check_http -H $hostname -C 1825`;

chomp($ssl_output);
if ( !$ssl_output ) {
    print "UNKNOWN - Unable to parse 'check_http' data: [$ssl_output].\n";
    exit $EXIT_UNKNOWN;
}

my ($expires)          = ($ssl_output =~ /expires \s+ in \s+ (\d+) \s+ day/xi );
my ($mon, $day, $year) = ($ssl_output =~ /(\d\d)\/(\d\d)\/(\d\d\d\d)/ );

###
### Results
###
my $message = sprintf "%s: SSL certificate will expire in %d days: %4d-%02d-%02d.",
                      $hostname, $expires, $year, $mon, $day;

if( $debug ) {
    print "\n";
    print "  Output: [$ssl_output]\n";
    print " Expires: [$expires]\n";
    print " Message: [$message]\n\n";
}

if ( $expires < $critical ) {
    print "CRITICAL - $message\n";
    exit $EXIT_CRITICAL;
}
elsif ( $expires < $warning ){
    print "WARNING - $message\n";
    exit $EXIT_WARNING;
}
else {
    print "OK - $message\n";
    exit $EXIT_OK;
}


# vim:ft=perl:

