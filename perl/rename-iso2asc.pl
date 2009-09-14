#!/usr/bin/perl
# $Id: ren_iso2asc.pl 6 2006-09-26 19:03:18Z marcus.ferreira $
# Marcus Vinicius Ferreira    ferreira.mv[ at ]gmail.com
# Set/2006
#

use strict;

my ($new,$old);

while ( <> ) {

    chomp;
    $old = $_;
    tr /ãáàâéèêõóòôúùûñç /aaaaeeeoooouuunc_/;
    tr /ÃÁÀÂÉÈÊÕÓÒÔÚÙÛÑÇ /AAAAEEEOOOOUUUNC_/;
    $new = $_;

    if($new eq $old) {
        print "File: keeping $old\n";
    }
    else {
        print "File: rename  $old \t $new\n";
        rename $old, $new ;
    };
};
