#!/usr/bin/perl

$on_a_tty = -t STDIN && -t STDOUT;

sub prompt { print "yes? " if $on_a_tty }

for ( prompt(); <STDIN>; prompt() ) {
    # do something
}

