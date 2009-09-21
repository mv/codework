#! /usr/bin/perl -w
#
# chmod on dirs and files
#

use strict;
use File::Find ();
use File::Basename;

use vars qw/*name *dir *prune/;
*name   = *File::Find::name;
*dir    = *File::Find::dir;
*prune  = *File::Find::prune;

my @suffixlist = qw/bat exe sh ksh pl py rb/;
my ($n,$p,$s);
sub wanted;

# Traverse desired filesystems
File::Find::find({wanted => \&wanted}, '.' );
exit;

sub wanted {
    my ($dev,$ino,$mode,$nlink,$uid,$gid);

    (($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_)) or warn "Cannot stat $_: $!";

    print $name, "\n";
    if(-d _) { chmod 0775, $_ ; return; }
    if(-f _) { chmod 0664, $_ ; }

    # executable based on suffixlist
    ($n,$p,$s) = fileparse($name,@suffixlist);
    chmod 0775,$_ if "$s";
}

1;
