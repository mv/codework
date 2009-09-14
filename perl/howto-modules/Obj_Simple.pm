package Obj_Simple;


sub new {
    my $this = shift;
    my $class = ref($this) || $this;
    my $self = {};
    bless $self, $class;
    # $self->initialize();

    print "this     = $this \n";
    print "ref this = ", ref($this), "\n";
    print "class    = $class \n";
    print "self     = $self\n";

    return $self;
}


sub initialize {
    my $self = shift;

    $self = {1,2};
    return $self;
}

1;
