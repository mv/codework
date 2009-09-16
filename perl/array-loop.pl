#!/usr/bin/perl -w
#
# $Id: a_loop.pl 6 2006-09-10 15:35:16Z marcus $
# Marcus Vinicius Ferreira Jun/2003
#
# arrays and loops

@a = qw (An array of strings is shown here);

my $i=0;

print join (',', @a), "\n";

print "\n#1 \n";
for $item (@a) {
    print "Item  $i = $item \n";
    $i++;
}

print "\n#2 \n";
$i=0;
for ( $i=0; $i <= $#a; $i++ ) {
    print "  Index[$i] = $a[$i] \n";
}

print "\n#3 \n";
$i=0;
while ($i <= $#a) {
    print " $i, $a[$i] \n";
    $i++;
}
