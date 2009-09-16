#!/usr/bin/perl -w
#
# $Id: rra_calc.pl 6 2006-09-10 15:35:16Z marcus $
#
# rra_calc.pl by Noah Leaman <noah@mac.com>
# http://www.ee.ethz.ch/~slist/rrd-users/msg08295.html
#


use strict;

if(!defined($ARGV[0])) {
    print "USAGE: $0 <step_size> <no_of_steps> <no_of_rows>\n";
    exit(0);
}

my   $step_size = $ARGV[0]; # --step (amount of time that defines the primary data points)
my $no_of_steps = $ARGV[1]; # steps  (number of steps used to define a single archive sample)
my        $rows = $ARGV[2]; # rows   (number of archive samples to store)

my $sample_size_secs = $step_size * $no_of_steps;
my $sample_size      = convert_to_time($sample_size_secs);
my $retention_secs   = $sample_size_secs * $rows;
my $retention        = convert_to_time($retention_secs);

print "\n";
print "Sample Resolution:        $sample_size ($sample_size_secs secs)\n";
print "Data Retention Timeframe: $retention ($retention_secs secs)\n";
print "\n";

sub convert_to_time {
    my $total_seconds = shift;
    my         $years = sprintf("%d",  $total_seconds / 31536000);
    my          $days = sprintf("%d", ($total_seconds - ($years * 31536000)) / 86400);
    my         $hours = sprintf("%d", ($total_seconds - ($years * 31536000) - ($days * 86400)) / 3600);
    my       $minutes = sprintf("%d", ($total_seconds - ($years * 31536000) - ($days * 86400) - ($hours * 3600)) / 60);
    my       $seconds = sprintf("%d",  $total_seconds - ($years * 31536000) - ($days * 86400) - ($hours * 3600) - ($minutes * 60));
    my $formated_time = sprintf("%3dy %3dd %3dh %3dm %3ds", $years, $days, $hours, $minutes, $seconds);
    return($formated_time);
}
