#!/usr/bin/perl -w
# psgrep - print selected lines of ps output by
#          compiling user queries into code

use strict;

# each field from the PS header
my @fieldnames = qw(FLAGS UID PID PPID PRI NICE SIZE
                    RSS WCHAN STAT TTY TIME COMMAND);

# determine the unpack format needed (hard-coded for Linux ps)
my $fmt = cut2fmt(8, 14, 20, 26, 30, 34, 41, 47, 59, 63, 67, 72);
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

open(PS, "ps wwaxl |") || die "cannot fork: $!";
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
#123456789012345678901234567890123456789012345678901234567890123456789012345
#         1         2         3         4         5         6         7
# Positioning:
#      8     14    20    26  30  34     41    47          59  63  67   72
#      |     |     |     |   |   |      |     |           |   |   |    |
__END__
FLAGS  UID   PID   PPID  PRI NI  SIZE   RSS   WCHAN       STA TTY TIME COMMAND
   100   0     1      0    0  0   760   432   do_select     S   ? 0:02 init
   140   0   187      1    0  0   784   452   do_select     S   ? 0:02 syslogd
100100 101   428      1    0  0  1436   944   do_exit       S   1 0:00 /bin/login
100140  99 30217    402    0  0  1552  1008   posix_lock_   S   ? 0:00 httpd
     0 101   593    428    0  0  1780  1260   copy_thread   S   1 0:00 -tcsh
100000 101 30639   9562   17  0   924   496                 R  p1 0:00 ps axl
     0 101 25145   9563    0  0  2964  2360   idetape_rea   S  p2 0:06 trn
100100   0 10116   9564    0  0  1412   928   setup_frame   T  p3 0:00 ssh -C www
100100   0 26560  26554    0  0  1076   572   setup_frame   T  p2 0:00 less
100000 101 19058   9562    0  0  1396   900   setup_frame   T  p1 0:02 nvi /tmp/a
