#!/usr/bin/perl -w
# psgrep - print selected lines of ps output by
#          compiling user queries into code

use strict;

# each field from the PS header
my @fieldnames = qw( F USER PID PPID PGID TT PRI NI
                     S CLS %MEM %CPU SZ RSS TIME ELAPSED
                     PSR COMMAND);

# determine the unpack format needed (hard-coded for Linux ps)
my $fmt = cut2fmt( 8, 14, 20, 26, 31, 39, 43, 46, 49, 53, 58, 65, 69, 80, 90, 97, 101);
my %fields; # where the data will store

die << Thanatos unless @ARGV;

usage: $0 criterion ...

    Each criterion is a Perl expression involving:
    @fieldnames
    All criteria must be met for a line to be printed.

Thanatos

# Create function aliases for uid, size, UID, SIZE, etc.
# Empty parens on closure args needed for void prototyping.
for my $name (@fieldnames) {
    no strict 'refs';
    *$name = *{lc $name} = sub ( ) { $fields{$name} };
}
my $code = "sub is_desirable { " . join(" and ", @ARGV) . " } ";
unless (eval $code.1) {
    die "Error in code: $@\n\t$code\n";
}

open(PS, "/usr/bin/ps -e -o f,user,pid,ppid,pgid,tty,pri,nice,s,class,pmem,pcpu,osz,rss,time,etime,psr,args |")
    || die "cannot fork: $!";
print scalar <PS>; # emit header line
while (<PS>) {
    @fields{@fieldnames} = trim(unpack($fmt, $_));
    print if is_desirable( ); # line matches their criteria
}
close(PS) || die "ps failed!";

# convert cut positions to unpack format
sub cut2fmt {
    my(@positions) = @_;
    my $template = '';
    my $lastpos = 1;
    for my $place (@positions) {
        $template .= "A" . ($place - $lastpos) . " ";
        $lastpos = $place;
    }
    $template .= "A*";
    return $template;
}

sub trim {
    my @strings = @_;
    for (@strings) {
        s/^\s+//;
        s/\s+$//;
    }
    return wantarray ? @strings : $strings[0];
}

# the following was used to determine column cut points.
# sample input data follows
#1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
#         1         2         3         4         5         6         7
# Positioning:
#      8     14    20    26   31      39  43 46 49  53   58     65  69         80       90      97  101
#      |     |     |     |    |       |   |  |  |   |    |      |   |          |        |       |   |
__END__
$ ps -e -o f,user,pid,ppid,pgid,tty,pri,nice,s,class,pmem,pcpu,osz,rss,time,etime,psr,args
 F     USER   PID  PPID  PGID TT      PRI NI S  CLS %MEM %CPU   SZ  RSS        TIME     ELAPSED PSR COMMAND
19     root     0     0     0 ?        96 SY T  SYS  0.0  0.0    0    0        0:06 61-17:22:33   - sched
 8     root     1     0     0 ?        58 20 S   TS  0.0  0.0  306  784       14:53 61-17:22:30   - /etc/init -
19     root     2     0     0 ?        98 SY S  SYS  0.0  0.0    0    0        0:00 61-17:22:30   - pageout
19     root     3     0     0 ?        60 SY S  SYS  0.0  0.6    0    0  2-17:14:12 61-17:22:30   - fsflush
19     root     4     0     0 ?        60 SY S  SYS  0.0  0.4    0    0  1-04:31:36 61-17:22:30   - cluster
 8     root  8994     1  8994 ?        59 20 S   TS  0.0  0.0  219  568        0:00 61-17:13:45   - /usr/lib/saf/sac -t 300
 8     root  7193     1  7193 ?        20 20 S   TS  0.0  0.0  360  840        0:00 61-17:18:05   - /usr/sbin/keyserv
 8     root    71     1    71 ?       100 RT S   RT  0.0  0.0 1354 1192        0:00 61-17:21:48   - /usr/cluster/lib/sc/clexecd
 8     root    20     1    20 ?        58 20 S   TS  0.1  0.0  603 3416        0:23 61-17:22:28   - vxconfigd -m boot
 8     root    72    71    72 ?       100 RT S   RT  0.0  0.0  564  776        0:01 61-17:21:48   - /usr/cluster/lib/sc/clexec
