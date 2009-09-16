#!perl
#
# $Id: ping_upd.pl 6 2006-09-10 15:35:16Z marcus $
#


# Populate sample data in ping.rrd
# (uses biggest RRA defined)

my ($step,$steps,$rows) = (300,288,797) ;
my $max_retention = $step * $steps * $rows ;

my $now = time() - 60 * 60 * 24 * 1.5 ; # 2 days ago
my $trip, $lost;

for (my $i=$now; $i < $now + $max_retention; $i += $step )
{
    $trip = 180 + rand(45) ;
    $lost = rand(20);
    system("rrdtool update ping.rrd $i:$trip:$lost ") ;
        # or die "system ( rrdtool update ) error $?";
}
