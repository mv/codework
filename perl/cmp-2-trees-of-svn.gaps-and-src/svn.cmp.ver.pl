#!perl
# $Id$
#
# Compara svn rev entre gaps e src
#
# Marcus Vinicius Ferreira
# Nov/2006
#


my %gap_of;
my %src_of;
my ($file, $rev, $dir, );

my $g = 0;
my $s = 0;
my $k1= 0;

open my $gap, "<", "rev.gaps.2006-11-08.txt" or die "Cannot open gaps: $!";
open my $src, "<", "rev.src.2006-11-08.txt"  or die "Cannot open src: $!";

    while( <$gap> ) {

        ($file, $rev, $dir) = split;
        $gap_of{ $file } = [ $rev, $dir ];
        $g++;
    }

    while( <$src> ) {

        ($file, $rev, $dir) = split;
        $src_of{ $file } = [ $rev, $dir ];
        $s++;
    }

close $gap or die "Cannot  close gaps: $!";
close $src or die "Cannot  close src: $!";

print "Loaded...\n";
print "gaps $g ", scalar( %gap_of ), "\n";
print "src  $s ", scalar( %src_of ), "\n\n";

foreach my $file ( sort keys %gap_of ) {

    $rev = $gap_of{ $file }->[0];
    $dir = $gap_of{ $file }->[1];

    if( ! exists $src_of{ $file } ) {
        next;

        print $file, "\n";
        print "    NAO CADASTRADO NO src\n";
    }
    #
    if( $rev > $src_of{ $file }->[0] ) {
        $k1++;
        printf "%4d. %s\n",$k1,$file;
        printf "              %5s: trunk/gaps/%s\n", $rev, $dir;
        printf "              %5s: %s\n", @{ $src_of{$file} };
        print "\n";
    }
}

