#
# $Id: kata_selectall_arrayref.pl 6 2006-09-10 15:35:16Z marcus $

my $results = $dbh->selectall_arrayref(<<SQL);
   select recipient, calldate, calltime, $duration
   from call
   where duration > 60
   order by duration desc
SQL

for my $row (@$results) {
   my ($recipient, $calldate, $calltime, $duration) = @$row;
   ...
}
