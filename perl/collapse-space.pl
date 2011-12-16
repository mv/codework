#!/usr/bin/perl

while(<>) {
    # multiple substitutions on the same string
        s/^\s+//;       # discard leading whitespace
        s/\s+$//;       # discard trailing whitespace
        s/\s+/ /g;      # collapse internal whitespace

    # shortcut
    # join(" ", split " " => $_);
}

# vim:ft=perl:

