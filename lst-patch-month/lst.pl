#!perl
# $Id$
#

while( <> ) {
    ($dt, $patch) = split;
    push @{$lst{$dt}}, $patch;
}

foreach my $dt (sort keys %lst) {
    print $dt," ", join(",", @{ $lst{$dt} } ), "\n";
}

print "\n\n";

__END__

select TO_CHAR(creation_date, 'yyyy-mm-dd') as dt
     , patch_name
  from patches t
 where creation_date >= to_date( '2007-03-21','yyyy-mm-dd')
 order by creation_date
