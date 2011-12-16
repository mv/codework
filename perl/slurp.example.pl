
= begin BestPractices
# Simple slurp
    my $code = do { local $/; <$in> };

# File open
    open my $in, "<", $filename or croak "Cannot open $filename: $!";
    close $in                   or croak "Cannot close $filename: $!";

# trim
    $text =~ s{\A \s+ | \s+ \z }{}xms;
        # |  - OR regex operator

# Regex
        # x: whitespace
        # m: match ^ and $ inside each line (in a multiline string)
        #    no /m - match ^ and $ once.
        #
        # s: (.*) matches newlines also
        #
        # \A - begin of STRING
        # \z - end   of STRING
        # \Z - end   of STRING + \n final
        #
        # \G - positional for last match. Needs /gc

    (?:\d+) - no capturing
    [.]     - single dot, instead of \.
    [ ]     - single space
    (.*)    - much as possible and backtrack... (slow)
      best: - /([^%]*) % ([^:]* : ([^&]) &/xms

# Arguments: named
    sub mysub {
        my ($text, $arg_ref) = @_;

        $arg_ref->{col}
        $arg_ref->{lines}

    }
croak: Chap 13

# Reference to avoid too much indirection
    sub mysub {
        my $ref = \$Object4Patch->{filename};
        ...

        ${$ref} = lc( ${$ref} . '.ldt' );

    }

= end BestPractices

= cut
