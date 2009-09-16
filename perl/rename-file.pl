#!/usr/bin/perl
# $Id$
#
# Marcus Vinicius Ferreira      ferreira.mv[ at ]gmail.com
#

die <<USAGE unless (@ARGV);

    Usage: adprenfile.pl <files>

        Rename files with filename in UPPERCASE
        and extension in lowercase.

USAGE

use File::Basename;

my $count=0;
for my $file ( @ARGV ) {

    next unless -f $file;
    print "File: $file\n";

    my ($name,$path,$ext) = fileparse($file, qr/\.[^.]*/ );
    my ($uname, $lext) = (uc $name, lc $ext);
    printf "     [%s] [%s] [%s]\n", $name, $ext , $path;
    printf "     [%s] [%s]     \n", $uname,$lext;

    if( $uname ne $name || $lext ne $ext ) {
        $count++;
        # Cygwin
        rename $file                      , $path . $uname . $lext . $$ or warn "    Rename 1: $!";
        rename $path . $uname . $lext . $$, $path . $uname . $lext      or warn "    Rename 2: $!";
    }

}

print "\nRenamed: $count file(s)\n\n";
