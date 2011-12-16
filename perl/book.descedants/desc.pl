#!/usr/bin/perl
# $Id$
# Programming Perl, 1st ed. (adpted)
#

open(DESC, "descendants.txt") || die "without issue\n";

# Load the kids of Job.

load_kids();

sub load_kids {
    my $parent = shift;
    my $name;

    # Process all the current parent's children.

    while( <DESC> ) {

        next if /^#/;
        last if /}/;

        # Extract name
        next unless /(\w.*\w)/;
        $name = $1;

        # Hash to store a tree
        $parent{$name} = $parent;

        # See if the kid has kids.

        if( /{/ ) {
            load_kids( $name );
        }
    }
}

# Now we ask which name to print the lineage of, and print it.

while(1) {
    print "Who: ";
    chomp( $who = <STDIN> );
    last unless $who;

    do_a_begat( $who );
}

sub do_a_begat {
    my $name = shift;

    if( $parent{$name} ) {
        do_a_begat( $parent{$name} );
        print "$parent{$name} begat $name\n";
    }
}

