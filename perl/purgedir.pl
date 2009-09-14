#!/usr/bin/perl
# $Id: purgedir.pl 18152 2007-07-31 15:16:42Z marcus.ferreira $
# $Url: http://mdbebsfsw2.mdb.com.br:8080/repos/salto/trunk/atg/adpmake/db/sh/purgedir.pl $
# purgedir.pl
#

use strict;
use warnings;
use File::stat;
use File::Path;
use Getopt::Long;
use Pod::Usage;
my %opt_for =
            ( 'keep'        => 10
            , 'mtime'       => 10
            , 'quiet'       => 0
            , 'help'        => 0
            , 'man'         => 0
            );
Getopt::Long::Configure ("bundling");
Getopt::Long::GetOptions( \%opt_for
                        , 'keep|k=i'
                        , 'mtime|m=i'
                        , 'quiet|q'
                        , 'help|h'
                        , 'man'
                        ) ; #or pod2usage(2);
pod2usage( -verbose => 1 ) if $opt_for{'help'};
pod2usage( -verbose => 2 ) if $opt_for{'man'};

# print "argv: [$_]\n" foreach @ARGV;

my $Dir   = shift @ARGV || '.'; # DIR is remaining of @ARGV
my $Keep  = $opt_for{keep};
my $Mtime = $opt_for{mtime};
my (%Files,%Days);

pod2usage( -verbose => 1 ) unless $Dir;

if( ! -d $Dir ) {
    print "\nError: [$Dir] must be a directory\n\n" ;
    exit 1;
}

print<<EOF unless $opt_for{quiet};

Parameters:
-----------
    dir:   $Dir
    keep:  $Keep
    mtime: $Mtime

EOF

# Get files older than $Mtime
opendir(my $dh, $Dir) or die "Cannot open $Dir: $!";
my @files = sort readdir($dh);
closedir($dh);

chdir( $Dir ); # or stat will fail....

print "\nFiles:\n------\n" unless $opt_for{quiet};
my ($st,$days);
foreach my $file(@files) {
    #
    next if($file eq '.' or $file eq '..');
    $days = -M $file || '0';

    $st = stat($file);
    printf "    %-20s modified %2d days ago.\n", $file, $days unless $opt_for{quiet};
    $Days {$st->ino} = $days;
    $Files{$st->ino} = $file;
}

# Keeps $Keep number of files
my @Days = (reverse sort { $Days{$a} <=> $Days{$b}} keys %Days) ;
if($#Days <= $Keep) {
    print "\n    No files to remove. Keeping ", $#Days+1, " files.\n\n" ;
    exit;
}

print "\nKeeping:\n--------\n" unless $opt_for{quiet};
print "    Found   : ", $#Days + 1, " file(s).\n" ;
print "    Keeping : ", $Keep,".\n";

$#Days = $#Days - $Keep ;   # Shrink
print '    Removing: ', $#Days + 1, ".\n\n" ;

# Remove
print "Removing:\n---------\n" unless $opt_for{quiet};
foreach (@Days) {
    # printf "File: %s\n", $Files{$_};
    if( -d $Files{$_} ) {
        rmtree( $Files{$_} ) unless $opt_for{quiet};
    }
    else {
        unlink( $Files{$_} ) unless $opt_for{quiet};
    }
}

print "\n\n" unless $opt_for{quiet};
exit;


=head1 purgedir.pl

    purgedir.pl

=head1 SYNOPSIS


    Usage: purgedir.pl -d <dir_name>
                      [-k num_of_files] [-m num_of_days]

    Remove all files older than '-m days' keeping at least
    the last '-k' files.

=head1 OPTIONS

=over 8

=item B<-d|--dir>

Dir to purge.

=item B<-k|--keep>

Number of minimum files to keep.

=item B<-m|--mtime>

Modified time in days.

=item B<-h|--help>

Print a brief help message and exits.

=item B<--man>

Prints the manual page and exits.

=back

=head1 EXAMPLES

    1) purgedir.pl -d /u01/subversion/backup/repos/

        Removes files older than 10 days, will keep 10 most recent files.

    2) purgedir.pl -d /u01/subversion/backup/repos/ -m 2 -k 5

        Removes files older than 2 days, will keep 5 most recent files.

=head1 AUTHOR

    Marcus Vinicius Ferreira        <ferreira.mv [ at ] gmail.com>

=head1 COPYRIGHT AND DISCLAIMER

    This program is Copyright 2007 by Marcus Vinicius Ferreira

=cut

1;

__END__
