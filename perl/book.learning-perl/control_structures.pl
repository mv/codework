#!/usr/bin/perl

# Control structures:
#   if/else/elsif
#   unless
#
#   while(true) { }
#   until(true) { }
#   do { } while (true);
#   do { } until (true);
#
#   for ( init ; test; incr ) { }
#   foreach $i ( @list ) { }

# lista
@array = ( 2, 4, 6, 8 );

foreach $i ( reverse @array ) {
    print "Elemento = $i \n";
};
print "\n----- \n\n";

# $_ : scalar default para listas
foreach ( @array ) {
    #print "Elemento = $_ \n";
    print ;
};

print "\n\n  FIM \n";
