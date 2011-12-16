#!perl
# $Id: lc_tar.pl 14 2007-03-08 15:16:58Z marcus.ferreira $
#
#

use Archive::Tar;
use File::Find;
use File::Basename;
use Getopt::Std;
my %opt =
    ( h => 0
    , f => 0
    );
Getopt::Std::getopts('hf:', \%opt);


my (%data_for, @tar, $filename);

die <<Thanatos unless (@ARGV);

    Usage: $0 -f <tar file> <dir 1> [<dir n>]

Thanatos

my @suffix_uc = qw/ sql tab ttb vw  ind col con
                    seq syn grt ddl
                    prc fun fnc pls trg
                    fmb rdf pll fmx plx rex fmt ogd wft
                    ldt msg mnu mmb mmx
                /;
my @suffix_nc = qw/ drv
                    txt xml txt htm html
                    sh  csh pl  pm
                    dsc eex
                    xls doc
                    zip gz  bz2 tar
                    jsp jav java
                /;
my @suffix = map { lc($_), uc($_) } @suffix_uc, @suffix_nc;
my (%nc, %uc);
$uc{$_}++ foreach (@suffix_uc);
$nc{$_}++ foreach (@suffix_nc);


# List
File::Find::find( \&wanted , @ARGV );

# Create Tar
my  $file = Archive::Tar->new();
    $file->add_files( (sort keys %data_for) );
foreach my $k (sort keys %data_for) {
    #print " ren:  $k ", $data_for{$k},"\n";
    $file->rename( $k, $data_for{$k} );
}
    $file->write( $opt{f}, 9) or die "Cannot create tar file: $!";

#
print "\nTar file created.\n\n";
exit 0;

sub wanted {
    my ($dev,$ino,$mode,$nlink,$uid,$gid);
    my ($f, $d, $e);

    (($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_));
    $filename = $File::Find::name;
    $filename =~ tr/çãõñáéíóúàèìòùâêîôû¦ /caonaeiouaeiouaeioua_/;
    $filename =~ tr/ÇÃÕÑÁÉÍÓÚÀÈÌÒÙÂÊÎÔÛ|#/caonaeiouaeiouaeiou__/;

    if( -f _) {
        ($f, $d, $e) = fileparse( $filename, @suffix ); # print "    ext: $e\n";
        if( $uc{ lc($e) } ) { $filename = lc($d) . uc($f) . lc($e); }
        else {                $filename = lc($d) .    $f  . lc($e); }
    }
    elsif( -d _) {
        $filename = lc($filename);
    }
    # show_chr($filename);
    # push @tar, $filename;
    $data_for{$File::Find::name} = $filename;
    return;
}

sub show_chr {
    my $word = shift;
    foreach my $c (split //, $word) {
        printf "  c: %s:  asc %3d   chr %s  oct %o\n", $c, ord($c), chr(ord($c)), ord($c);
    }
    return;
}
