#!/usr/bin/perl
# $Id: svn.validate.name.pl 336 2006-09-29 21:05:22Z marcus.ferreira $
#
# Marcus Vinicius Ferreira    ferreira.mv[ at ]gmai.com
#
# Apply rules to file names
#

use File::Basename;

while( <> ) {

    next if /^#/;
    next if /^\s*$/;
    next unless /^A/;     # Validate added files

    chomp;
    m/^A\s+(.*)/; $_ = $1; # ignores 1st column

    $err{'acentos'}++       if ( /[ãõñáéíóúàèìòùâêîôûç]/i );
    $err{'acentos'}++       if ( /\?\\\d\d\d/i ); # octal
    $err{'espacos'}++       if ( /\s\w/ );
    $err{'invalidos'}++     if ( /[~\(\)\{\}\[\]]/ );
    $err{'redundancias'}++  if ( /_-_|_d[aeo]s?_|_n[ao]s?_|_para_|_com_|_em_/ );
    $err{'redundancias'}++  if ( / - | d[aeo]s? | n[ao]s? | para | com | em / );

    $err{'too_long'}++      if ( length($file = fileparse( $_ )) ) > 51;
}

@errors = (sort keys %err);
# print "keys = ",scalar(@keys), "\n";

if( @errors ) {
    print "SVN Commit:\n";
    print "SVN Commit: Nomes de arquivo invalidos:\n";
    print "SVN Commit: ---------------------------\n";
    foreach (@errors) {
        printf "SVN Commit: %-12s: %2d\n", $_, $err{$_};
    }
    print "SVN Commit:\n";
    exit 1;
}

exit 0;
