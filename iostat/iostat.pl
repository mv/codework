#!/usr/bin/perl

# From:
#     http://jcole.us/software/iohist/iohist.pl
#     http://jcole.us/blog/archives/2007/05/08/on-iostat-disk-latency-iohist-onward/


use strict;
use Data::Dumper;

my $hist_width = 20;
my $hist_max = 37;

sub parse_stat
{
  my $line = shift;
  my %stat = ();

  $line =~ /^\s*([0-9]+)\s+([0-9]+)\s+([a-zA-Z0-9\/\-]+)\s+(.*)$/;
  $stat{'major'} = $1;
  $stat{'minor'} = $2;
  $stat{'device'} = $3;
  my $metric_line = $4;

  $metric_line =~ s/[ ]+/|/g;
  my @metrics = split /[|]/, $metric_line;

  $stat{'r_ios'}       = $metrics[0];
  $stat{'r_merges'}    = $metrics[1];
  $stat{'r_sectors'}   = $metrics[2];
  $stat{'r_ticks'}     = $metrics[3];
  $stat{'w_ios'}       = $metrics[4];
  $stat{'w_merges'}    = $metrics[5];
  $stat{'w_sectors'}   = $metrics[6];
  $stat{'w_ticks'}     = $metrics[7];
  $stat{'in_progress'} = $metrics[9];
  $stat{'ticks'}       = $metrics[10];
  $stat{'aveq'}        = $metrics[11];

  return \%stat;
}

sub get_stats
{
  my %stats = ();

  open STATS, "<", "/proc/diskstats";

  while(my $line = <STATS>)
  {
    my $stat = parse_stat($line);
    $stats{$stat->{'device'}} = $stat;
  }

  close STATS;
  return \%stats
}

sub diff_stat
{
  my $stat_a = shift;
  my $stat_b = shift;
  my $diff = {};

  my @metrics = (
    'r_ios', 'r_merges', 'r_sectors', 'r_ticks',
    'w_ios', 'w_merges', 'w_sectors', 'w_ticks',
    'unk', 'ticks', 'aveq'
  );

  foreach my $metric (@metrics)
  {
    $diff->{$metric} = $stat_a->{$metric} - $stat_b->{$metric};
  }

  my $a_ios   = ($diff->{'r_ios'} + $diff->{'w_ios'});
  $diff->{'r_svctm'} = $diff->{'r_ios'} ? $diff->{'r_ticks'} / $diff->{'r_ios'} : 0;
  $diff->{'w_svctm'} = $diff->{'w_ios'} ? $diff->{'w_ticks'} / $diff->{'w_ios'} : 0;
  $diff->{'a_svctm'} = $a_ios ? $diff->{'ticks'} / $a_ios : 0;

  return $diff;
}


sub max
{
  my $a = shift;
  my $b = shift;

  return $a>$b?$a:$b;
}

sub main
{
  my $old_stats = undef;
  my $new_stats = &get_stats;

  my %buckets = ();
  my %biggest_bucket = ();
  my %scaling_factor = ();

  my @bucket_names = (
    'r_svctm', 'w_svctm', 'a_svctm'
  );

  my $device = shift @ARGV;
  die("Unknown device") unless defined($new_stats->{$device});

  while(1)
  {
    sleep 1;
    $old_stats = $new_stats;
    $new_stats = &get_stats;

    my $diff = &diff_stat($new_stats->{$device}, $old_stats->{$device});

    foreach my $bucket (@bucket_names)
    {
      my $report_ms = $diff->{$bucket};
      if($report_ms > 0.0)
      {
        $biggest_bucket{$bucket} =
          max($biggest_bucket{$bucket}, ++$buckets{$bucket}[int($report_ms)]);
      }
      if($biggest_bucket{$bucket} > $hist_width)
      {
        $scaling_factor{$bucket} = $biggest_bucket{$bucket} / $hist_width;
      } else {
        $scaling_factor{$bucket} = 1;
      }
    }

    #printf "%10.2f%10.2f%10.2f\n", $diff->{r_svctm}, $diff->{w_svctm}, $diff->{a_svctm};

    print "ms ";
    foreach my $bucket (@bucket_names)
    {
      printf ": %-20s ", $bucket;
    }
    print "\n";
    for(my $x=0; $x < $hist_max; $x++)
    {
      printf "%2i ", $x;
      foreach my $bucket (@bucket_names)
      {
        printf ": %-20s ", "x" x int($buckets{$bucket}[$x] / $scaling_factor{$bucket});
      }
      print "\n";
    }
    printf "++ ";
    foreach my $bucket (@bucket_names)
    {
      my $value = 0;
      for(my $x=$hist_max; $x < 20000; $x++)
      {
        $value += $buckets{$bucket}[$x];
      }
      printf ": %-20i ", $value;
    }
    print "\n";
  }
}

&main;

