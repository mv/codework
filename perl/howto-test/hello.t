#!perl

use strict;
use warnings;

# use Test::Simple tests => 1;
  use Test::Simple 'no_plan' ;

sub hello_world
{
    return "Hello, world!";
}

ok( hello_world(  ) eq "Hello, world!", "hello_world() output should be sane." );
