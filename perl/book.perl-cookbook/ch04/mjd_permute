#!/usr/bin/perl -w
# mjd_permute: permute each word of input
use strict;

while (<>) {
    my @data = split;
    my $num_permutations = factorial(scalar @data);
    for (my $i=0; $i < $num_permutations; $i++) {
        my @permutation = @data[n2perm($i, $#data)];
        print "@permutation\n";
    }
}

# Utility function: factorial with memorizing
BEGIN {
  my @fact = (1);
  sub factorial($) {
      my $n = shift;
      return $fact[$n] if defined $fact[$n];
      $fact[$n] = $n * factorial($n - 1);
  }
}

# n2pat($N, $len) : produce the $N-th pattern of length $len
sub n2pat {
    my $i   = 1;
    my $N   = shift;
    my $len = shift;
    my @pat;
    while ($i <= $len + 1) {   # Should really be just while ($N) { ...
        push @pat, $N % $i;
        $N = int($N/$i);
        $i++;
    }
    return @pat;
}

# pat2perm(@pat) : turn pattern returned by n2pat() into
# permutation of integers.  XXX: splice is already O(N)
sub pat2perm {
    my @pat    = @_;
    my @source = (0 .. $#pat);
    my @perm;
    push @perm, splice(@source, (pop @pat), 1) while @pat;
    return @perm;
}

# n2perm($N, $len) : generate the Nth permutation of S objects
sub n2perm {
    pat2perm(n2pat(@_));
}
