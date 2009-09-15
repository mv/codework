package Tie::Folded;
use strict;
use Tie::Hash;
use vars qw(@ISA);
@ISA = qw(Tie::StdHash);
sub STORE {
    my ($self, $key, $value) = @_;
    return $self->{lc $key} = $value;
    } 
sub FETCH {
    my ($self, $key) = @_;
    return $self->{lc $key};
} 
sub EXISTS {
    my ($self, $key) = @_;
    return exists $self->{lc $key};
} 
sub DEFINED {
    my ($self, $key) = @_;
    return defined $self->{lc $key};
} 
1;
