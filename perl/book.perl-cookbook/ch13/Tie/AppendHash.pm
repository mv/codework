package Tie::AppendHash;
use strict;
use Tie::Hash;
use Carp;
use vars qw(@ISA);
@ISA = qw(Tie::StdHash);
sub STORE {
    my ($self, $key, $value) = @_;
    push @{$self->{key}}, $value;
} 
1;
