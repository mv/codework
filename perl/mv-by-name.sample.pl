#!perl
# $Id: mvprd.pl 14400 2007-05-02 15:00:16Z marcus.ferreira $
#
# Move patch files according to 'prd' name
#     115mdbgpox007_001.zip -> po/
#     115mdbgwip410_002.zip -> wip/
#     etc...
#
# Marcus Vinicius Ferreira  Mar/2007        ferreira.mv[ at ]gmail[ dot ]com
#

use File::Copy;

die <<DIE unless(@ARGV);

    Usage: $0 <files>

DIE

print "$$\n";

foreach my $file (@ARGV) {

    next unless -f $file;

    ($dir) = ($file =~ m/115mdbg(\w\w\w)/x);
    $dir =~ s/x//;
    print "file: $file : $dir";
    if( move $file, $dir) { print "   ok \n"; }
    else                  { print "  err \n"; }

}

exit 0;

