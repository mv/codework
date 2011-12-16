#!/usr/bin/perl

use Net::Ping;

my $my_addr="0.0.0.0";
my $p;                      # "ping" object
my $timeout = 3;           # in seconds

@host_array = ( "172.16.1.11"
              , "172.16.1.22"
              , "172.16.1.239"
              , "172.16.1.55"
              );

$p = Net::Ping->new("icmp");
$p->bind($my_addr);         # Specify source interface of pings

foreach $host (@host_array)
{
    print "$host is ";
    print "NOT " unless $p->ping($host, $timeout);
    print "reachable.\n";
    sleep(1);
}
$p->close();