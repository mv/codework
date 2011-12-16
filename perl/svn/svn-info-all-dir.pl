#!perl
# $Id$
# svncmp.pl
#

die <<Thanatos unless (@ARGV);

    Usage: $0 <dir>|<files>

Thanatos

use File::Basename;

my (@dir_of, @file_of);
my $item;

# Command-line
foreach $item (@ARGV) {

    push @dir_of, $item  if -d $item;
    push @file_of, $item if -f $item;
}

# List of dirs, NOT recursively
foreach $item (@dir_of) {
    push @file_of, $item if -f $item;
}

# Exec
foreach $item (@file_of) {
    printf "%-20s: %s %s\n", $item, get_ver($item), dirname($item) ;
}
exit 0;

sub get_ver {
    my $file = shift;
    if( -f $file ) {
        my @res = `svn info $file`;
        my %res = map {  split /:/, $_, 2 } @res;
        print "res@ $_" foreach @res;
        print "res% $_ > $res{$_}" foreach sort keys %res;
        return %res;
    };
    return 0;
}

1;

