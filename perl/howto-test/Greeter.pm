package Greeter;

sub new
{
    my ($class, %args) = @_;
    bless \%args, $class;
}

sub name
{
    my $self = shift;
    return $self->{name};
}

sub age
{
    my $self = shift;
    return $self->{age};
}

sub greet
{
    my $self = shift;
    return "Hello, my name is " . $self->name() . "!";
}

1;
