package hop;

use strict;

use Exporter;
use vars qw{@ISA @EXPORT @EXPORT_OK $VERSION};

$VERSION   = 0.1;
@ISA       = qw{Exporter};
@EXPORT    = qw{binary factorial total_size dir_walk dir_walk_cb};
@EXPORT_OK = qw{binary factorial total_size };

sub binary {
    my ($n) = @_;
    return $n if $n == 0 || $n == 1;

    my $k = int($n/2);  # n = 2k + b
    my $b = $n % 2;

    my $E = binary($k);
    return $E . $b;
}

sub factorial {
    my ($n) = @_;
    return 1 if $n == 0;

    return factorial($n-1) * $n;
}

sub total_size {
    my ($top) = @_; # print "top: $top\n";
    my $total = -s $top;
    return $total if -f $top || -l $top;

    my $DIR;
    unless (opendir $DIR, $top) {
        warn "Coundn't open directory [$top]: $!; skipping.\n";
        return $total;
    }

    my $file;
    while ($file = readdir $DIR ) {
        next if $file eq '.' || $file eq '..';
        $total += total_size("$top/$file");
    }

    closedir $DIR;
    return $total;
}

sub dir_walk {
    my ($top, $code) = @_;
    my $DIR;

    $code->($top);

    if( -d $top ) {
        my $file;
        unless( opendir $DIR, $top) {
            warn "Couldn't open directory $top: !$; skipping.\n";
            return;
        }
        while( $file = readdir $DIR ) {
            next if $file eq '.' || $file eq '..';
            dir_walk( "$top/$file", $code );
        }
    }
}

sub dir_walk_cb {
    my ($top, $filefunc, $dirfunc) = @_;
    my $DIR;

    if( -d $top ) {
        unless( opendir $DIR, $top ) {
            warn "Coundn't open directory $top: $!; skipping.\n";
            return;
        }

        my $file;
        my @results;
        while( $file = readdir $DIR ) {
            next if $file eq '.' || $file eq '..' ;
            push @results, dir_walk_cb( "$top/$file", $filefunc, $dirfunc );
        }

        return $dirfunc->($top, @results);
    }
    else { #( -f $top ) {
        return $filefunc->($top);
    }
}

1;
