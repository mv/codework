#
# $Id: kata_prepare_inline.pl 6 2006-09-10 15:35:16Z marcus $
#

my $sth = $dbh->prepare(<<SQL);
   select recipient, calldate, calltime, $duration
   from call
   where duration > 60
   order by duration desc
SQL

$sth->execute;
