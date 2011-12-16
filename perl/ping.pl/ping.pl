#!/usr/bin/perl
#
# $Id: ping.pl 6 2006-09-10 15:35:16Z marcus $
#
# Ping Wrapper
#   0: OK - host found
#   1: ERR - host unreachable
#
# Obs:
#       for ICMP it must be suid ROOT to run        :(
#       in Cygwin ICMP has no such pre-requisite    :)
#
# Created
#   Marcus Vinicius Ferreira    Jan/2004
#

use Net::Ping;

die <<USAGE unless @ARGV;

Usage: $0 <host> [<timeout>]

    Parameters
        host:       hostname or ip address
        timeout:    timeout in seconds. Default = 20s.

    Results
        0:          host found
        1:          host unreachable

USAGE

($host, $timeout) = @ARGV ;
$found = 0;
$elapsed = 0;
$timeout = 20 unless $timeout;  # default

$p = Net::Ping->new("icmp", 1 );    # tcp,udp,icmp.
                                    # For icmp must use cygwin or setuid root.

do {
    # Net::Ping returns
    #           1: host found
    #           0: host unreachable
    #       undef: IP not resolved
    $elapsed++;
    $found = $p->ping($host); # 1 sec for each ping
    #print "Elapsed $elapsed - $found \n";
} until ( $found || ( $elapsed >= $timeout )  );

$p->close ;

if ($found)
{
    print "Host $host replied after $elapsed second(s).\n";
    exit 0 ;
}
else
{
    print "Host $host UNREACHABLE after $elapsed second(s).\n";
    exit 1;
}

__END__;
