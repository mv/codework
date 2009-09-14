
use Test::More tests => 4;
use File::Future;

my $file = File::Future->new( 'perl_testing_dn.pod' );
isa_ok( $file, 'File::Future' );

TODO: {
    local $TODO = 'continuum not yet harnessed';

    ok( my $current = $file->retrieve( 'January 30, 2005' ) );
    ok( my $future  = $file->retrieve( 'January 30, 2070' ) );

    cmp_ok( length($current), '<', length($future),
        'ensuring that we have added text by 2070' );
}
