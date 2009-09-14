#!/usr/bin/perl
# $Id$
# Dez/2007
#

die <<Thanatos unless (@ARGV);

    Usage: $0 <files>

Thanatos


for my $file (@ARGV) {

    next unless -f $file;
    printf "File: $file\n";

    my ($dir) = $file =~ m/ \w+? _ \w+? _ (\d+) ([.]|_) /x;
    if ($dir) {
        print " Dir: $dir\n\n";
        system("mkdir  ${dir}")       unless -d $dir;
        system("/bin/mv $file ${dir}/");
    }
    else {
        print " Dir: invalid\n\n";
    }

}



