#!/usr/local/bin/perl

use strict;
use DBI;
use Time::localtime;
use Sprite::General;

my (
    $dbuser,            # database userid/passwd
    $dbname,            # as understood by TNS*Listener
    $dbh,               # database handle
    $sth,               # statement handle
    @row,               # row returned from select statement

    $time,              # time of run
    $tm,                # reference to localtime hash
    $started,           # the time the instance started

    $out_dir,           # the directory for output
    $out_file,          # the file to append to ( creates if non-existent )

    %val,               # hash for rows from (mostly) v$sysstat
    $bchr,              # buffer cache hit ratio
    $dchr,              # dictionary cache hit ratio
    $memsrt,            # memory sort percentage
    $shrdpfree,         # shared pool free percentage
    $shrdprel,          # shared pool reload percentage
    $wtwl,              # willing to wait latch get percentage
    $imml,              # immeidate latch get percentage
    $lcghr,             # library cache get hit ratio
    $lcphr,             # library cache pin hit ratio
    $rdospc,            # redo space contention
    $rdoalloc,          # redo latch allocation contention
    $rbckcntsn,         # rollback contention
    $recursv,           # recursive SQL percentage
    $shrtblscn,         # short table scans as % of all table scans
    $prsex,             # percentage of CPU used in parsing
    $chnd,              # chained row fetch as percentage of rows
    $freelist,          # freelist contention

    %ts_size,           # hash of tablespace name and size in blocks
    %ts_free,           # hash of tablespace name and amount free in blocks
    %ts_pct,            # hash of tablespace name and percent used in blocks
    $ts,                # a tablespace ( key for above hashes )
    $ts_max,            # Value of fullest tablespace
    $ts_tot,            # Used to find average
    $i,                 # Used to find average
    $ts_avg,            # average
    $db_free,           # count of free blocks in the database
    $db_size,           # total size of database
    $db_block_size,     # size of a database block
    $datasize,          # the size of actual data

    $colours,           # string of colour codes to display qualitative info
    $check,$a,$b,       # values for colour comparison
);


$dbuser = $ENV{ORACLE_USERID};
$db_block_size = 4096;  # Should query database as can differ between DBs

unless (@ARGV == 1) { die "$0: collect dbname " }
$dbname = $ARGV[0];

$out_dir = "/var/orca/orcora/$dbname";
#$out_dir = ".";

$time = time;
$tm = localtime($time);

$out_file = sprintf "$out_dir/orcora-%04d-%02d-%02d",
        ($tm->year)+1900, ($tm->mon)+1, $tm->mday;

unless ( open OUT, ">> $out_file" ) {
    &mail_err ( $ENV{MAILIDS} , "ERR:$0",  "Can't write $out_file : $!\n" ),
    die "Can't write $out_file : $!"
};

# connect to the database
$dbh = DBI->connect("dbi:Oracle:$dbname", $dbuser, '',
                                { RaiseError => 1, AutoCommit => 1 });
