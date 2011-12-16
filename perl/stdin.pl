
###
    do {
        $line = <STDIN>;
        ...
    } until $line eq ".\n";

###
    if ( (my $color = <STDIN>) =~ /red/i ) {
        $value = 0xff0000;
    }
    elsif ($color =~ /green/i) {
        $value = 0x00ff00;
    }
    elsif ($color =~ /blue/i) {
        $value = 0x0000ff;
    }
    else {
        warn "unknown RGB component `$color', using black instead\n";
        $value = 0x000000;
    }
###
    if ( (my $color = <STDIN>) =~ /red/i  ) { $value = 0xff0000; }
    elsif (             $color =~ /green/i) { $value = 0x00ff00; }
    elsif (             $color =~ /blue/i ) { $value = 0x0000ff; }
    else {
        warn "unknown RGB component `$color', using black instead\n";
        $value = 0x000000;
    }
    ###
    my $color = <STDIN>
    for ($color) {
        $value = /red/      ?   0xFF0000  :
                 /green/    ?   0x00FF00  :
                 /blue/     ?   0x0000FF  :
                                0x000000  ;   # black if all fail
    } # or use a HASH !!!


###
    $on_a_tty = -t STDIN && -t STDOUT;
    sub prompt { print "yes? " if $on_a_tty }
    for ( prompt(); <STDIN>; prompt() ) {
        ...
    }

# vim:ft=perl:

