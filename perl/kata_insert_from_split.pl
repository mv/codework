#
# $Id: kata_insert_from_split.pl 6 2006-09-10 15:35:16Z marcus $

    my $sth = $dbh->prepare(<<SQL);
INSERT INTO call (recipient, calldate, calltime, duration)
VALUES (?, ?, ?, ?)
SQL

while (my $data = <FILE>) {
    my ($recipient, $date, $time, $duration) = split /:/, $data;
    $dbh->execute($recipient, $date, $time, $duration);
}
