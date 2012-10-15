#!/usr/bin/perl

use Getopt::Std;

# Options defaults
my %opt =
    ( h => 0
    , H => ''
    , w => 60
    , c => 30
    );

Getopt::Std::getopts('hH:w:c:', \%opt);

if( $opt{'h'} ) {
   print "# I want help\n";
   exit 0;
}

print "Hostname: ", $opt{'H'} , "\n";
print " warning: ", $opt{'w'} , "\n";
print "critical: ", $opt{'c'} , "\n";



__DATA__

Ref
---
    Getopt:  http://perldoc.perl.org/Getopt/Std.html


Usage example
-------------

Usage: $0 [-h] | -H www.example.com -w 60 -c 30

    This plugin is a wrapper for Nagios 'check_http' plugin.

    Checks expire days for a SSL certificate.

    -H : Site URL
    -w : warning  threshold. Default 60 days.
    -c : critical threshold. Default 30 days.



Rascunho
--------


# API for plugins:
#    http://docs.icinga.org/latest/en/pluginapi.html

if $expires < $critical
then
    critical()
    exit 2;

elsif $expires < $warning
    warning()
    exit 1;
else
    ok('Will expire on yyyy-mm-dd')
    exit 0;
fi

### Undefined error:
exit 4;


