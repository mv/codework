#
# $Id: kata_fetchrow_array.pl 6 2006-09-10 15:35:16Z marcus $

my %calls;
while (my @row = $sth->fetchrow_array()) {
   my ($recipient, $calldate, $calltime, $duration) = @row;
   $calls{$recipient} += $duration;
   print "Called $recipient on $calldate\n";
}
