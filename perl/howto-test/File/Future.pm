package File::Future;

use strict;

sub new
{
    my ($class, $filename) = @_;
    bless { filename => $filename }, $class;
}

sub retrieve
{
    # implement later...
    1;
}

1;
