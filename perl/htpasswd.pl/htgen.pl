#!/usr/bin/perl
# $Id: htgen.pl 2175 2006-10-25 17:28:28Z marcus.ferreira $
#
# htpasswd generator
#
#   Forget?
#       -> generate random
#       -> email
#       => Usuario nao cadastrado! Contacte admin: marcus.ferreira@mdb.com.br
#
my $htp="htpasswd2";
my $file="svn_htpasswd";
my $cmd;

$cmd="$htp -cb $file "; # first time
$cmd="$htp -b  $file "; # new users

while( <> ) {
    next if /^#/;
    next if /^\s*$/;
    chomp;

    $user    = $_;
    ($first) = split /\./, $user;
    $passwd  = sprintf '%ssvn%02d',$first,rand 100;
    $passwd  = $user;

    print "$cmd $user \t$passwd\n";
    $cmd="$htp -b  $file ";
}

