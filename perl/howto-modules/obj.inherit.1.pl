package FOO;

sub new {
    my $type = shift;
    my $self = {};
    bless $self, $type;
}

sub baz {
    print "in FOO::baz()\n";
}

package BAR;
@ISA = qw(FOO);

sub baz {
    print "in BAR::baz()\n";
}

package main;

$a = BAR->new;
$a->baz;