unless ( $dbh ) {
    &mail_err ( $ENV{MAILIDS} , "ERR:$0" , "Could not connect to $dbname as $dbuser\nError code
: $DBI::errstr\n" );
    die "Could not connect to $dbname as $dbuser\nError code : $DBI::errstr\n" ;
    }

# First the simple ones which return one value

# Instance start time
$sth = $dbh->prepare ( "select to_char ( startup_time, 'DD-MM-YYYY_HH24:MI:SS' ) from
v\$instance" );

$sth->execute;
@row = $sth->fetchrow;
$sth->finish;
$started = $row[0];

# Rollback contention
$sth = $dbh->prepare ( "select sum(waits)/sum(gets) from v\$rollstat" );
$sth->execute;
@row = $sth->fetchrow;
$sth->finish;
$rbckcntsn = $row[0];

# Dictionary Cache Hit Ratio
$sth = $dbh->prepare ( "select sum(gets-getmisses)*100/sum(gets) from v\$rowcache" );
$sth->execute;
@row = $sth->fetchrow;
$sth->finish;
$dchr = $row[0];

# Shared Pool Reload Ratio
$sth = $dbh->prepare ( "select sum(reloads)/sum(pins)*100 from v\$librarycache
          where namespace in ('SQL AREA','TABLE/PROCEDURE','BODY','TRIGGER')" );
$sth->execute;
@row = $sth->fetchrow;
$sth->finish;
$shrdprel = $row[0];

# Next the one row returns which are produce more than one statistic

# Willing to Wait and Immediate Latch Ratios
$sth = $dbh->prepare ( "select sum(gets), sum(misses), sum(immediate_gets),
                             sum(immediate_misses) from v\$latch" );
$sth->execute;
@row = $sth->fetchrow;
$sth->finish;
$wtwl = 100 * ( $row[0] - $row[1] ) / $row[0];
$imml = 100 * ( $row[2] - $row[3] ) / $row[2];

# Library Cache Get and Pin Hit Ratios
$sth = $dbh->prepare ( "select sum(gethits), sum(gets), sum(pinhits), sum(pins)
                            from v\$librarycache" );
$sth->execute;
@row = $sth->fetchrow;
$sth->finish;
$lcghr = 100 * $row[0] / $row[1];
$lcphr = 100 * $row[2] / $row[3];

#Two rows, just to be annoying

# Redo Log Allocation Latch Contention
$sth = $dbh->prepare ( "select misses, gets, immediate_misses, immediate_gets
                         from v\$latch where name in
                               ('redo copy', 'redo allocation') " );
$sth->execute;
while ( @row = $sth->fetchrow ) {
    if ( $row[1]  > 0 ) { if ( $rdoalloc < ( $row[0] / $row[1]) )
                              { $rdoalloc = $row[0] / $row[1] }
                         }
    if ( $row[3]  > 0 ) { if ( $rdoalloc < ( $row[2] / $row[3]) )
                              { $rdoalloc = $row[2] / $row[3] }
                         }
}


# Finally, the values interpreted from v$sysstat
$sth = $dbh->prepare ( "select name, value from v\$sysstat
                        where name in
 ( 'consistent gets', 'db block gets', 'physical reads', 'recursive calls',
   'user calls', 'table scans (short tables)', 'table scans (long tables)',
   'sorts (memory)', 'sorts (disk)', 'table fetch continued row',
   'table scan rows gotten', 'table fetch by rowid', 'execute count',
   'parse count', 'CPU used by this session', 'parse time cpu',
   'redo log space requests', 'redo writes', 'free memory'
 )" );
$sth->execute;
while ( @row = $sth->fetchrow ) {
    $val{ $row[0] } = $row[1];
}

#And some extra values needed below

# for shared pool free
$sth = $dbh->prepare ( "select value from v\$parameter where
                        name = 'shared_pool_size' " );
$sth->execute;
@row = $sth->fetchrow;
$sth->finish;
$val { 'shared_pool_size' } = $row[0];

$sth = $dbh->prepare ( "select bytes from v\$sgastat where
                        name = 'free memory' " );
$sth->execute;
@row = $sth->fetchrow;
$sth->finish;
$val { 'free memory' } = $row[0];

# for free list contention
$sth = $dbh->prepare ( "select count from v\$waitstat where class = 'free list'");
$sth->execute;
@row = $sth->fetchrow;
$sth->finish;
$val { 'free list' } = $row[0];

# Now collect the raw data on tablespace sizes

$sth = $dbh->prepare ( "select tablespace_name, sum(blocks)
                        from sys.dba_data_files group by tablespace_name" );
$sth->execute;
while ( @row = $sth->fetchrow ) {
    $ts_size{ $row[0] } = $row[1];
}

$sth = $dbh->prepare ( "select tablespace_name, sum(blocks)
                        from sys.dba_free_space group by tablespace_name" );
$sth->execute;
while ( @row = $sth->fetchrow ) {
    $ts_free{ $row[0] } = $row[1];
}

$dbh->disconnect;

# Evaluate the values based on stats collected
eval {
$shrdpfree = 100 * $val{ 'free memory' } / $val{ 'shared_pool_size' };
};

eval {
$freelist = 100 * $val{ 'free list' } /
             ( $val{ 'consistent gets' } + $val{ 'db block gets' }  );
};

eval {
$bchr = 100.0 * ( $val{ 'consistent gets' } + $val{ 'db block gets' }
                                - $val{ 'physical reads' } )
              / ( $val{ 'consistent gets' } + $val{ 'db block gets' }  );
};

eval {
$recursv = 100 * $val{ 'recursive calls' } /
           ( $val{ 'recursive calls' } + $val{ 'user calls' } );
};

eval {
$shrtblscn = 100 * $val{ 'table scans (short tables)' } /
              (  $val{ 'table scans (short tables)' } + $val{ 'table scans (long tables)' } );
};

eval {
$memsrt = 100 * $val{ 'sorts (memory)' } /
          ( $val{ 'sorts (memory)' } + $val{ 'sorts (disk)' } );
};

eval {
$chnd = 100 * $val{ 'table fetch continued row' } /
          ( $val{ 'table scan rows gotten' } + $val{ 'table fetch by rowid' } );
};

eval {
$prsex = 100 * $val{ 'parse count' } /
          ( $val{ 'parse count' } + $val{ 'execute count' } );
};

eval {
$rdospc = 100 * $val{ 'redo log space requests' } / $val{ 'redo writes' };
};

# Tablespace % full
foreach $ts ( keys %ts_size ) {
    $ts_pct{ $ts } = 100 * ( 1 - $ts_free{ $ts } / $ts_size{ $ts } );
    $db_size += $ts_size{ $ts };
    $db_free += $ts_free{ $ts };
}
    $datasize = $db_size - $db_free;
    $datasize = $datasize * $db_block_size / 1024 / 1024 ; # i.e. in Mbytes
    $db_size = $db_size * $db_block_size /1024 / 1024; # i.e. in Mbytes
$ts_max = 0;
$ts_tot = 0;
foreach $ts ( keys %ts_pct ) {
    $ts_max = $ts_pct{ $ts } > $ts_max ? $ts_pct{ $ts } : $ts_max ;
    $ts_tot += $ts_pct{ $ts };
}
eval {
    $i = keys ( %ts_pct);
    $ts_avg = $ts_tot / $i;
};


#Now work out our colour coding
# B - db Block buffer
{
    if ( $bchr > 98 ) { $colours = $colours . "b" ; last }
    if ( $bchr > 92 ) { $colours = $colours . "g" ; last }
    if ( $bchr > 88 ) { $colours = $colours . "A" ; last }
    if ( $bchr > 60 ) { $colours = $colours . "R" ; last }
    $colours = $colours . "B" ;
}

# P - shared Pool
{
    if ( $shrdpfree > 30 ) { $colours = $colours . "b" ; last }
    if ( $shrdpfree > 7  ) { $colours = $colours . "g" ; last }
    else {
        $check = $lcghr > $lcphr ? $lcghr : $lcphr;
        $check = $dchr > $check ? $dchr : $check;
        {
            if ( $check > 96 ) { $colours = $colours . "g" ; last }
            if ( $check > 92 ) { $colours = $colours . "A" ; last }
            if ( $check > 85 ) { $colours = $colours . "R" ; last }
            $colours = $colours . "B" ;
        }
    }
}

# R - Redos
{
    if ( $rdospc > 2.0 ) { $a = 4 ; last }
    if ( $rdospc > 1.2 ) { $a = 3 ; last }
    if ( $rdospc > 0.8 ) { $a = 2 ; last }
    if ( $rdospc > 0.0 ) { $a = 1 ; last }
    $a = 0 ;
}
{
    if ( $rdoalloc > 5.0 ) { $b = 4 ; last }
    if ( $rdoalloc > 3.2 ) { $b = 3 ; last }
    if ( $rdoalloc > 2.5 ) { $b = 2 ; last }
    if ( $rdoalloc > 0.0 ) { $b = 1 ; last }
    $b = 0 ;
}
$check = $a > $b ? $a : $b;
{
    if ( $check == 4 ) { $colours = $colours . "B" ; last }
    if ( $check == 3 ) { $colours = $colours . "R" ; last }
    if ( $check == 2 ) { $colours = $colours . "A" ; last }
    if ( $check == 1 ) { $colours = $colours . "g" ; last }
    $colours = $colours . "w" ;
}



# s - Sorts
{
    if ( $memsrt > 99 ) { $colours = $colours . "b" ; last }
    if ( $memsrt > 92 ) { $colours = $colours . "g" ; last }
    if ( $memsrt > 88 ) { $colours = $colours . "A" ; last }
    if ( $memsrt > 70 ) { $colours = $colours . "R" ; last }
    $colours = $colours . "B" ;
}


# r - Rollback segments
{
    if ( $rbckcntsn > 2.0 ) { $colours = $colours . "B" ; last }
    if ( $rbckcntsn > 1.0 ) { $colours = $colours . "R" ; last }
    if ( $rbckcntsn > 0.5 ) { $colours = $colours . "A" ; last }
    if ( $rbckcntsn > 0   ) { $colours = $colours . "g" ; last }
    $colours = $colours . "w" ;
}


# l - latches
if ( $wtwl < $imml ) { $check = $wtwl }
else                 { $check = $imml }
{
    if ( $check > 99.8 ) { $colours = $colours . "w" ; last }
    if ( $check > 99.2 ) { $colours = $colours . "g" ; last }
    if ( $check > 98.8 ) { $colours = $colours . "A" ; last }
    if ( $check > 97.0 ) { $colours = $colours . "R" ; last }
    $colours = $colours . "B" ;
}

# T - tablespaces
{
    if ( $ts_max > 99.5 ) { $colours = $colours . "B" ; last }
    if ( $ts_max > 95   ) { $colours = $colours . "R" ; last }
    if ( $ts_max > 90   ) { $colours = $colours . "A" ; last }
    if ( $ts_max > 60   ) { $colours = $colours . "g" ; last }
    $colours = $colours . "w" ;
}


# t - tables
if ( $chnd * 10 > $freelist ) { $check = $chnd * 10 }
else                 { $check = $freelist }
{
    if ( $check > 0.30 ) { $colours = $colours . "B" ; last }
    if ( $check > 0.15 ) { $colours = $colours . "R" ; last }
    if ( $check > 0.05 ) { $colours = $colours . "A" ; last }
    if ( $check > 0    ) { $colours = $colours . "g" ; last }
    $colours = $colours . "w" ;
}


# print it all out
if ( -z $out_file ) {
    print OUT "timestamp locltime started BPrsrlTt bchr dchr memsrt shrdpfree shrdprel wtwl imml
lcghr lcphr rdospc rdoalloc rbckcntsn recursv shrtblscn prsex chnd freelist tsmax tsavg dbsize
datasize";
    foreach $ts ( sort keys %ts_pct ) {
        print OUT " TS.$ts";
    }
    print OUT "\n";
}

printf OUT "$time %02d:%02d:%02d",
        $tm->hour, $tm->min, $tm->sec ;

printf OUT " %s", $started;
printf OUT " %s", $colours;
printf OUT " %0.2f %0.2f %0.2f %0.2f %0.2f %0.2f %0.2f",
        $bchr, $dchr, $memsrt, $shrdpfree, $shrdprel, $wtwl, $imml;
printf OUT " %0.2f %0.2f %0.2f %0.2f %0.2f %0.2f %0.2f",
        $lcghr, $lcphr, $rdospc, $rdoalloc, $rbckcntsn, $recursv, $shrtblscn;
printf OUT " %0.2f %0.2f %0.2f %0.2f %0.2f %0.2f %0.2f",
        $prsex, $chnd, $freelist, $ts_max, $ts_avg, $db_size, $datasize;

foreach $ts ( sort keys %ts_pct ) {
    printf OUT " %0.2f", $ts_pct{ $ts };
}
print OUT "\n";

close OUT;

