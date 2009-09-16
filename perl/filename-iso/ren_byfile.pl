#!/usr/bin/perl
# $Id$
# Marcus Vinicius Ferreira    ferreira.mv[ at ]gmail.com
# Set/2006
#

my ($old, $new);
my (@old, @new);

use Getopt::Std;
my %opt =
    ( o => 0
    , n => 0
    , h => 0
    );
Getopt::Std::getopts('ho:n:', \%opt);

$new = $opt{n};
$old = $opt{o};

usage() unless ($old && $new);

@old = get_lines( $old );
@new = get_lines( $new );

for my $i ( 0 .. $#old ) {

    next if( $old[$i] eq $new[$i] );

    print "    ", $old[$i], "\n => ", $new[$i], "\n";

    $old[$i] =~ s/\"//g;
    $new[$i] =~ s/\"//g;
    rename $old[$i], $new[$i];# or warn "    $old[$i] Warn: $!";

    $i++;
    #print "$i \n";
};

print "old: $old ", scalar(@old), "\n";
print "new: $new ", scalar(@new), "\n";


exit 0;

sub get_lines {
    my $file = shift;
    my @lines;

    open( FILE,"<",$file) or die "Cannot open  $file: $!";
    @lines = <FILE>;
    close(FILE);

    chomp(@lines);
    return(@lines);
};

sub usage {

    print <<USAGE;

    Usage: $0 -o <old> -n <new>

        Rename files based on 2 lists informed.

USAGE
exit 2;

};
