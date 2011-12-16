#!/usr/bin/perl

my $somedir = "/etc";

my $dir;
opendir $dir, $somedir;
print join "\n", (readdir $dir);
closedir $dir;
