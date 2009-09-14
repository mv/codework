#!perl

use strict;
use warnings;

use Test::More tests => 4;

use_ok( 'Greeter' ) or exit;

my $greeter = Greeter->new( name => 'Emily', age => 21 );
isa_ok( $greeter, 'Greeter' );

is(   $greeter->age(), 21, 'age() should return age for object' );

like( $greeter->greet(), qr/Hello, .+ is Emily!/
                      , 'greet() should include object name' );

