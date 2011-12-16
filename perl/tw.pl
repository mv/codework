#!/usr/bin/perl
# $Id$
#
# Marcus Vinicius Ferreira    ferreira.mv[ at ]gmai.com
#
# my mail paragraph formatter
#

use Text::Wrap;

$Text::Wrap::columns = 72 ;

my $ini_tab = "";   # Tab before first line
my $seq_tab = "";   # All other lines flush left

while( <> ) {

    if( m/^\s*$/ ) { print; next; };

    m/(^\s*)/; $seq_tab = $1 ;

    print wrap( $ini_tab, $seq_tab, $_);
    # print "[$seq_tab]\n";
}
