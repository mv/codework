#!/usr/bin/perl
#

use strict;

my @files;
my @names;
my ($new,$old);

opendir(DIR, '.') or die "Cannot open dir: $!";
@files = grep { -f $_ } readdir(DIR) ;
close DIR;

print "qtd ", scalar(@files), "\n";
foreach (@files) {
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
